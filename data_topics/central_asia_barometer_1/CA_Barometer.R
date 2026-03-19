# Data Analysis of Central Asia Barometer Data 
# Ryan Womack
# first developed for presentation at 
# American University of Central Asia
# Spring 2026

# study our data
# the questionnaire
# the codebook

# loading data 
# note download data from CA Barometer at
# https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx

setwd("/home/ryan/R/")
library(readxl)
library(tidyverse)
mydata <- read_excel("cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx")
attach(mydata)

# the readr package gives other methods for loading data()

# the questionnaire is at
# central-asia-barometer-survey-wave-12-questionnaire-2022-autumn.pdf

# We select interesting variables from the questionnaire to analyze
# we'll also change their names to something more memorable 

# we want to study across several dimensions

# language, region, income, sex

# and relate this to opinions

# can spend some time looking at the codebook

# note MM4 is the country code, but we have already loaded the Kyrgyz file

names(mydata)

mydata <- mydata |> rename('Sex'='DD1', 'Region'='MM10', 'Language'='DD11','Income'='DD8')

# note Ethnic Group is already labeled 'EthnicGrp'

# we can generate descriptive statistics
# tables
# language, region, income, sex are general descriptive variables of interest

attach(mydata)
table(Sex)
table(Region)
table(Language)
table(Income)
table(EthnicGrp)

table(Sex,Language)
table(Income, Sex)
table(E17)

# recode income as numeric, coding to midpoint of range, roughly speaking

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

attach(mydata)
mean(Income_Numeric, na.rm=TRUE)

hist(Income_Numeric)

mydata |>
group_by(Sex) |> 
summarize(Inc = mean(Income_Numeric, na.rm=TRUE))

# t-tests or chi-sq for significance

# try a t-test
# is income significantly different by sex - yes

t.test(Income_Numeric~Sex)

# plots

# we can pick any general issue to focus on

# messenger app
# but everyone uses WhatsApp

table(DD1,A3a)

# something more general, like whether country is going in right or wrong direction

table(D1)
table(D1, Sex)
table(D1, Region)
table(D1, Language)
table(D1, Income_Numeric)

# recode to drop Don't Know and Refused

mydata$D1_recode <- recode_values(
  D1,
 "Right direction" ~ "Right",
 "Wrong direction" ~ "Wrong",
c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

mydata$D1_recode <- as.factor(mydata$D1_recode)

attach(mydata)

# Some illustrative plots
plot(Region~Income_Numeric)
boxplot(Income_Numeric~D1)
boxplot(Income_Numeric~D1_recode)

ggplot(mydata, aes(x=D1_recode))+facet_grid(~Sex)+geom_bar()

# doughnut chart (save for advanced)

hsize <-4 

percents <- mydata |>
  mutate(
    fraction = D1 / sum(D1),
    ymax = cumsum(fraction),
    ymin = c(0, head(ymax, -1))
  )

ggplot(mydata, aes(x = hsize, y = D1_recode, fill = Sex)) +
  geom_col() +
  coord_polar(theta = "y") +
  xlim(c(0.2, hsize + 0.5))

# try a logistic regression to predict answer to right direction question

logistic_output <- glm(D1_recode ~ Sex + Language + Income_Numeric, family=binomial, data=mydata)
summary(logistic_output)

# other possibilities

# b13 - russians in area - interesting vs region

# e17 how long with conflict with Ukr last (2022 survey , interesting)

# g3b general presidential favorability - breakdowns
# try a couple of examples, then pick other variables to work with

