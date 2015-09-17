# Next, we download packages that H2O depends on.
if (! ("methods" %in% rownames(installed.packages()))) { install.packages("methods") }
if (! ("statmod" %in% rownames(installed.packages()))) { install.packages("statmod") }
if (! ("stats" %in% rownames(installed.packages()))) { install.packages("stats") }
if (! ("graphics" %in% rownames(installed.packages()))) { install.packages("graphics") }
if (! ("RCurl" %in% rownames(installed.packages()))) { install.packages("RCurl") }
if (! ("rjson" %in% rownames(installed.packages()))) { install.packages("rjson") }
if (! ("tools" %in% rownames(installed.packages()))) { install.packages("tools") }
if (! ("utils" %in% rownames(installed.packages()))) { install.packages("utils") }
# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-simons/7/R")))
library(h2o)


localH2O <- h2o.init(nthreads = -1)  #Start up H2O cluster using nthreads = ncores


# Get training data:
data <- h2o.importFile("http://www.stat.berkeley.edu/~ledell/data/wisc-diag-breast-cancer-shuffled.csv",
                       destination_frame = "breast_cancer")
y <- "diagnosis"  #Response column
x <- setdiff(names(data), c(y, "id"))  #remove 'id' and response col


# Train & Test
set.seed(1)
ss <- h2o.splitFrame(data)  #split data into train & test partitions
training_frame <- ss[[1]]
validation_frame <- ss[[2]]

# Train a GBM
h2o_glm <- h2o.glm(x = x, y = y, 
                   training_frame = training_frame, 
                   validation_frame = validation_frame,
                   family = "binomial")
print(h2o_glm@model$validation_metrics@metrics$AUC)
# Test set AUC: 0.9935432

h2o.auc(h2o_glm, valid = TRUE)  #utility function to get AUC



# Cross-validated GBM
h2o_gbm <- h2o.gbm(x = x, y = y, 
                   training_frame = data, 
                   nfolds = 5,
                   family = "binomial", 
                   seed = 1)
print(h2o_gbm@model$cross_validation_metrics@metrics$AUC)
# CV AUC:  0.9894099


# Cross-validate a Random Forest
h2o_rf <- h2o.randomForest(x = x, y = y, 
                           training_frame = data, 
                           nfolds = 5,
                           family = "binomial",
                           seed = 1)
print(h2o_rf@model$cross_validation_metrics@metrics$AUC)




## Next demo

library(devtools)
install_github("h2oai/h2o-3/h2o-r/ensemble/h2oEnsemble-package")

library(h2oEnsemble)


## Higgs Demo

localH2O <-  h2o.init(nthreads = -1)  # Start an H2O cluster with nthreads = num cores on your machine


# Import a sample binary outcome train/test set into R
train <- read.table("http://www.stat.berkeley.edu/~ledell/data/higgs_10k.csv", sep=",")
test <- read.table("http://www.stat.berkeley.edu/~ledell/data/higgs_test_5k.csv", sep=",")


# Convert R data.frames into H2O parsed data objects
training_frame <- as.h2o(localH2O, train)
validation_frame <- as.h2o(localH2O, test)
y <- "V1"
x <- setdiff(names(training_frame), y)
family <- "binomial"
training_frame[,c(y)] <- as.factor(training_frame[,c(y)])  #Force Binary classification
validation_frame[,c(y)] <- as.factor(validation_frame[,c(y)])



# Specify the base learner library & the metalearner
learner <- c("h2o.glm.wrapper", "h2o.randomForest.wrapper", 
             "h2o.gbm.wrapper", "h2o.deeplearning.wrapper")
metalearner <- "h2o.deeplearning.wrapper"


# Train the ensemble using 5-fold CV to generate level-one data
# More CV folds will take longer to train, but should increase performance
fit <- h2o.ensemble(x = x, y = y, 
                    training_frame = training_frame, 
                    family = family, 
                    learner = learner, 
                    metalearner = metalearner,
                    cvControl = list(V = 5, shuffle = TRUE))


# Generate predictions on the test set
pred <- predict.h2o.ensemble(fit, validation_frame)
predictions <- as.data.frame(pred$pred)[,c("p1")]  #p1 is P(Y==1)
labels <- as.data.frame(validation_frame[,c(y)])[,1]

library(cvAUC)
# Ensemble test AUC 
AUC(predictions = predictions , labels = labels)
# 0.7888723


# Base learner test AUC (for comparison)
L <- length(learner)
auc <- sapply(seq(L), function(l) AUC(predictions = as.data.frame(pred$basepred)[,l], labels = labels)) 
data.frame(learner, auc)
#                   learner       auc
#1          h2o.glm.wrapper 0.6871288
#2 h2o.randomForest.wrapper 0.7711654
#3          h2o.gbm.wrapper 0.7817075
#4 h2o.deeplearning.wrapper 0.7425813

