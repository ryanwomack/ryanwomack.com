import pandas as pd
import numpy as np
import requests
import os
import matplotlib.pyplot as plt
import seaborn as sns
from plotnine import *
from scipy.stats import chi2_contingency
import statsmodels.api as sm
import statsmodels.formula.api as smf
import plotly.express as px
import plotly.io as pio
from typing import List, Union

# ---
# title: Central Asia Barometer Data Analysis, continued
# author: Ryan Womack
# date: '2026-04-07'
# toc:toc: true true
# number-sections: true
# highlight-style: pygments
# output: html_document
# format:
#   html:
#     toc: true
#     code-fold: true
#     html-math-method: katex
#   pdf:
#     geometry:
#     - top=30mm
#     - left=30mm
#     fontfamily: libertinus
#     colorlinks: true
#     papersize: A4
#   docx: default
# theme: litera
# include-in-header:
#   text: ''
# ---

# knitr::opts_chunk$set(echo = TRUE, eval = TRUE)
# knitr::opts_chunk$set(root.dir = "/home/ryan/womack/documents/ryan/Central_Asia/Central_Asia_Barometer/")

# In Python, we use subprocess or pip directly for installations.
# The following simulates the 'pak' and 'pkg_install' logic.
import subprocess
import sys

def install_package(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Equivalent of pkg_install calls
# install_package("pandas")
# install_package("openpyxl")
# install_package("plotnine")
# install_package("scipy")
# install_package("statsmodels")
# install_package("requests")
# install_package("plotly")

# devtools::session_info()
# In Python, we might print versions
print(f"Pandas version: {pd.__version__}")

# library(readxl)
# library(tidyverse)
# library(lattice)
# library(ggthemes)
# library(cowplot)
# library(gridExtra)
# library(RColorBrewer)
# library(png)
# library(paletteer)
# library(ggiraph)

# library(reticulate)
# use_python("/usr/bin/python3")
# (Not needed in native Python environment)

def download_file(url, filename):
    response = requests.get(url)
    with open(filename, 'wb') as f:
        f.write(response.content)

# Download 2022 data
download_file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx", "CAB_2022_KG.xlsx")
data_22_KG = pd.read_excel("CAB_2022_KG.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kazakhstan-kazakhstan-2022-autumn.xlsx", "CAB_2022_KZ.xlsx")
data_22_KZ = pd.read_excel("CAB_2022_KZ.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-uzbekistan-uzbekistan-2022-autumn.xlsx", "CAB_2022_UZ.xlsx")
data_22_UZ = pd.read_excel("CAB_2022_UZ.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-turkmenistan-turkmenistan-2022-autumn.xlsx", "CAB_2022_TM.xlsx")
data_22_TM = pd.read_excel("CAB_2022_TM.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-tajikistan-tajikistan-2022-autumn.xlsx", "CAB_2022_TJ.xlsx")
data_22_TJ = pd.read_excel("CAB_2022_TJ.xlsx")

# download 2020 data
download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-kyrgyzstan-2020-autumn.xlsx", "CAB_2020_KG.xlsx")
data_20_KG = pd.read_excel("CAB_2020_KG.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-kazakhstan-2020-autumn.xlsx", "CAB_2020_KZ.xlsx")
data_20_KZ = pd.read_excel("CAB_2020_KZ.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-uzbekistan-2020-autumn.xlsx", "CAB_2020_UZ.xlsx")
data_20_UZ = pd.read_excel("CAB_2020_UZ.xlsx")

# no 2020 Turkmenistan data
download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-8-excel-tajikistan-2020-autumn.xlsx", "CAB_2020_TJ.xlsx")
data_20_TJ = pd.read_excel("CAB_2020_TJ.xlsx")

# download 2018 data
download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-kyrgyzstan-2018-autumn.xlsx", "CAB_2018_KG.xlsx")
data_18_KG = pd.read_excel("CAB_2018_KG.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-kazakhstan-2018-autumn.xlsx", "CAB_2018_KZ.xlsx")
data_18_KZ = pd.read_excel("CAB_2018_KZ.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-uzbekistan-2018-autumn.xlsx", "CAB_2018_UZ.xlsx")
data_18_UZ = pd.read_excel("CAB_2018_UZ.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-turkmenistan-2018-autumn.xlsx", "CAB_2018_TM.xlsx")
data_18_TM = pd.read_excel("CAB_2018_TM.xlsx")

download_file("https://ca-barometer.org/assets/files/projects/central-asia-barometer-survey-wave-4-excel-tajikistan-2018-autumn.xlsx", "CAB_2018_TJ.xlsx")
data_18_TJ = pd.read_excel("CAB_2018_TJ.xlsx")

# data_22_KG <- mutate(data_22_KG, Country = 'Kyrgyzstan')
data_22_KG['Country'] = 'Kyrgyzstan'
data_20_KG['Country'] = 'Kyrgyzstan'
# data_18_KG <- mutate(data_18_KG, Country = 'KG')
data_22_KZ['Country'] = 'Kazakhstan'
data_20_KZ['Country'] = 'Kazakhstan'
# data_18_KZ <- mutate(data_18_KZ, Country = 'KZ')
data_22_UZ['Country'] = 'Uzbekistan'
data_20_UZ['Country'] = 'Uzbekistan'
# data_18_UZ <- mutate(data_18_UZ, Country = 'UZ')
data_22_TM['Country'] = 'Turkmenistan'
data_22_TJ['Country'] = 'Tajikistan'
data_20_TJ['Country'] = 'Tajikistan'

# data_2022 <- rbind(data_22_KZ, data_22_KG, data_22_UZ)
data_2022 = pd.concat([data_22_KZ, data_22_KG, data_22_UZ], ignore_index=True)

# setdiff(names(data_22_KG),names(data_22_KZ))
print(set(data_22_KG.columns) - set(data_22_KZ.columns))
print(set(data_22_KG.columns) - set(data_22_UZ.columns))
print(set(data_22_KZ.columns) - set(data_22_UZ.columns))

# my_test_join <- full_join(data_22_KG, data_22_KZ)
my_test_join = pd.merge(data_22_KG, data_22_KZ, how='outer')

# data_22_KG$MM8 <- 2022
data_22_KG['MM8'] = 2022
data_22_KZ['MM8'] = 2022
data_22_UZ['MM8'] = 2022
data_20_KG['MM8'] = 2020
data_20_KZ['MM8'] = 2020
data_20_UZ['MM8'] = 2020

# class(data_22_KG$MM8)
print(type(data_22_KG['MM8']))
print(data_22_KG['MM8'].dtype)

# my_test_join <- full_join(data_22_KG, data_22_KZ)
my_test_join = pd.merge(data_22_KG, data_22_KZ, how='outer')

# data_22_KG <- data_22_KG |> rename('Year'='MM8')
data_22_KG = data_22_KG.rename(columns={'MM8': 'Year'})
data_22_KZ = data_22_KZ.rename(columns={'MM8': 'Year'})
data_22_UZ = data_22_UZ.rename(columns={'MM8': 'Year'})

# mydata2022 <- full_join(data_22_KG, data_22_KZ)
mydata2022 = pd.merge(data_22_KG, data_22_KZ, how='outer')
mydata2022 = pd.merge(mydata2022, data_22_UZ, how='outer')
mydata2020 = pd.merge(data_20_KG, data_20_KZ, how='outer')
mydata2020 = pd.merge(mydata2020, data_20_UZ, how='outer')
mydata2018 = pd.merge(data_18_KG, data_18_KZ, how='outer')

# data_18_UZ$HHLandlines <- as.character(data_18_UZ$HHLandlines)
data_18_UZ['HHLandlines'] = data_18_UZ['HHLandlines'].astype(str)
mydata2018 = pd.merge(mydata2018, data_18_UZ, how='outer')

# Renaming logic
rename_dict_2022 = {
    'DD1': 'Sex', 'DD2': 'Age', 'DD3': 'Marital',
    'DD4': 'Education', 'DD6a': 'Employment',
    'D1': 'Direction', 'E1a': 'China_Favor',
    'E1b': 'Russia_Favor', 'E1c': 'USA_Favor',
    'A1a': 'Main_News', 'DD9a': 'Remit',
    'DD11': 'Language', 'B4a': 'Country_Fin_Sit',
    'B4b': 'Family_Fin_Sit'
}
mydata2022 = mydata2022.rename(columns=rename_dict_2022)

select_cols = ['Sex', 'Age', 'Marital', 'Education', 'Employment', 'Direction', 
               'China_Favor', 'Russia_Favor', 'USA_Favor', 'Main_News', 
               'Remit', 'Language', 'Country_Fin_Sit', 'Family_Fin_Sit', 'Country', 'Year']
mydata2022_select = mydata2022[select_cols]

rename_dict_2020 = {
    'DD1': 'Sex', 'DD2': 'Age', 'DD3': 'Marital',
    'DD4': 'Education', 'DD6a': 'Employment',
    'D1': 'Direction', 'E1a': 'China_Favor',
    'E1b': 'Russia_Favor', 'E1c': 'USA_Favor',
    'A1a': 'Main_News', 'DD9': 'Language',
    'B4a': 'Country_Fin_Sit', 'B4b': 'Family_Fin_Sit',
    'MM8': 'Year'
}
mydata2020 = mydata2020.rename(columns=rename_dict_2020)

select_cols_2020 = ['Sex', 'Age', 'Marital', 'Education', 'Employment', 'Direction', 
                    'China_Favor', 'Russia_Favor', 'USA_Favor', 'Main_News', 
                    'Language', 'Country_Fin_Sit', 'Family_Fin_Sit', 'Country', 'Year']
mydata2020_select = mydata2020[select_cols_2020].copy()
mydata2020_select['Remit'] = np.nan

rename_dict_2018 = {
    'Gender': 'Sex', 'MarriageStat2': 'Marital',
    'EducLevel_M': 'Education', 'Work': 'Employment',
    'RiteRong_M': 'Direction', 'OpinionChina': 'China_Favor',
    'OpinionRussia': 'Russia_Favor', 'OpinionUSA': 'USA_Favor',
    'MainNews_M': 'Main_News', 'Homelang': 'Language',
    'Language': 'LangExtra', 'TodayEcSit_M': 'Country_Fin_Sit',
    'Lastyear_M': 'Family_Fin_Sit', 'IncomeOut': 'Remit'
}
mydata2018 = mydata2018.rename(columns=rename_dict_2018)
mydata2018_select = mydata2018[['Sex', 'Age', 'Marital', 'Education', 'Employment', 
                                'Direction', 'China_Favor', 'Russia_Favor', 'USA_Favor', 
                                'Main_News', 'Language', 'Country_Fin_Sit', 'Remit', 
                                'Family_Fin_Sit', 'Country', 'Year']]

# my_final_data <- rbind(mydata2018_select, mydata2020_select, mydata2022_select)
my_final_data = pd.concat([mydata2018_select, mydata2020_select, mydata2022_select], ignore_index=True)

print(my_final_data.info())
print(my_final_data.describe(include='all'))

# Helper for tables
def get_table(df, col1, col2=None):
    if col2 is None:
        return df[col1].value_counts(dropna=False)
    else:
        return pd.crosstab(df[col1], df[col2], dropna=False)

cols_to_table = ['Sex', 'Age', 'Marital', 'Education', 'Employment', 'Direction', 
                 'China_Favor', 'Russia_Favor', 'USA_Favor', 'Main_News', 
                 'Country_Fin_Sit', 'Remit', 'Family_Fin_Sit', 'Country', 'Year']

for col in cols_to_table:
    print(f"\nTable for {col}:")
    print(get_table(my_final_data, col))

# Fix Remit
my_final_data['Remit'] = pd.to_numeric(my_final_data['Remit'], errors='coerce')

print("\nTable Direction vs Sex:")
print(pd.crosstab(my_final_data['Direction'], my_final_data['Sex']))
print("\nTable Marital vs Employment:")
print(pd.crosstab(my_final_data['Marital'], my_final_data['Employment']))

# Replace Values Logic
def replace_values_func(series, mapping_dict):
    new_series = series.copy()
    for keys, val in mapping_dict.items():
        if isinstance(keys, tuple):
            new_series = new_series.replace(list(keys), val)
        else:
            new_series = new_series.replace(keys, val)
    return new_series

my_final_data['Marital_recode'] = replace_values_func(my_final_data['Marital'], {
    ("Don't Know (vol.)", "Refused (vol.)"): np.nan
})

my_final_data['Employment_recode'] = replace_values_func(my_final_data['Employment'], {
    ("Don't Know (vol.)", "Refused (vol.)"): np.nan
})

my_final_data['Employment_recode2'] = replace_values_func(my_final_data['Employment'], {
    ("Working part-time", "Working full-time"): "Working",
    ("Unemployed and not actively seeking employment", "Unemployed and actively seeking employment"): "Unemployed",
    ("A housewife / househusband", "A housewife"): "Housewife",
    ("Don't Know (vol.)", "Refused (vol.)"): np.nan
})

my_final_data['Direction_recode'] = replace_values_func(my_final_data['Direction'], {
    ("Don't Know (vol.)", "Refused (vol.)", "Not asked"): np.nan
})

my_final_data['Family_Fin_Sit_recode'] = replace_values_func(my_final_data['Family_Fin_Sit'], {
    ("Much better", "Much Better", "Become Better", "Somewhat better", "Somewhat Better"): "Better",
    ("About the same", "Stayed the Same"): "Same",
    ("Become Worse", "Much Worse", "Much worse", "Somewhat Worse", "Somewhat worse"): "Worse",
    ("Don't Know (vol.)", "Refused (vol.)"): np.nan
})

print("\nTable Marital Recode vs Employment Recode:")
print(pd.crosstab(my_final_data['Marital_recode'], my_final_data['Employment_recode']))

# chisq.test
contingency = pd.crosstab(my_final_data['Direction'], my_final_data['Sex'])
chi2, p, dof, expected = chi2_contingency(contingency)
print(f"\nChi-square test: chi2={chi2}, p={p}")

# plot(Remit~Year)
plt.figure()
plt.scatter(my_final_data['Year'], my_final_data['Remit'])
plt.xlabel('Year')
plt.ylabel('Remit')
plt.title('Remit vs Year')
plt.show()

# abline(lm(Remit~Year))
sns.regplot(x='Year', y='Remit', data=my_final_data, line_kws={"color": "red"})
plt.show()

# xyplot equivalents (using Seaborn)
sns.lmplot(x='Age', y='Remit', hue='Country', data=my_final_data, fit_reg=False)
plt.show()

g = sns.FacetGrid(my_final_data, col='Country', hue='Language', col_wrap=3)
g.map(plt.scatter, 'Age', 'Remit').add_legend()
plt.show()

# ggplot2 translations
p1 = (ggplot(my_final_data, aes(y='Remit', x='Age')) + facet_grid('.~Country') + geom_point(aes(color='Sex')))
print(p1)

p2 = (ggplot(my_final_data, aes(y='Remit', x='Age')) + facet_grid('Country~.') + geom_point(aes(color='Marital')) +
      labs(x="age", y="% remittances", title="Remittance as percentage of income"))
print(p2)

# Bar plots
country_colors = ["#40E0D0", "#FF3030", "#2E8B57"] # turquoise1, firebrick1, seagreen3 approx
p3 = (ggplot(my_final_data, aes(x='Sex', fill='Country')) + geom_bar(position="stack") + scale_fill_manual(values=country_colors))
print(p3)

# Favorability plots
China = (ggplot(my_final_data, aes('China_Favor', fill='Country')) + geom_bar(position="dodge") + 
         scale_fill_manual(values=country_colors) + coord_flip())
Russia = (ggplot(my_final_data, aes('Russia_Favor', fill='Country')) + geom_bar(position="dodge") + 
          scale_fill_manual(values=country_colors) + coord_flip())
USA = (ggplot(my_final_data, aes('USA_Favor', fill='Country')) + geom_bar(position="dodge") + 
       scale_fill_manual(values=country_colors) + coord_flip())

print(China)
print(Russia)
print(USA)

# Save output
# pio.write_image is used for plotly; for matplotlib/plotnine:
USA.save("output.pdf")
p3.save("output.jpg")

# Histograms and complex faceting
p4 = (ggplot(my_final_data, aes('Age')) + geom_histogram(aes(fill='after_stat(count)')) + facet_grid('Country~.'))
print(p4)

p5 = (ggplot(my_final_data, aes('Employment_recode2', fill='factor(Marital_recode)')) + 
      facet_grid('Country~.') + geom_bar(position="dodge") + 
      theme(panel_background=element_rect(fill='beige', color='darkblue')) + 
      labs(x="Work status", y="Count", title="Employment by Marital Status") + coord_flip())
print(p5)

# Direction plots
p6 = (ggplot(my_final_data, aes('Direction_recode', fill='Country')) + 
      facet_grid('Family_Fin_Sit_recode~.') + 
      labs(x="Response", y="Count", title="Going in Right or Wrong Direction vs. Family situation?") + 
      scale_fill_manual(values=country_colors) + 
      theme(panel_background=element_rect(fill='beige', color='darkblue')))
print(p6)

# Boxplots
p7 = (ggplot(my_final_data, aes(x='Remit', y='Country', fill='Country')) + geom_boxplot() + coord_flip() + 
      theme_minimal() + scale_fill_manual(values=country_colors))
print(p7)

# Interactive Plot (using Plotly as ggiraph equivalent)
fig = px.scatter(my_final_data, x="Remit", y="Age", color="Country", 
                 hover_data=["Marital"], title="Age vs Remittance")
fig.write_html("ggiraph-2.html")

# Compute percentages (Matrix logic)
my_final_data['Direction_recode'] = my_final_data['Direction_recode'].astype('category')

def get_direction_pct(df):
    counts = df['Direction_recode'].value_counts()
    # Assuming "Right direction" is index 0 or similar to R logic
    try:
        right = counts.get("Right direction", 0)
        wrong = counts.get("Wrong direction", 0)
        return right / (right + wrong) if (right + wrong) > 0 else np.nan
    except:
        return np.nan

countries = ["Kazakhstan", "Kyrgyzstan", "Uzbekistan"]
years = [2018, 2020, 2022]
matrix_data = []

for c in countries:
    row = {'Country': c}
    for y in years:
        sub = my_final_data[(my_final_data['Country'] == c) & (my_final_data['Year'] == y)]
        if c == "Uzbekistan" and y == 2022:
            row[str(y)] = np.nan
        else:
            row[str(y)] = get_direction_pct(sub)
    matrix_data.append(row)

Direction_pct_matrix = pd.DataFrame(matrix_data)
Direction_long = Direction_pct_matrix.melt(id_vars='Country', var_name='Year', value_name='Value')
Direction_long['Year'] = pd.to_numeric(Direction_long['Year'])

p8 = (ggplot(Direction_long, aes(x='Year', y='Value', color='Country')) + 
      geom_line() + theme_tufte() + scale_color_brewer(type='qual', palette='Dark2') + 
      labs(title="Right Direction over time", y="Percentage"))
print(p8)

# Regressions
# Handling categoricals for statsmodels
model_data = my_final_data.dropna(subset=['Remit', 'Sex', 'Language', 'Age', 'Employment', 'Education', 'Country', 'Year'])

reg1 = smf.ols('Remit ~ Year', data=model_data).fit()
print(reg1.summary())

reg2 = smf.ols('Remit ~ Sex + Language', data=model_data).fit()
print(reg2.summary())

formula_all = 'Remit ~ Sex + Age + Language + Employment + Education + Country + Year'
reg_all = smf.ols(formula_all, data=model_data).fit()
print(reg_all.summary())

# Backward step equivalent
def backward_elimination(data, target, columns):
    while len(columns) > 0:
        formula = f"{target} ~ {' + '.join(columns)}"
        model = smf.ols(formula, data=data).fit()
        p_values = model.pvalues.drop('Intercept')
        max_p = p_values.max()
        if max_p > 0.05:
            remove_col = p_values.idxmax()
            columns.remove(remove_col)
        else:
            break
    return model

# Simplified demographic columns for stepwise (excluding complex categorical overlaps if necessary)
demo_cols = ['Sex', 'Age', 'Language', 'Employment', 'Education', 'Country', 'Year']
backward_model = backward_elimination(model_data, 'Remit', demo_cols)
print(backward_model.summary())

# Notes from CodeConvert.ai

# - **Libraries**:
#     - `pak` and `tidyverse` were replaced by `pandas`, `numpy`, `requests`, and `plotnine`.
#     - `lattice` and `cowplot` functionalities were implemented using `seaborn` or `plotnine`.
#     - `reticulate` is not needed as the code is now natively in Python.
#     - `ggiraph` (interactive plots) was translated using `plotly`, which is the standard Python equivalent for interactive web-based visualizations.
# - **Data Manipulation**:
#     - `mutate` -> Direct column assignment in pandas.
#     - `full_join` -> `pd.merge(..., how='outer')`.
#     - `rbind` -> `pd.concat()`.
#     - `rename` -> `df.rename(columns=...)`.
 #    - `as.numeric` -> `pd.to_numeric`.
# - **Recoding**:
#     - The R code uses a syntax characteristic of `sjmisc::replace_values`. I implemented a helper function `replace_values_func` in Python to map specific values (including tuples for multiple matches) to new values or `np.nan`.
# - **Plotting**:
#     - `plotnine` provides an almost exact syntax for `ggplot2`.
#     - For `lattice`'s `xyplot`, I used `seaborn.FacetGrid` as it handles the "trellis" style faceting similarly.
#     - Color palettes from `RColorBrewer` and `paletteer` were mapped to their nearest hex or standard library equivalents.
# - **Statistical Analysis**:
#     - `chisq.test` -> `scipy.stats.chi2_contingency`.
#     - `lm` -> `statsmodels.formula.api.ols`.
#     - `step(..., direction="backward")`: Python's `statsmodels` does not have a built-in `step` function exactly like R. I implemented a manual `backward_elimination` function that iterates and removes variables with p-values > 0.05.
# - **Interactive Output**:
#     - `htmltools::save_html` -> `fig.write_html` in Plotly.
# - **Formatting**:
#     - Preserved all comments and the general flow of the script.
#     - Python does not have `attach()`, so I accessed columns via the dataframe object (`my_final_data['col']`).
# - **File Extensions**:
#     - Downloaded files were saved as `.xlsx` instead of `.csv` because the source URLs point to Excel files (`.xlsx`), and `pd.read_excel` is used (consistent with `read_excel` in R). The R code erroneously named them `.csv` but read them as Excel.
