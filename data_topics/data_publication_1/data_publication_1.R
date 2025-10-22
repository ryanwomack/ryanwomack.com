## note the code for this session is not really complete, in a form to be executed by itself
## provided just for reference purposes

## ----initiate, include=FALSE--------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----setup--------------------------------------------------------------------
#| eval: false
#| echo: true
# library(pak)
# pkg_install("blogdown")
# pkg_install("bookdown")

## blogdown

library(blogdown)
dir.create("/home/ryan/R/blogdownsite")
setwd("/home/ryan/R/blogdownsite")
new_site()
serve_site()
build_site()

## blogdown options
 
hugo -d ./public
 
options(blogdown.method = 'html')

## bookdown

setwd("/home/ryan/R/bookdemo")
library(bookdown)
library(rmarkdown)
render_site()
render_site(output_format = 'bookdown::pdf_book', encoding = 'UTF-8')

