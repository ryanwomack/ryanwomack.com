## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/littlePackage")


## ----install packages, eval=FALSE---------------------------------------------
## install.packages("pak", dependencies=TRUE)
## library(pak)
## pkg_install("devtools")
## pkg_install("roxygen2")
## pkg_install("testthat")
## 
## devtools::session_info()


## ----libraries----------------------------------------------------------------
library(devtools)
library(roxygen2)
library(testthat)


## ----versions-----------------------------------------------------------------
packageVersion("devtools")

devtools::session_info()


## ----create package-----------------------------------------------------------
create_package("/home/ryan/R/littlePackage")


## ----reload packages----------------------------------------------------------
library(devtools)
library(roxygen2)
library(testthat)


## ----use git------------------------------------------------------------------
proj_set("/home/ryan/R/littlePackage/")
use_git()


## ----funkyadd-----------------------------------------------------------------
funkyadd <- function(x,y)
  {
  x+y+1
}


## ----randomadd----------------------------------------------------------------
randomadd <- function(x,y)
  {
  x+y+round(rnorm(1,0,3),digits=0)
}


## ----examples-----------------------------------------------------------------
funkyadd(6,9)
randomadd(6,9)


## ----use_r--------------------------------------------------------------------
use_r("funkyadd")
use_r("randomadd")


## ----load_all, eval=FALSE-----------------------------------------------------
## rm(funkyadd)
## rm(randomadd)
## setwd("/home/ryan/R/littlePackage/")
## proj_set("/home/ryan/R/littlePackage/")
## load_all()
## funkyadd(3,5)
## randomadd(3,5)


## ----check, eval=FALSE--------------------------------------------------------
## check()


## ----license, eval=FALSE------------------------------------------------------
## use_mit_license()


## ----document, eval=FALSE-----------------------------------------------------
## document()
## ?funkyadd
## library(help="littlePackage")


## ----check and install, eval=FALSE--------------------------------------------
## check()
## install()
## library(littlePackage)
## load_all()
## randomadd(3,6)


## ----testthat, eval=FALSE-----------------------------------------------------
## use_testthat()
## use_test("funkyadd")
## test()


## ----check and install again, eval=FALSE--------------------------------------
## check()
## install()

