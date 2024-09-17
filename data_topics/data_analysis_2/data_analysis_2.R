## ----setup, include=FALSE-------------------------------------------------------------------------------------------------

knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/data_topics/data_analysis2/")



## ----install packages, eval=FALSE-----------------------------------------------------------------------------------------
##
## install.packages("pak", dependencies=TRUE)
## library(pak)
## pkg_install("tidyverse")
## pkg_install("reticulate")
## pkg_install("infer")
## pkg_install("TOSTER")
## devtools::session_info()
##


## ----tidyverse------------------------------------------------------------------------------------------------------------

library(tidyverse)
library(infer)
library(TOSTER)
Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3")
library(reticulate)



## ----download and import data---------------------------------------------------------------------------------------------

getOption("timeout")
options(timeout=6000)
download.file("https://databank.worldbank.org/data/download/Gender_Stats_CSV.zip", "gender.zip")
unzip("gender.zip")
gender_data <- read_csv("Gender_StatsCSV.csv")



## ----data wrangling, results='hide'---------------------------------------------------------------------------------------

# clean the data to remove superfluous columns
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)

# select countries of interest
country_list <- c("China", "Germany", "India", "Japan", "Kazakhstan", "Kyrgyz Republic", "Mongolia", "Russian Federation", "Tajikistan", "Turkmenistan", "United States", "Uzbekistan")
gender_data2 <-
  gender_data %>%
  filter(`Country Name` %in% country_list)

# clean the data to focus on a recent more complete time period
gender_data3 <-
   gender_data2 %>%
   pivot_longer(3:66, names_to = "Year", values_to = "Value")

#filter by year
gender_data2022 <-
  gender_data3 %>%
  filter(Year=="2022")

gender_data2022 <- gender_data2022[,-3]

gender_data2022wide <-
  gender_data2022 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# now use a little sapply trick to select variables that don't have much missing data - here the proportion is 0.75 (the 0.25 in the function is 1-proportion desired)

gender_data_filtered <- gender_data2022wide[,!sapply(gender_data2022wide, function(x) mean(is.na(x)))>0.25]

# and lastly simplify the dataset by removing some of the topics we won't use

phrases <- c("Worried", "Made", "Received", "Saved", "Used", "Coming", "Borrowed")

gender_data_final <-
  gender_data_filtered %>%
  select(!starts_with(phrases))

# we'll also generate a couple of variables for future use

gender_data_final$female_high_labor <- gender_data_final$`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`>70
gender_data_final$male_high_labor <- gender_data_final$`Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)`>70

attach(gender_data_final)



## ----t-test---------------------------------------------------------------------------------------------------------------

t.test(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`)



## ----t-test mu------------------------------------------------------------------------------------------------------------

t.test(`Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)`, mu=70)



## ----help-----------------------------------------------------------------------------------------------------------------

?t.test



## ----t-test paired--------------------------------------------------------------------------------------------------------

t.test(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`,`Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)`, paired = TRUE, alternative = "two.sided")



##
## import numpy as np
## import pandas as pd
## from scipy import stats
##
## # import from R
## gender_python = r.gender_data_final
##
## # print(gender_python)
##
## labor = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
##
## # Hypothesized population mean
## mu = 70
##
## # Perform one-sample t-test
## # t_stat, p_value = stats.ttest_1samp(labor, mu)
## t_stat, p_value = stats.ttest_1samp(labor, mu)
## print("T statistic:", t_stat)
## print("P-value:", p_value)
##
## # Setting significance level
## alpha = 0.05
##
## # Interpret the results
## if p_value < alpha:
##     print("Reject the null hypothesis; there is a significant difference between the sample mean and the hypothesized population mean.")
## else:
##     print("Fail to reject the null hypothesis; there is no significant difference between the sample mean and the hypothesized population mean.")
##

## ----labor----------------------------------------------------------------------------------------------------------------

table(female_high_labor,male_high_labor)



## ----chisq----------------------------------------------------------------------------------------------------------------

chisq.test(table(female_high_labor,male_high_labor))



## ----normal distribution--------------------------------------------------------------------------------------------------

# the density of a standard normal distribution at the value 2 (2 above mean of zero)

dnorm(2)

# the cumulative percentage of a standard normal distribution below the value 2

pnorm(2)

# mean and standard deviation of the distribution can also be specified
# in this example the cumulative percentage of a normal distribution with mean 100 and s.d. 20, below the value 90

pnorm(90, mean=100, sd=20)

# provides the numeric value of a particular quantile of the distribution (again standard normal in this example)

qnorm(.9)

# a single random draw from the standard normal distribution

rnorm(1)

# five random draws from a normal distribution with mean 100 and s.d. 20

rnorm(5, mean=100, sd=20)

# getting help

?rnorm



## ----correlation incorrect, eval=FALSE------------------------------------------------------------------------------------
##
## cor(`GDP per capita (constant 2010 US$)`,`Fertility rate, total (births per woman)`, na.rm=TRUE)
##


## ----correlation correct--------------------------------------------------------------------------------------------------

cor(`GDP per capita (constant 2010 US$)`,`Fertility rate, total (births per woman)`, use="complete.obs")



## ----cor.test-------------------------------------------------------------------------------------------------------------

cor.test(`GDP per capita (constant 2010 US$)`,`Fertility rate, total (births per woman)`)



## ----linear regression----------------------------------------------------------------------------------------------------

lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`GDP per capita (constant 2010 US$)`)



## ----linear regression with summary---------------------------------------------------------------------------------------

summary(lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`GDP per capita (constant 2010 US$)`))



## ----linear regression additional relationships---------------------------------------------------------------------------

summary(lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`Fertility rate, total (births per woman)`))

summary(lm(`Fertility rate, total (births per woman)`~`GDP per capita (constant 2010 US$)`))



## ----linear regression with no intercept----------------------------------------------------------------------------------

summary(lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`GDP per capita (constant 2010 US$)`-1))



## ----multiple linear regression-------------------------------------------------------------------------------------------

summary(lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`Fertility rate, total (births per woman)`+`GDP per capita (constant 2010 US$)`))



## ----stored regression output---------------------------------------------------------------------------------------------

regoutput<-lm(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`Fertility rate, total (births per woman)`+`GDP per capita (constant 2010 US$)`)
names(regoutput)
regoutput$residuals



## ----stored regression output - quick functions---------------------------------------------------------------------------

# predicted values
predict(regoutput)

# analysis of variance (anova)
anova(regoutput)



## ----tests for normality--------------------------------------------------------------------------------------------------

shapiro.test(rstandard(regoutput))

ks.test(regoutput$residuals, 'pnorm')

ks.test(rstandard(regoutput), 'pnorm', mean=0, sd=1)



## ----diagnostic plots-----------------------------------------------------------------------------------------------------

plot(regoutput, pch=3)



## ----logistic regression--------------------------------------------------------------------------------------------------

logistic_output <- glm(female_high_labor ~ `Fertility rate, total (births per woman)`+`GDP per capita (constant 2010 US$)`, family=binomial)

summary(logistic_output)



##
## import numpy as np
## import pandas as pd
## from scipy import stats
## from sklearn.linear_model import LinearRegression
##
## # import from R
## gender_python = r.gender_data_final
##
## # specify variables
## labor = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## gdp = gender_python.loc[:,"GDP per capita (constant 2010 US$)"]
##
## # this step is important to put the data in Python-friendly form
## labor2 = labor.array.reshape(-1, 1)
## gdp2 = gdp.array.reshape(-1, 1)
## model = LinearRegression().fit(labor2,gdp2)
##
## print(model.intercept_, model.coef_)
## r_sq = model.score(labor2, gdp2)
## print(f"R-squared: {r_sq}")
##

## ----point_estimate-------------------------------------------------------------------------------------------------------

point_estimate <- gender_data_final %>%
  specify(response = `A woman can work in a job deemed dangerous in the same way as a man (1=yes; 0=no)`) %>%
  calculate(stat = "mean")



## ----bootstrap confidence interval----------------------------------------------------------------------------------------

boot_dist_dangerous <- gender_data_final %>%
  specify(response = `A woman can work in a job deemed dangerous in the same way as a man (1=yes; 0=no)`) %>%
  generate(reps = 50000, type = "bootstrap") %>%
  calculate(stat = "mean")



## ----bootstrap replicates-------------------------------------------------------------------------------------------------

boot_dist_dangerous %>%
  visualize()

boot_dist_dangerous %>%
  visualize() +
  shade_p_value(obs_stat = point_estimate, direction = "two-sided")

boot_dist_dangerous %>%
  get_confidence_interval(
    point_estimate = point_estimate,
    level = 0.95,
    type = "se"
  )



## ----labor_diff-----------------------------------------------------------------------------------------------------------

labor_diff <- `Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)` - `Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`



## ----boot_t_test----------------------------------------------------------------------------------------------------------

boot_t_test(labor_diff, R=1000)



## ----boot slope-----------------------------------------------------------------------------------------------------------

var_slope <- gender_data_final |>
  specify(`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`~`Fertility rate, total (births per woman)`) |>
  hypothesize(null = "independence") |>
  generate(reps = 500, type = "permute") |>
  calculate(stat = "slope")

var_slope |>
  # Ungroup the dataset
  ungroup() |>
  # Calculate summary statistics
  summarize(
    # Mean of stat
    mean_stat = mean(stat),
    # Std error of stat
    std_err_stat = sd(stat)
  )



##
## from scipy.stats import bootstrap
## import numpy as np
##
## labor = r.labor_diff
##
## #convert array to sequence
## data = (labor,)
##
## #calculate 95% bootstrapped confidence interval for median
## bootstrap_ci = bootstrap(data, np.mean, confidence_level=0.95,
##                          random_state=1, method='percentile')
##
## #view 95% boostrapped confidence interval
## print(bootstrap_ci.confidence_interval)
##
