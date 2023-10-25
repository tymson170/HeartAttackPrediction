library(e1071)
library(caret)
library(doSNOW)
library(ipred)
library(xgboost)
library(tidyverse)

train <- read.csv("C:/Users/48503/Desktop/TYMSON/STUDIA/SEMESTR 5/Projekt z zakresu analizy danych/StrokePrediction/Data/Medicaldataset.csv", stringsAsFactors = FALSE)

View(train)

# Braki danych
which(is.na(train))

# Nie ma braków danych więc git

# Zmiana rodzajów kolumn

str(train)
train$Result <- ifelse(train$Result == "positive", 1, 0)
View(train)

library(PerformanceAnalytics)

dane <- train[, 1:8]
str(dane)
dane$Gender <- as.numeric(dane$Gender)
chart.Correlation(dane)
histogram(train$CK.MB)

train[train$Heart.rate > 200, ]
library(tidyverse)
train <- train %>% 
  filter(Heart.rate != 1111)

train[train$Heart.rate > 200, ]

train %>% 
  arrange(-Blood.sugar) %>% 
  head()

str(train)
train$Gender <- as.factor(train$Gender)
train$Result <- as.factor(train$Result)

# Podział wiekowy: 0 - dzieci (0-17), 1 - dorośli (18-64), 2 - osoby starsze (64+)
train$Age2 <- ifelse(train$Age <= 17, 0, ifelse(train$Age<=64, 1, 2))
View(train)

# Tętno: 0 - prawidłowe (60-100), 1 - nieprawidłowe
train$Heart.rate2 <- ifelse(train$Heart.rate %in% 60:100, 0, 1)
View(train)

# Ciśnienie skurczowe: 0 - prawidłowe (90-120), 1 - nieprawidłowe

train$Systolic.blood.pressure2 <- ifelse(train$Systolic.blood.pressure %in% 90:120, 0, 1)

# Ciśnienie rozkurczowe: 0 - prawidłowe (60-80), 1 - nieprawidłowe

train$Diastolic.blood.pressure2 <- ifelse(train$Diastolic.blood.pressure %in% 60:80, 0, 1)

# Ogólne ciśnienei: 

View(train)

# Poziom cukru we krwi: 0 - normalny (0-99), 1 - poziom przedcukrzycowy (100-124), 2 - cukrzyca (125+)
train$Blood.sugar2 <- ifelse(train$Blood.sugar < 100, 0, ifelse(train$Blood.sugar < 125, 1, 2))
View(train)

# CK-MB: 1 - prawidłowe - (3-5), nieprawidłowe - 0
danepowyzej30 <- train %>% 
  filter(CK.MB <= 30) %>% 
  select(CK.MB)

histogram(danepowyzej30$CK.MB)

train %>% 
  select(CK.MB, Result) %>% 
  filter(CK.MB > 100)

View(train)

# Poziom troponiny: 0 - prawidłowy (0 - 0.04), 1 - nieprawidłowy (0.05+)

train$Troponin2 <- ifelse(train$Troponin <= 0.04, 0, 1)


train_1s <- train %>% 
  select(Age2, Gender, Heart.rate2, Systolic.blood.pressure2, Blood.sugar2, Troponin2, Result)

train_1d <- train %>% 
  select(Age2, Gender, Heart.rate2, Diastolic.blood.pressure2, Blood.sugar2, Troponin2, Result) 


# Factory

train_1s$Age2 <- as.factor(train_1s$Age2)
train_1s$Gender <- as.factor(train_1s$Gender)
train_1s$Heart.rate2 <- as.factor(train_1s$Heart.rate2)
train_1s$Systolic.blood.pressure2 <- as.factor(train_1s$Systolic.blood.pressure2)
train_1s$Blood.sugar2 <- as.factor(train_1s$Blood.sugar2)
train_1s$Troponin2 <- as.factor(train_1s$Troponin2)
train_1s$Result <- as.factor(train_1s$Result)

train_1d$Age2 <- as.factor(train_1d$Age2)
train_1d$Gender <- as.factor(train_1d$Gender)
train_1d$Heart.rate2 <- as.factor(train_1d$Heart.rate2)
train_1d$Diastolic.blood.pressure2 <- as.factor(train_1d$Diastolic.blood.pressure2)
train_1d$Blood.sugar2 <- as.factor(train_1d$Blood.sugar2)
train_1d$Troponin2 <- as.factor(train_1d$Troponin2)
train_1d$Result <- as.factor(train_1d$Result)


# Podział danych na treningowe i testowe

indexes <- createDataPartition(train_1s$Result, 
                               times = 1, 
                               p = 0.8, 
                               list = FALSE)
heart_attack_1s_train <- train_1s[indexes, ]
heart_attack_1s_test <- train_1s[-indexes, ]

prop.table(table(train$Result))
prop.table(table(heart_attack_1s_train$Result))
prop.table(table(heart_attack_1s_test$Result))

# Tworzenie modelu

train.control <- trainControl(method = "repeatedcv", 
                              number = 10, 
                              repeats = 3, 
                              search = "grid")

tune.grid <- expand.grid(eta = c(0.05, 0.075, 0.1), 
                         nrounds = c(50, 75, 100), 
                         max_depth = 6:8, 
                         min_child_weight = c(2.0, 2.25, 2.5), 
                         colsample_bytree = c(0.3, 0.4, 0.5), 
                         gamma = 0, 
                         subsample = 1)
View(tune.grid)

cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)
caret.cv <- train(Result ~ ., 
                  data = heart_attack_1s_train, 
                  method = "xgbTree", 
                  tuneGrid = tune.grid, 
                  trControl = train.control)
stopCluster(cl)

caret.cv

preds <- predict(caret.cv, heart_attack_1s_test)

confusionMatrix(preds, heart_attack_1s_test$Result)


# MODEL DLA DANYCH BINARNYCH Z CIŚNIENIEM ROZKURCZOWYM
# Podział danych na treningowe i testowe

indexes2 <- createDataPartition(train_1d$Result, 
                               times = 1, 
                               p = 0.8, 
                               list = FALSE)
heart_attack_1d_train <- train_1d[indexes2, ]
heart_attack_1d_test <- train_1d[-indexes2, ]

prop.table(table(train$Result))
prop.table(table(heart_attack_1d_train$Result))
prop.table(table(heart_attack_1d_test$Result))

# Tworzenie modelu
cl <- makeCluster(5, type = "SOCK")
registerDoSNOW(cl)
caret.cv2 <- train(Result ~ ., 
                  data = heart_attack_1d_train, 
                  method = "xgbTree", 
                  tuneGrid = tune.grid, 
                  trControl = train.control)
stopCluster(cl)

caret.cv2

preds2 <- predict(caret.cv2, heart_attack_1d_test)

confusionMatrix(preds2, heart_attack_1d_test$Result)
