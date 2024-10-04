knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/littlePackage")

## 
## install.packages("pak", dependencies=TRUE)
## library(pak)
## pkg_install("devtools")
## pkg_install("roxygen2")
## pkg_install("testthat")
## 
## devtools::session_info()
## 


library(devtools)
library(roxygen2)
library(testthat)



packageVersion("devtools")

devtools::session_info()



create_package("/home/ryan/R/littlePackage")



library(devtools)
library(roxygen2)
library(testthat)



proj_set("/home/ryan/R/littlePackage/")
use_git()



funkyadd <- function(x,y)
  {
  x+y+1
}



randomadd <- function(x,y)
  {
  x+y+round(rnorm(1,0,3),digits=0)
}



funkyadd(6,9)
randomadd(6,9)



use_r("funkyadd")
use_r("randomadd")


## 
## rm(funkyadd)
## rm(randomadd)
## setwd("/home/ryan/R/littlePackage/")
## proj_set("/home/ryan/R/littlePackage/")
## load_all()
## funkyadd(3,5)
## randomadd(3,5)
## 

## 
## check()
## 

## 
## use_mit_license()
## 

## 
## document()
## ?funkyadd
## library(help="littlePackage")
## 

## 
## check()
## install()
## library(littlePackage)
## load_all()
## randomadd(3,6)
## 

## 
## use_testthat()
## use_test("funkyadd")
## test()
## 

## 
## check()
## install()
## 
