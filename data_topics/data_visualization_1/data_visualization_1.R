## ----setup, include=FALSE-----------------------------------------------------

knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/data_topics/data_analysis_2/")



## ----install packages, eval=FALSE---------------------------------------------
# 
# install.packages("pak", dependencies=TRUE)
# library(pak)
# pkg_install("tidyverse")
# pkg_install("reticulate")
# pkg_install("gganimate")
# pkg_install("ggridges")
# pkg_install("ggthemes")
# pkg_install("magick")
# pkg_install("RColorBrewer")
# pkg_install("hexbin")
# pkg_install("ggiraph")
# pkg_install("patchwork")
# pkg_install("sf")
# pkg_install("plotly")
# 
# # less important
# 
# pkg_install("Ecdat")
# pkg_install("remotes")
# remotes::install_github("R-CoderDotCom/ggcats@main")
# 
# devtools::session_info()
# 


## ----library loading----------------------------------------------------------

library(tidyverse)
Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3")
library(reticulate)
library(tidyverse)
library(reticulate)
library(gganimate)
library(ggridges)
library(ggthemes)
library(magick)
library(RColorBrewer)
library(hexbin)
library(ggiraph)
library(patchwork)
library(sf)
library(plotly)

# less important

library(Ecdat)
library(remotes)
library(ggcats)



## ----download and import data-------------------------------------------------

getOption("timeout")
options(timeout=6000)
download.file("https://databank.worldbank.org/data/download/Gender_Stats_CSV.zip", "gender.zip")
unzip("gender.zip")
gender_data <- read_csv("Gender_StatsCSV.csv")



## ----data wrangling, results='hide', echo=TRUE, results='hide', error=FALSE, warning=FALSE, message=FALSE----

# clean the data to remove superfluous columns
names(gender_data)
gender_data <- gender_data[,c(-2,-4)]
names(gender_data)

# clean the data to focus on a recent more complete time period
gender_data2 <-
   gender_data %>%
   pivot_longer(3:68, names_to = "Year", values_to = "Value")

#filter by year
gender_data2024 <-
  gender_data2 %>%
  filter(Year=="2024")

gender_data2024 <- gender_data2024[,-3]

gender_data2024wide <-
  gender_data2024 %>%
  pivot_wider(names_from = "Indicator Name", values_from = "Value")

# now use a little sapply trick to select variables that don't have much missing data - here the proportion is 0.75 (the 0.25 in the function is 1-proportion desired)

gender_data_filtered <- gender_data2024wide[,!sapply(gender_data2024wide, function(x) mean(is.na(x)))>0.25]

# and lastly simplify the dataset by removing some of the topics we won't use

phrases <- c("Worried", "Made", "Received", "Saved", "Used", "Coming", "Borrowed")

gender_data_final <- 
  gender_data_filtered %>%
  select(!starts_with(phrases))

# we'll also generate a couple of variables for future use

gender_data_final$female_high_labor <- gender_data_final$`Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)`>70
gender_data_final$male_high_labor <- gender_data_final$`Labor force participation rate, male (% of male population ages 15-64) (modeled ILO estimate)`>70 

# also for one step with pthon

gender_data_final$female_high_numeric <- as.numeric(gender_data_final$female_high_labor)

# select countries of interest
country_list <- c("China", "Germany", "India", "Japan", "Kazakhstan", "Kyrgyz Republic", "Mongolia", "Russian Federation", "Tajikistan", "Turkmenistan", "United States", "Uzbekistan")

gender_data_selected <-
  gender_data_final %>%
  filter(`Country Name` %in% country_list)

attach(gender_data_final)


## ----missing data, echo=TRUE, results='hide', error=FALSE, warning=FALSE, message=FALSE----

gender_data_final <- gender_data_final |>
  drop_na(`Labor force participation rate for ages 15-24, female (%) (modeled ILO estimate)`) |>
  drop_na(`Labor force participation rate for ages 15-24, male (%) (modeled ILO estimate)`) |>
  drop_na(`GDP per capita (constant 2015 US$)`) |>
  drop_na(`Fertility rate, total (births per woman)`)
  
# and redefine the selected list after these changes
  
  gender_data_selected <-
  gender_data_final %>%
  filter(`Country Name` %in% country_list)

attach(gender_data_final)

# short names

labor_f <- gender_data_final$'Labor force participation rate for ages 15-24, female (%) (modeled ILO estimate)'                                    
labor_m <- gender_data_final$'Labor force participation rate for ages 15-24, male (%) (modeled ILO estimate)'

gdp <- gender_data_final$'GDP per capita (constant 2015 US$)'

fertility <- gender_data_final$'Fertility rate, total (births per woman)'

s_labor_f <- gender_data_selected$'Labor force participation rate for ages 15-24, female (%) (modeled ILO estimate)'                                    
s_labor_m <- gender_data_selected$'Labor force participation rate for ages 15-24, male (%) (modeled ILO estimate)'

s_gdp <- gender_data_selected$'GDP per capita (constant 2015 US$)'

s_fertility <- gender_data_selected$`Fertility rate, total (births per woman)`



## ----base graphics------------------------------------------------------------

plot(gdp~labor_f)

plot(s_gdp~s_labor_f)

plot(gdp~labor_f)
abline(lm(gdp~labor_f), col="red")



## ----first ggplot-------------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_f, y=gdp))



## ----second ggplot------------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_f, y=gdp)) + geom_point()

ggplot(data=gender_data_final, aes(x=labor_f, y=gdp)) + geom_point(aes(color=female_high_labor))



## ----regression---------------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(aes(color=female_high_labor)) + geom_smooth(method="lm")

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(aes(color=female_high_labor)) + geom_abline(intercept = 0, slope = 1)



## ----facet--------------------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(aes(color=female_high_labor)) + facet_wrap(male_high_labor)



## ----fully dressed plot-------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(color="purple3", pch=19) + geom_abline(intercept = 0, slope = 1) + labs(x="male labor participation (percent)", y="female labor participation (percent)", title="Comparing male and female labor participation") 



## 
## import numpy as np
## import pandas as pd
## import matplotlib.pyplot as plt
## import seaborn as sns
## 
## from scipy import stats
## 
## # import from R
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## gdp = gender_python.loc[:,"GDP per capita (constant 2015 US$)"]
## 
## # Initialize layout
## 
## fig, ax = plt.subplots(figsize=(9, 9))
## 
## # Add scatterplot
## 
## ax.scatter(labor, gdp, s=60, alpha=0.7, edgecolors="k")
## 
## # Fit linear regression via least squares with numpy.polyfit
## # It returns an slope (b) and intercept (a)
## # deg=1 means linear fit (i.e. polynomial of degree 1)
## 
## b, a = np.polyfit(labor, gdp, deg=1)
## 
## # Create sequence of 100 numbers from 0 to 100
## 
## xseq = np.linspace(0, 100, num=1000)
## 
## # Plot regression line
## 
## ax.plot(xseq, a + b * xseq, color="k", lw=2.5)
## 
## # show the plot
## 
## plt.show()
## 

## 
## import numpy as np
## import pandas as pd
## import matplotlib.pyplot as plt
## import seaborn as sns
## 
## # import from R
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## gdp = gender_python.loc[:,"GDP per capita (constant 2015 US$)"]
## 
## fig, ax = plt.subplots(figsize=(8, 6))
## sns.regplot(
##     x=labor,
##     y=gdp,
##     line_kws={"color": "red", "linewidth": 1.5},
##     ax=ax
## )
## plt.show()
## 
## fig, ax = plt.subplots(figsize=(8, 6))
## sns.regplot(
##     x=labor,
##     y=gdp,
##     line_kws={
##         "color": "r",
##         "alpha": 0.4
##     },
##     ax=ax
## )
## plt.show()
## 
## fig, ax = plt.subplots(figsize=(8, 6))
## sns.regplot(
##     x=labor,
##     y=gdp,
##     line_kws={
##         "color": "darkred",
##         "alpha": 0.4,
##         "lw": 5,
##         "ls": "--"
##     },
##     ax=ax
## )
## plt.show()
## 

## ----save graph---------------------------------------------------------------

mygraph <- ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(color="purple3", pch=19) + geom_abline(intercept = 0, slope = 1) + labs(x="male labor participation (percent)", y="female labor participation (percent)", title="Comparing male and female labor participation")



## ----export graph-------------------------------------------------------------

# export pdf 

pdf(file="output.pdf")

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(color="purple3", pch=19) + geom_abline(intercept = 0, slope = 1) + labs(x="male labor participation (percent)", y="female labor participation (percent)", title="Comparing male and female labor participation") 

dev.off()

# export jpg

jpeg(file="output.jpg", width = 800, height = 600, quality=100)

mygraph

dev.off()



## ----barchart-----------------------------------------------------------------

ggplot(gender_data_selected, aes(x=`Fertility rate, total (births per woman)`)) + geom_bar(position="stack") 



## ----barchart 2---------------------------------------------------------------

ggplot(gender_data_selected, aes(x=`female_high_labor`)) + geom_bar(position="stack") 



## ----geom_col-----------------------------------------------------------------

ggplot(gender_data_selected, aes(x=`Country Name`, y=s_fertility)) + geom_col(position="dodge")

ggplot(gender_data_selected, aes(x=`Country Name`, y=s_fertility)) + geom_col(position="dodge", fill = s_fertility) 

# tweak it further

ggplot(gender_data_selected, aes(x=`Country Name`, y=s_fertility)) + geom_col(position="dodge", aes(fill=s_fertility)) + labs(x="Country", y="Fertility", title="Fertility rate by Country") + theme(plot.title = element_text(hjust = 0.5)) + scale_fill_gradient(low = "lightgreen", high = "darkgreen") + scale_x_discrete(guide = guide_axis(angle = 45))



## ----theme update-------------------------------------------------------------

theme_update(plot.title = element_text(hjust = 0.5))
ggplot() + ggtitle("Default is now set to centered")



## ----histogram----------------------------------------------------------------

ggplot(gender_data_final, aes(fertility)) + geom_histogram()

ggplot(gender_data_final, aes(fertility)) + geom_histogram(aes(fill = after_stat(count)))



## 
## import matplotlib.pyplot as plt
## 
## # Load the example tips dataset
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor_f = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## female_high_numeric = gender_python.loc[:,"female_high_numeric"]
## 
## # matplotlib version
## 
## fig.clear()
## data = gender_python["Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## plt.hist(data, color='skyblue', edgecolor='black')
## plt.xlabel('percent participation')
## plt.ylabel('Count')
## plt.title('Histogram of female labor participation')
## plt.show()

## 
## import seaborn as sns
## sns.set_theme()
## 
## # Load the example tips dataset
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor_f = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## female_high_numeric = gender_python.loc[:,"female_high_numeric"]
## 
## # seaborn version
## 
## fig, ax = plt.subplots(figsize=(8, 6))
## chart = sns.histplot(data=gender_python, x="Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)")
## chart.set_title('Histogram of female labor participation')
## chart.set_xlabel('percent participation')
## chart.set_ylabel('Count')
## plt.show()
## 

## ----box plot-----------------------------------------------------------------

ggplot(gender_data_final, aes(x=female_high_labor, y=labor_f)) + geom_boxplot()

ggplot(gender_data_final, aes(x=female_high_labor, y=labor_f)) + geom_boxplot() + coord_flip()



## 
## import matplotlib.pyplot as plt
## 
## # Load the example tips dataset
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor_f = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## female_high_numeric = gender_python.loc[:,"female_high_numeric"]
## 
## # matplotlib version
## 
## fig.clear()
## fig, ax = plt.subplots(figsize=(8, 6))
## plt.boxplot(labor_f, patch_artist=True, boxprops=dict(facecolor='skyblue'))
## plt.xlabel('')
## plt.ylabel('percent participation')
## plt.title('box plot of female labor participation')
## plt.show()
## 

## 
## import seaborn as sns
## sns.set_theme()
## 
## # Load the example tips dataset
## 
## gender_python = r.gender_data_final
## 
## # specify variables
## 
## labor_f = gender_python.loc[:,"Labor force participation rate, female (% of female population ages 15-64) (modeled ILO estimate)"]
## female_high_numeric = gender_python.loc[:,"female_high_numeric"]
## 
## # Draw a seaborn boxplot
## 
## fig, ax = plt.subplots(figsize=(8, 6))
## chart = sns.boxplot(x=female_high_numeric, y=labor_f)
## chart.set_title('low (0) and high (1) groups')
## chart.set_xlabel('percent participation')
## chart.set_ylabel('box plot of female labor participation')
## plt.show()
## 

## ----hexbin-------------------------------------------------------------------

ggplot(gender_data_final, aes(x=labor_m, y=labor_f)) + geom_hex() 



## ----ggplot regression--------------------------------------------------------

ggplot(gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point() + geom_smooth(method=lm)

ggplot(gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point() + stat_smooth()



## ----theme tweaks-------------------------------------------------------------

ggplot(gender_data_final, aes(x=fertility, y=gdp)) + facet_grid(.~female_high_labor) + geom_point(fill="purple") + theme(panel.background = element_rect(fill='pink', colour='green'))

ggplot(gender_data_final, aes(x=fertility, y=gdp)) + facet_grid(.~female_high_labor) + geom_point(fill="purple") + theme(panel.background = element_rect(fill='white', colour='black'))

ggplot(gender_data_final, aes(x=fertility, y=gdp)) + facet_grid(.~female_high_labor) + geom_point(aes(color=gdp)) +
scale_colour_distiller(palette = "Dark2", trans = "reverse")

# this option can be used in some contexts
# scale_color_manual(values = c("yellow","orange","pink","red","purple"))



## ----using the power----------------------------------------------------------

mydata <- ggplot(gender_data_final, aes(x=fertility, y=gdp)) + facet_grid(.~female_high_labor) +
scale_colour_distiller(palette = "Dark2", trans = "reverse")

mytheme <- theme(panel.background = element_rect(fill='lightblue', colour='darkgrey')) 

mychart <- geom_point(aes(color=gdp)) 

mydata+mytheme+mychart



## ----Plotly-------------------------------------------------------------------

plotly_plot <- ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_point(color="purple3", pch=19) + geom_abline(intercept = 0, slope = 1) + labs(x="male labor participation (percent)", y="female labor participation (percent)", title="Comparing male and female labor participation") 

ggplotly(plotly_plot)



## ----ggridges-----------------------------------------------------------------

ggplot(gender_data_selected, aes( x = `Fertility rate, total (births per woman)`, y = `female_high_labor`)) + geom_density()

ggplot(gender_data_selected, aes( x = `Fertility rate, total (births per woman)`, y = `female_high_labor`)) + geom_density_ridges()

ggplot(gender_data_selected, aes( x = `Fertility rate, total (births per woman)`, y = `female_high_labor`, fill = stat(x))) +
  geom_density_ridges_gradient() +
  scale_fill_viridis_c(name = "Depth", option = "C") +
  coord_cartesian(clip = "off") + # To avoid cut off
  theme_minimal()



## ----log transform------------------------------------------------------------

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point() + geom_smooth()

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")



## ----color tweaks-------------------------------------------------------------

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point(color="purple") + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point() + geom_smooth(color="purple") + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point(aes(color=female_high_labor)) + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

ggplot(gender_data_final, aes(x=gdp, y=fertility, color=female_high_labor)) + geom_point() + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

ggplot(gender_data_final, aes(x=gdp, y=fertility, color=female_high_labor)) + geom_point(color="purple") + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")



## ----ggthemes-----------------------------------------------------------------

lastplot <- ggplot(gender_data_final, aes(x=gdp, y=fertility)) + geom_point(aes(color=female_high_labor)) + geom_smooth() + scale_y_continuous(trans="log") + scale_x_continuous(trans="log")

lastplot + theme_bw()

lastplot + theme_dark()

lastplot + theme_economist() +  scale_colour_economist()

lastplot + theme_few() + scale_colour_few()

lastplot + theme_fivethirtyeight()

lastplot + theme_solarized_2() + scale_colour_solarized()

lastplot + theme_stata() + scale_colour_stata()

lastplot + theme_tufte()

lastplot + theme_tufte() + scale_color_brewer(palette = "Dark2")

lastplot + theme_wsj()



## ----palettes with RColorBrewer-----------------------------------------------

lastplot + theme_economist() + scale_color_brewer(palette = "Dark2")

lastplot + theme_wsj() + scale_color_brewer(palette = "Set3")



## ----cat plot-----------------------------------------------------------------

ggplot(data=gender_data_final, aes(x=labor_m, y=labor_f)) + geom_cat(cat = "venus", size=2) + geom_abline(intercept = 0, slope = 1) + labs(x="male labor participation (percent)", y="female labor participation (percent)", title="Comparing male and female labor participation") 

# also try "nyancat", "grumpy", "pusheen"



## ----cat plot 2---------------------------------------------------------------

# Create a new column
iris$cat <- factor(iris$Species,
                   labels = c("pusheen", "toast",
                              "venus"))

# Scatter plot by group
ggplot(iris, aes(Petal.Length, Petal.Width)) +
 geom_cat(aes(cat = cat), size = 4)



## ----chloropleth, results='hide', echo=TRUE, results='hide', error=FALSE, warning=FALSE, message=FALSE----

# Read the full world map

world_sf <- read_sf("https://raw.githubusercontent.com/holtzy/R-graph-gallery/master/DATA/world.geojson")
world_sf <- world_sf %>%
  filter(!name %in% c("Antarctica", "Greenland"))

# Join the gender data with the full world map

gender_data_final_geo <- world_sf |>
  left_join(gender_data_final, by = c("name" = "Country Name"))

attach(gender_data_selected)

# Create the first chart (Scatter plot)

p1 <- ggplot(gender_data_selected, aes(s_gdp, s_fertility,
  tooltip = `Country Name`,
  data_id = `Country Name`,
  color = `Country Name`
)) +
  geom_point_interactive(data = filter(gender_data_selected, !is.na(s_gdp)), size = 4) +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )

# Create the second chart (Bar plot)

p2 <- ggplot(gender_data_selected, aes(
  x = reorder(`Country Name`, s_gdp),
  y = s_fertility,
  tooltip = `Country Name`,
  data_id = `Country Name`,
  fill = `Country Name`
)) +
  geom_col_interactive(data = filter(gender_data_selected, !is.na(s_gdp))) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )

# Create the third chart (choropleth)

p3 <- ggplot() +
  geom_sf(data = gender_data_final_geo, fill = "lightgrey", color = "lightgrey") +
  geom_sf_interactive(
    data = filter(gender_data_final_geo, !is.na(geometry)),
    aes(fill = `name`, tooltip = `name`, data_id = `name`)
  ) +
  coord_sf(crs = st_crs(3857)) +
  theme_void() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )

# Combine the plots

combined_plot <- (p1 + p2) / p3 + plot_layout(heights = c(1, 2))

# Create the interactive plot

interactive_plot <- girafe(ggobj = combined_plot)
interactive_plot <- girafe_options(
  interactive_plot,
  opts_hover(css = "fill:red;stroke:black;")
)

# save as an html widget

htmltools::save_html(interactive_plot, "multiple-ggiraph-2.html")



## ----animated cats------------------------------------------------------------

library(Ecdat)
data(incomeInequality)

library(tidyverse)
library(ggcats)
library(gganimate)


 dat <-
   incomeInequality %>%
   select(Year, P99, median) %>%
   rename(income_median = median,
          income_99percent = P99) %>%
   pivot_longer(cols = starts_with("income"),
                names_to = "income",
                names_prefix = "income_")

dat$cat <- rep(NA, 132)

dat$cat[which(dat$income == "median")] <- "nyancat"
dat$cat[which(dat$income == "99percent")] <- rep(c("pop_close", "pop"), 33)

ggplot(dat, aes(x = Year, y = value, group = income, color = income)) +
   geom_line(linewidth = 2) +
   ggtitle("ggcats, a core package of the memeverse") +
   geom_cat(aes(cat = cat), size = 5) +
   xlab("Cats") +
   ylab("Cats") +
   theme(legend.position = "none",
         plot.title = element_text(size = 20),
         axis.text = element_blank(),
         axis.ticks = element_blank()) +
   transition_reveal(Year)


