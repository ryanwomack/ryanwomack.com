## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/womack/documents/ryan/Central_Asia/Central_Asia_Barometer/")


## ----install packages, eval=FALSE---------------------------------------------
# 
# install.packages("pak", dependencies=TRUE)
# library(pak)
# pkg_install("tidyverse")
# pkg_install("readxl")
# pkg_install("reticulate")
# devtools::session_info()
# 


## ----load packages, eval=TRUE, echo=TRUE--------------------------------------

library(readxl)
library(tidyverse)



## ----tidyverse----------------------------------------------------------------

# Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3")
library(reticulate)
use_python("/usr/bin/python3")



## ----download and import------------------------------------------------------

download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx", "CAB_2022.csv")
mydata <- read_excel("CAB_2022.csv")
mydata
attach(mydata)



## ----renaming-----------------------------------------------------------------

names(mydata)
mydata <- mydata |> rename('Sex'='DD1', 'Region'='MM10', 'Language'='DD11','Income'='DD8')
attach(mydata)



## ----descriptives-------------------------------------------------------------

table(Sex)
table(Region)
table(Language)
table(Income)
table(EthnicGrp)
table(Sex,Language)
table(Income, Sex)
table(E17)



## ----recode-------------------------------------------------------------------

mydata$Income_Numeric <- recode_values(
  Income,
  "Less than 2,801 som" ~ 1400,
  "2,801 - 4,100 som" ~ 3400,
  "4,101 - 6,000 som" ~ 5000,
  "6,001 - 8,000 som" ~ 7000,
  "8,001 - 10,000 som" ~ 9000,
  "10,001 - 12,000 som" ~ 11000,
  "12,001 - 16,000 som" ~ 14000,
  "16,001 - 20,000 som" ~ 18000,
  "20,001 - 28,000 som" ~ 24000,
  "More than 28,000 som" ~ 40000,
  c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)



## ----Income_Numeric-----------------------------------------------------------

attach(mydata)

mean(Income_Numeric, na.rm=TRUE)

hist(Income_Numeric)

mydata |>
group_by(Sex) |> 
summarize(Inc = mean(Income_Numeric, na.rm=TRUE))




## ----t-test-------------------------------------------------------------------

# t-tests or chi-sq for significance

# try a t-test
# is income significantly different by sex - yes

t.test(Income_Numeric~Sex)



## ----researching what to plot-------------------------------------------------

table(DD1,A3a)

table(D1)
table(D1, Sex)
table(D1, Region)
table(D1, Language)
table(D1, Income_Numeric)


## ----plot recode--------------------------------------------------------------

mydata$D1_recode <- recode_values(
  D1,
 "Right direction" ~ "Right",
 "Wrong direction" ~ "Wrong",
c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

mydata$D1_recode <- as.factor(mydata$D1_recode)

attach(mydata)



## ----illustrative plots-------------------------------------------------------

# Some illustrative plots
ggplot(data=mydata, aes(x=Income_Numeric, y=Region))+geom_point()
ggplot(data=mydata, aes(x=Region, y=Income_Numeric))+geom_jitter()
boxplot(Income_Numeric~D1)
boxplot(Income_Numeric~D1_recode)

ggplot(mydata, aes(x=D1_recode))+facet_grid(~Sex)+geom_bar()



## ----logistic-----------------------------------------------------------------

logistic_output <- glm(D1_recode ~ Sex + Language + Income_Numeric, family=binomial, data=mydata)
summary(logistic_output)


