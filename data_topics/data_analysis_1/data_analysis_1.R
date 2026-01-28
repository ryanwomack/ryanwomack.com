## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/data_topics/data_analysis_1/")


## ----install packages, eval=FALSE---------------------------------------------
# 
# install.packages("pak", dependencies=TRUE)
# library(pak)
# pkg_install("tidyverse")
# pkg_install("reticulate")
# devtools::session_info()
# 


## ----tidyverse----------------------------------------------------------------

library(tidyverse)
# Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3")
library(reticulate)
use_python("/usr/bin/python3")



## ----statistics---------------------------------------------------------------

# draw ten numbers at random from the range 1 to 100

sample(1:100,10)

# draw ten numbers from the standard normal distribution

rnorm(10)

# draw ten numbers from a normal distribution with mean 100 and standard deviation 20

rnorm(10, mean=100, sd=20)



## ----functions----------------------------------------------------------------

# define the function

funkyadd<-function(x,y)
{
  x+y+1
}

# run the function with arguments

funkyadd(2,2)



## ----readr--------------------------------------------------------------------

# start with a tab-separated file

download.file("https://ryanwomack.com/data/myfile.txt", "myfile.txt")
mydata <- read_tsv("myfile.txt")
mydata



## ----readxl-------------------------------------------------------------------

# install.packages("readxl")
library(readxl)

download.file("https://ryanwomack.com/data/mydata.xlsx", "mydata.xlsx")
mydata<-read_excel("mydata.xlsx", 1)
mydata



## ----tibble-------------------------------------------------------------------

library(tibble)

# "as" functions in R convert back and forth between formats

# "." notation in base R, "_" notation in tidyverse

as.data.frame(mydata)
as_tibble(iris)



## ----gender data--------------------------------------------------------------

# note the timeout options below may be useful if you're on a slow connection or the World Bank site is slow to respond.

getOption("timeout")
options(timeout=6000)

download.file("https://databank.worldbank.org/data/download/Gender_Stats_CSV.zip", "gender.zip")

unzip("gender.zip")

# we read in the data with read_csv and examine it, then remove two unneeded columns with codes, using basic matrix notation

gender_data <- read_csv("Gender_StatsCSV.csv")
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)



## ----pivot--------------------------------------------------------------------

# pivot_longer

gender_data2 <-
   gender_data |>
   pivot_longer(3:67, names_to = "Year", values_to = "Value")

# filter

gender_data2023 <-
  gender_data2 |>
  filter(Year=="2023")

# we no longer need the Year variable, since all are 2023 

gender_data2023 <- gender_data2023[,-3]

# pivot_wider

gender_data2023wide <-
  gender_data2023 |>
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# write this version of the data to a file

write_csv(gender_data2023wide, "widedata.csv")



## ----summary, echo=TRUE, results=FALSE----------------------------------------

ls()
summary(gender_data)
summary(gender_data2023)
summary(gender_data2023wide)

# summarise is the tidyverse way, from dplyr

gender_data2023wide |>
  summarise_if(is.numeric, mean, na.rm=TRUE)



## ----mutate-------------------------------------------------------------------

gender_data2023wide <-
  gender_data2023wide |>
  mutate(gdp_ratio = (`GDP per capita (Current US$)`/10000)/`Fertility rate, total (births per woman)`)

# we can use a function like drop_na to eliminate missing data from a variable

gender_data2023wide <-
  drop_na(gender_data2023wide, gdp_ratio)

plot(gender_data2023wide$gdp_ratio)

gender_data2023wide <-
  gender_data2023wide |>
  mutate(hi_ratio = gdp_ratio>0.78)

attach(gender_data2023wide)



## ----select-------------------------------------------------------------------

gender_gdp <-
  select(gender_data2023wide, c(`Country Name`,starts_with("GDP")))

gender_gdp
write_csv(gender_gdp, "gender_gdp.csv")



## ----filter-------------------------------------------------------------------

# select countries of interest

country_list <- c("Armenia", "Azerbaijan", "Canada", "China", "France", "Georgia", "Germany", "India", "Italy", "Japan", "Kazakhstan", "Korea, Rep.", "Kyrgyz Republic", "Mexico", "Mongolia", "Russian Federation", "Saudi Arabia", "Tajikistan", "Turkiye", "Turkmenistan", "United Arab Emirates", "United Kingdom", "United States", "Uzbekistan")

gender_data2023selected <-
  gender_gdp |>
  filter(`Country Name` %in% country_list)

write_csv(gender_data2023selected, "gender_selected.csv")

# filter by criteria

gender_data2023filtered <-
  gender_data2023selected |>
  filter(gdp_ratio>2)

gender_data2023filtered



## ----summarise----------------------------------------------------------------

gender_data2023wide |>
  summarise(mean = mean(gdp_ratio), n = n(), median = median(gdp_ratio))

# Usually, you'll want to group first

gender_data2023wide |>
  group_by(hi_ratio) |>
  summarise(mean = mean(gdp_ratio, na.rm=TRUE), n = n())



## ----arrange------------------------------------------------------------------

gender_gdp <-
  gender_gdp |>
  arrange(desc(gdp_ratio))

gender_gdp$gdp_ratio
write_csv(gender_gdp, "gender_gdp.csv")



## ----purr---------------------------------------------------------------------

# an example of map in action

mtcars |>
  split(mtcars$cyl) |> 
  map(\(df) lm(mpg ~ wt, data = df)) |>
  map(summary) |>
  map_dbl("r.squared")



## ----broom--------------------------------------------------------------------

library(broom)

regoutput<-lm(`GDP per capita (constant 2015 US$)`~`Fertility rate, total (births per woman)`, gender_data2023wide)

# base R regression summary
summary(regoutput)

# broom variants
tidy(regoutput)
glance(regoutput)
augment(regoutput)

# a grouped example

regressions <- gender_data2023wide |>
  group_by(hi_ratio) |>
  nest() |>
  mutate(
    fit = map(data, ~ lm(`GDP per capita (constant 2015 US$)`~`Fertility rate, total (births per woman)`, data=.x,)),
    tidied = map(fit, tidy),
    glanced = map(fit, glance),
    augmented = map(fit, augment)
  )

regressions |>
  unnest(tidied)

regressions |>
  unnest(glanced)

regressions |>
  unnest(augmented)


