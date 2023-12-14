library(foreign)
library(tidyverse)
library(FactoMineR)
library(factoextra)
library(plotly)

df <- read.arff("data/Medicaldataset.arff")
df <- df %>% rename(
  "Age" = age,
  "Gender" = gender,
  "Heart Rate" = impluse,
  "Systolic.blood.pressure" = pressurehight,
  "Diastolic.blood.pressure" = pressurelow,
  "Blood.sugar" = glucose,
  "CK.MB" = kcm,
  "Troponin" = troponin,
  "Result" = class
)
df <- df[df$`Heart Rate` != 1111, ]
df$Gender <- as.factor(df$Gender)
df$Result <- as.factor(df$Result)

res.famd <- FAMD(df[, -9], graph = F, ncp = 6)

res.pca <- prcomp(df[, -c(2, 9)], center = T, scale. = T)
summary(res.pca)

fviz_contrib(res.pca, choice = "var", axes = 1)

fviz_screeplot(res.pca)

eig.val <- get_eigenvalue(res.famd)
eig.val

fviz_screeplot(res.famd)

res.famd$ind$coord %>% 
  as.data.frame() %>% 
  plot_ly(x = ~Dim.1, y = ~Dim.2, z = ~Dim.3, 
          color = df$Result, size = I(40))
