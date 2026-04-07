#' ---
#' title: Central Asia Barometer Data Analysis, continued
#' author: Ryan Womack
#' date: '2026-04-07'
#' toc:toc: true true
#' number-sections: true
#' highlight-style: pygments
#' output: html_document
#' format:
#'   html:
#'     toc: true
#'     code-fold: true
#'     html-math-method: katex
#'   pdf:
#'     geometry:
#'     - top=30mm
#'     - left=30mm
#'     fontfamily: libertinus
#'     colorlinks: true
#'     papersize: A4
#'   docx: default
#' theme: litera
#' include-in-header:
#'   text: ''
#' ---
#' 


knitr::opts_chunk$set(echo = TRUE, eval = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/womack/documents/ryan/Central_Asia/Central_Asia_Barometer/")



install.packages("pak", dependencies=TRUE)
library(pak)
pkg_install("tidyverse")
pkg_install("readxl")
pkg_install("reticulate")
pkg_install("ggplot2") # including in tidyverse, but just making this explicit
pkg_install("lattice")

# helper packages

pkg_install("ggthemes")
pkg_install("cowplot")
pkg_install("gridExtra")
pkg_install("RColorBrewer")
pkg_install("png")
pkg_install("paletteer")
pkg_install("ggiraph")

# pkg_install("ggridges")
# pkg_install("ggvis")
# pkg_install("gganimate")
# pkg_install("gapminder")
# pkg_install("hexbin")
# pkg_install("gifski")

devtools::session_info()




library(readxl)
library(tidyverse)
library(lattice)
library(ggthemes)
library(cowplot)
library(gridExtra)
library(RColorBrewer)
library(png)
library(paletteer)
library(ggiraph)




# Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3")
library(reticulate)
use_python("/usr/bin/python3")




download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx", "CAB_2022_KG.csv")
data_22_KG <- read_excel("CAB_2022_KG.csv")

download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kazakhstan-kazakhstan-2022-autumn.xlsx", "CAB_2022_KZ.csv")
data_22_KZ <- read_excel("CAB_2022_KZ.csv")

download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-uzbekistan-uzbekistan-2022-autumn.xlsx", "CAB_2022_UZ.csv")
data_22_UZ <- read_excel("CAB_2022_UZ.csv")

download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-turkmenistan-turkmenistan-2022-autumn.xlsx", "CAB_2022_TM.csv")
data_22_TM <- read_excel("CAB_2022_TM.csv")

download.file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-tajikistan-tajikistan-2022-autumn.xlsx", "CAB_2022_TJ.csv")
data_22_TJ <- read_excel("CAB_2022_TJ.csv")

# download 2020 data

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-kyrgyzstan-2020-autumn.xlsx", "CAB_2020_KG.csv")
data_20_KG <- read_excel("CAB_2020_KG.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-kazakhstan-2020-autumn.xlsx", "CAB_2020_KZ.csv")
data_20_KZ <- read_excel("CAB_2020_KZ.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-uzbekistan-2020-autumn.xlsx", "CAB_2020_UZ.csv")
data_20_UZ <- read_excel("CAB_2020_UZ.csv")

# no 2020 Turkmenistan data
# download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-turkmenistan-2020-autumn.xlsx", "CAB_2020_TM.csv")
# data_20_TM <- read_excel("CAB_2020_TM.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-tajikistan-2020-autumn.xlsx", "CAB_2020_TJ.csv")
data_20_TJ <- read_excel("CAB_2020_TJ.csv")

# download 2018 data

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-kyrgyzstan-2018-autumn.xlsx", "CAB_2018_KG.csv")
data_18_KG <- read_excel("CAB_2018_KG.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-kazakhstan-2018-autumn.xlsx", "CAB_2018_KZ.csv")
data_18_KZ <- read_excel("CAB_2018_KZ.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-uzbekistan-2018-autumn.xlsx", "CAB_2018_UZ.csv")
data_18_UZ <- read_excel("CAB_2018_UZ.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-turkmenistan-2018-autumn.xlsx", "CAB_2018_TM.csv")
data_18_TM <- read_excel("CAB_2018_TM.csv")

download.file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-tajikistan-2018-autumn.xlsx", "CAB_2018_TJ.csv")
data_18_TJ <- read_excel("CAB_2018_TJ.csv")




data_22_KG <- mutate(data_22_KG, Country = 'Kyrgyzstan')
data_20_KG <- mutate(data_20_KG, Country = 'Kyrgyzstan')

# data_18_KG <- mutate(data_18_KG, Country = 'KG')

data_22_KZ <- mutate(data_22_KZ, Country = 'Kazakhstan')
data_20_KZ <- mutate(data_20_KZ, Country = 'Kazakhstan')

# data_18_KZ <- mutate(data_18_KZ, Country = 'KZ')

data_22_UZ <- mutate(data_22_UZ, Country = 'Uzbekistan')
data_20_UZ <- mutate(data_20_UZ, Country = 'Uzbekistan')

# data_18_UZ <- mutate(data_18_UZ, Country = 'UZ')

data_22_TM <- mutate(data_22_TM, Country = 'Turkmenistan')

# data_20_TM <- mutate(data_20_TM, Country = 'TM')
# data_18_TM <- mutate(data_18_TM, Country = 'TM')

data_22_TJ <- mutate(data_22_TJ, Country = 'Tajikistan')
data_20_TJ <- mutate(data_20_TJ, Country = 'Tajikistan')

# data_18_TJ <- mutate(data_18_TJ, Country = 'TJ')



data_2022 <- rbind(data_22_KZ, data_22_KG, data_22_UZ)




setdiff(names(data_22_KG),names(data_22_KZ))
setdiff(names(data_22_KG),names(data_22_UZ))
setdiff(names(data_22_KZ),names(data_22_UZ))

my_test_join <- full_join(data_22_KG, data_22_KZ)




# data_22_KG$MM8
# data_22_KZ$MM8
# data_20_KG$MM8
# data_20_KZ$MM8
# data_18_KG$MM6
# data_18_KZ$MM6

data_22_KG$MM8 <- 2022
data_22_KZ$MM8 <- 2022
data_22_UZ$MM8 <- 2022

data_20_KG$MM8 <- 2020
data_20_KZ$MM8 <- 2020
data_20_UZ$MM8 <- 2020

class(data_22_KG$MM8)
mode(data_22_KG$MM8)

class(data_22_KZ$MM8)
mode(data_22_KZ$MM8)

# data_18_KG$Year
# data_18_KZ$Year

class(data_18_KG$Year)
mode(data_18_KG$Year)

# try again

my_test_join <- full_join(data_22_KG, data_22_KZ)

# works now

data_22_KG <- data_22_KG |> rename('Year'='MM8')
data_22_KZ <- data_22_KZ |> rename('Year'='MM8')
data_22_UZ <- data_22_UZ |> rename('Year'='MM8')




mydata2022 <- full_join(data_22_KG, data_22_KZ)
mydata2022 <- full_join(mydata2022, data_22_UZ)
mydata2020 <- full_join(data_20_KG, data_20_KZ)
mydata2020 <- full_join(mydata2020, data_20_UZ)
mydata2018 <- full_join(data_18_KG, data_18_KZ)
# mydata2018 <- full_join(mydata2018, data_18_UZ)

# a problem with $$HHLandlines in last line
data_18_UZ$HHLandlines <- as.character(data_18_UZ$HHLandlines)
mydata2018 <- full_join(mydata2018, data_18_UZ)




names(mydata2018)
names(mydata2020)
names(mydata2022)

mydata2022 <- mydata2022 |> rename('Sex'='DD1', 'Age'='DD2', 'Marital'='DD3',
                                   'Education'='DD4', 'Employment'='DD6a', 
                                   'Direction'='D1', 'China_Favor'='E1a',
                                   'Russia_Favor'='E1b','USA_Favor'='E1c',
                                   'Main_News'='A1a', 'Remit'='DD9a',
                                   'Language'='DD11','Country_Fin_Sit'='B4a',
                                   'Family_Fin_Sit'='B4b')

mydata2022_select <- mydata2022 |> select('Sex', 'Age', 'Marital', 'Education', 
                                          'Employment', 'Direction', 'China_Favor',
                                          'Russia_Favor','USA_Favor', 'Main_News', 
                                          'Remit', 'Language','Country_Fin_Sit',
                                          'Family_Fin_Sit', 'Country', 'Year')

# note we rename Year here from MM8

mydata2020 <- mydata2020 |> rename('Sex'='DD1', 'Age'='DD2', 'Marital'='DD3',
                                   'Education'='DD4', 'Employment'='DD6a', 
                                   'Direction'='D1', 'China_Favor'='E1a',
                                   'Russia_Favor'='E1b','USA_Favor'='E1c',
                                   'Main_News'='A1a', 'Language'='DD9',
                                   'Country_Fin_Sit'='B4a', 'Family_Fin_Sit'='B4b',
                                   'Year'='MM8')

mydata2020_select <- mydata2020 |> select('Sex', 'Age', 'Marital', 'Education', 
                                          'Employment', 'Direction', 'China_Favor',
                                          'Russia_Favor','USA_Favor', 'Main_News', 
                                          'Language','Country_Fin_Sit',
                                          'Family_Fin_Sit', 'Country', 'Year')

# need to add a blank 'Remit' variable here

mydata2020_select <- mydata2020_select |> mutate(Remit=NA)

# and 2018 data already uses the names, but formatted differently
# codebook is not satisfactory, does not describe these labels, have to judge by answers in some cases
# note the 'LangExtra' to avoid repeating a name

mydata2018 <- mydata2018 |> rename('Sex'='Gender', 'Marital'='MarriageStat2',
                                   'Education'='EducLevel_M', 'Employment'='Work', 
                                   'Direction'='RiteRong_M', 'China_Favor'='OpinionChina',
                                   'Russia_Favor'='OpinionRussia','USA_Favor'='OpinionUSA',
                                   'Main_News'='MainNews_M', 'Language'='Homelang','LangExtra'='Language',
                                   'Country_Fin_Sit'='TodayEcSit_M', 'Family_Fin_Sit'='Lastyear_M',
                                   'Remit'='IncomeOut')

mydata2018_select <- mydata2018 |> select('Sex', 'Age', 'Marital', 'Education', 
                                          'Employment', 'Direction', 'China_Favor',
                                          'Russia_Favor','USA_Favor', 'Main_News', 
                                          'Language','Country_Fin_Sit', 'Remit',
                                          'Family_Fin_Sit', 'Country', 'Year')




my_final_data <- rbind(mydata2018_select, mydata2020_select, mydata2022_select)
str(my_final_data)
summary(my_final_data)

attach(my_final_data)




table(Sex)
table(Age)
table(Marital)
table(Education)
table(Employment)
table(Direction)
table(China_Favor)
table(Sex)
table(Russia_Favor)
table(USA_Favor)
table(Main_News)
table(Country_Fin_Sit)
table(Remit)

# fix the problem with Remit

my_final_data$Remit<-as.numeric(Remit)
attach(my_final_data)

table(Remit)

table(Family_Fin_Sit)
table(Country)
table(Year)

table(Direction, Sex)

table(Marital, Employment)

table(Marital, Education)

table(Education, Employment)




my_final_data$Marital_recode <- replace_values(
  Marital,
  c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

my_final_data$Employment_recode <- replace_values(
  Employment,
  c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

my_final_data$Employment_recode2 <- replace_values(
  Employment,
  c("Working part-time", "Working full-time") ~ "Working",
  c("Unemployed and not actively seeking employment", "Unemployed and actively seeking employment") ~ "Unemployed",
  c("A housewife / househusband","A housewife") ~ "Housewife",
  c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

my_final_data$Direction_recode <- replace_values(
  Direction,
  c("Don't Know (vol.)", "Refused (vol.)", "Not asked") ~ NA
)

my_final_data$Family_Fin_Sit_recode <- replace_values(
  Family_Fin_Sit,
  c("Much better", "Much Better", "Become Better", "Somewhat better", "Somewhat Better") ~ "Better",
  c("About the same", "Stayed the Same") ~ "Same",
  c("Become Worse","Much Worse", "Much worse", "Somewhat Worse", "Somewhat worse") ~ "Worse",
  c("Don't Know (vol.)", "Refused (vol.)") ~ NA
)

attach(my_final_data)

table(Marital_recode,Employment_recode)




chisq.test(table(Direction,Sex))




plot(Remit~Year)




plot(Remit~Year)
abline(lm(Remit~Year), col="red")




plot(Remit~Age)




xyplot(Remit~Age, groups=Country, auto.key=list(space="right"))

xyplot(Remit~Age | Country, groups=Language, auto.key=list(space="right"))

xyplot(Remit~Age | Country, groups=Marital, pch=10, auto.key=list(space="right"))




ggplot(my_final_data, aes(y=Remit, x=Age))  + facet_grid(.~Country) + geom_point(aes(color=Sex))

ggplot(my_final_data, aes(y=Remit, x=Age))  + facet_grid(Country~.) + geom_point(aes(color=Marital))

ggplot(my_final_data, aes(y=Remit, x=Age))  + facet_grid(Country~.) + geom_point(aes(color=Marital))+
labs(x="age", y="% remittances", title="Remittance as percentage of income")

ggplot(my_final_data, aes(x=Remit, y=Age))  + facet_grid(.~Country) + geom_point(aes(color=Marital))+
  labs(x="age", y="% remittances", title="Remittance as percentage of income")

# point size

ggplot(my_final_data, aes(x=Remit, y=Age))  + facet_grid(.~Country) + geom_point(aes(color=Marital), size=3)+
  labs(x="age", y="% remittances", title="Remittance as percentage of income")




ggplot(my_final_data, aes(x=Sex)) + geom_bar(position="stack") 

ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") 

country_colors <- c("turquoise1","firebrick1","seagreen3")

ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") + scale_fill_manual(values = country_colors)

ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") + scale_fill_brewer(palette = "Accent")




ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") +scale_fill_paletteer_d("nationalparkcolors::Hawaii")

ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") +scale_fill_paletteer_d("IslamicArt::samarqand2")

# try also 
# IslamicArt::samarqand
# nbapalettes::lakers
# MoMAColors::OKeeffe




ggplot(my_final_data, aes(China_Favor, fill=Country))+ geom_bar(position="stack") + scale_fill_manual(values = country_colors)

ggplot(my_final_data, aes(China_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors)

ggplot(my_final_data, aes(Russia_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors)

ggplot(my_final_data, aes(USA_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors)




China <- ggplot(my_final_data, aes(China_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors) + coord_flip()

Russia <- ggplot(my_final_data, aes(Russia_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors) + coord_flip()

USA <- ggplot(my_final_data, aes(USA_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors) + coord_flip()




grid.arrange(China,Russia,USA, ncol=1, nrow=3)




pdf(file="output.pdf")
ggplot(my_final_data, aes(USA_Favor, fill=Country))+ geom_bar(position="dodge") + scale_fill_manual(values = country_colors) + coord_flip()
dev.off()

jpeg(file="output.jpg", width = 800, height = 600, quality=100)
ggplot(my_final_data, aes(x=Sex, fill=Country)) + geom_bar(position="stack") +scale_fill_paletteer_d("IslamicArt::samarqand2")
dev.off()




ggplot(my_final_data, aes(Age))+geom_histogram(aes(fill = after_stat(count)))+facet_grid(Country~.)

ggplot(my_final_data, aes(Age)) + facet_grid(Country~.) + geom_bar(position="dodge", fill="olivedrab")+theme(panel.background = element_rect(fill='lightsteelblue1', colour='darkblue'))

ggplot(my_final_data, aes(Age)) + facet_grid(Country~.) + geom_bar(position="dodge")+theme(panel.background = element_rect(fill='white', colour='black'))

ggplot(my_final_data, aes(Age)) + facet_grid(Country~.) + geom_bar(position="dodge")+ scale_fill_brewer(palette="Reds")


ggplot(my_final_data, aes(Employment_recode, fill=as.factor(Marital_recode))) +facet_grid(Country~.) + geom_bar(position="dodge") + theme(panel.background = element_rect(fill='beige', colour='darkblue'))

ggplot(my_final_data, aes(Employment_recode, fill=as.factor(Marital_recode))) +facet_grid(Country~.) + geom_bar(position="dodge") + theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Work status", y="Count", title="Employment by Marital Status") + coord_flip()

ggplot(my_final_data, aes(Employment_recode2, fill=as.factor(Marital_recode))) +facet_grid(Country~.) + geom_bar(position="dodge") + theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Work status", y="Count", title="Employment by Marital Status") + coord_flip()

ggplot(my_final_data, aes(Employment_recode2, fill=Country)) +facet_grid(Marital_recode~.) + geom_bar(position="dodge") + scale_fill_manual(values=country_colors)+theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Work status", y="Count", title="Employment by Marital Status")




# Direction by factors

ggplot(my_final_data, aes(Direction, fill=Country)) + geom_bar(position="dodge") + scale_fill_manual(values=country_colors)+theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Response", y="Count", title="Going in Right or Wrong Direction?") 

ggplot(my_final_data, aes(Direction, fill=Country)) + facet_grid(Year~.) + geom_bar(position="dodge") + scale_fill_manual(values=country_colors)+theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Response", y="Count", title="Going in Right or Wrong Direction?") 

ggplot(my_final_data, aes(Direction_recode, fill=Country)) + facet_grid(Family_Fin_Sit_recode~.) + geom_bar(position="dodge") + scale_fill_manual(values=country_colors) + theme(panel.background = element_rect(fill='beige', colour='darkblue')) + 
  labs(x="Response", y="Count", title="Going in Right or Wrong Direction vs. Family situation?")




mydata <- ggplot(my_final_data, aes(Direction_recode, fill=Country)) + facet_grid(Family_Fin_Sit_recode~.) + 
  labs(x="Response", y="Count", title="Going in Right or Wrong Direction vs. Family situation?") + scale_fill_manual(values=country_colors)

mytheme <- theme(panel.background = element_rect(fill='beige', colour='darkblue'))
  
mychart <- geom_bar(position="dodge")

mydata + mytheme + mychart




ggplot(my_final_data, aes(x=Remit, y=Country)) + geom_boxplot()

ggplot(my_final_data, aes(x=Remit, y=Country)) + geom_boxplot() + coord_flip()

ggplot(my_final_data, aes(x=Remit, y=Country, fill=Country)) + geom_boxplot() + coord_flip() +
  theme_minimal_grid() + scale_fill_manual(values=country_colors)




lastplot <- ggplot(my_final_data, aes(x=Remit,y=Age))  + geom_point(aes(color=Country)) + stat_smooth() + 
  labs(x="Remittance %", y="Age", title="Age vs Remittance") 

lastplot + theme_bw()
lastplot + theme_cowplot()
lastplot + theme_dark()
lastplot + theme_economist()
lastplot + theme_fivethirtyeight()
lastplot + theme_tufte()
lastplot + theme_wsj()

# then with Rcolorbrewer

lastplot + theme_economist() + scale_color_brewer(palette = "Set3")
lastplot + theme_tufte() + scale_color_brewer(palette = "Dark2")




myplot <- ggplot(
  data = my_final_data,
  mapping = aes(
    x = Remit, y = Age,
    # here we add interactive aesthetics
    tooltip = paste(Country,Marital)
  )
) +
  geom_point_interactive(
    size = 1, hover_nearest = TRUE
  )

interactive_plot <- girafe(ggobj = myplot)
htmltools::save_html(interactive_plot, "/home/ryan/R/ggiraph-2.html")




# compute percentages

my_final_data$Direction_recode <- as.factor(Direction_recode)

attach(my_final_data)

mean(as.numeric(Direction_recode), na.rm=TRUE)

levels(my_final_data$Direction_recode)

# forcats

fct_count(Direction_recode, sort = FALSE, prop = TRUE)

mytable <- fct_count(Direction_recode, sort = FALSE, prop = FALSE)

Direction_percent <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

# fct_match(Direction_recode, "Right direction")

# Now do a matrix of these 

Uz18<- my_final_data |> filter(Country=="Uzbekistan" & Year==2018)
Uz20<- my_final_data |> filter(Country=="Uzbekistan" & Year==2020)
Uz22<- my_final_data |> filter(Country=="Uzbekistan" & Year==2022)

Kz18<- my_final_data |> filter(Country=="Kazakhstan" & Year==2018)
Kz20<- my_final_data |> filter(Country=="Kazakhstan" & Year==2020)
Kz22<- my_final_data |> filter(Country=="Kazakhstan" & Year==2022)

Kg18<- my_final_data |> filter(Country=="Kyrgyzstan" & Year==2018)
Kg20<- my_final_data |> filter(Country=="Kyrgyzstan" & Year==2020)
Kg22<- my_final_data |> filter(Country=="Kyrgyzstan" & Year==2022)

# setup our matrix

Direction_pct_matrix <- data.frame(matrix(0,3,3))
rownames(Direction_pct_matrix) = c("Kazakhstan", "Kyrgyzstan", "Uzbekistan")
colnames(Direction_pct_matrix) = c("2018", "2020", "2022")

mytable <- fct_count(Kz18$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[1,1] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Kz20$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[1,2] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Kz22$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[1,3] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Kg18$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[2,1] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Kg20$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[2,2] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Kg22$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[2,3] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Uz18$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[3,1] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

mytable <- fct_count(Uz20$Direction_recode, sort = FALSE, prop = FALSE)
Direction_pct_matrix[3,2] <- mytable[1,2]/(mytable[1,2]+mytable[2,2])

# this was the not asked question in Uzbekistan in 2022, so leave it alone, code as NA

mytable <- fct_count(Uz22$Direction_recode, sort = FALSE, prop = FALSE)

Direction_pct_matrix[3,3] <- NA

Direction_pct_matrix <- cbind(Direction_pct_matrix, Country=c("Kazakhstan", "Kyrgyzstan", "Uzbekistan"))

Direction_long <- pivot_longer(Direction_pct_matrix, !Country, names_to="Year", values_to = "Value")

Direction_long$Year <- as.numeric(Direction_long$Year)

ggplot(Direction_long, aes(x=Year, y=Value, color=Country)) +
  geom_line() 

ggplot(Direction_long, aes(x=Year, y=Value, color=Country)) +
  geom_line() + theme_tufte() + scale_color_brewer(palette = "Dark2") +
  labs(title="Right Direction over time", y="Percentage")
  



lm(data=my_final_data, Remit ~ .)

lm(data=my_final_data, Remit ~ Year)

regression_output <- lm(Remit ~ Sex + Language, data=my_final_data)
summary(regression_output)

regression_output_all_demographic <- lm(Remit ~ Sex + Age + Language + Employment + Education + Country + Year, data=my_final_data)
summary(regression_output_all_demographic)

backward_model <- step(regression_output_all_demographic, direction = "backward")

# Print the summary of the selected model

summary(backward_model)


