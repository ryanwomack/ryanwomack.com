import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
import statsmodels.formula.api as smf

# Download file
import urllib.request
url = "https://ca-barometer.org/assets/files/projects/cab-survey-wave-12-excel-kyrgyzstan-kyrgyzstan-2022-autumn.xlsx"
filename = "CAB_2022.xlsx"
urllib.request.urlretrieve(url, filename)

# Read Excel file
mydata = pd.read_excel(filename)

# Rename columns
mydata = mydata.rename(columns={'DD1': 'Sex', 'MM10': 'Region', 'DD11': 'Language', 'DD8': 'Income'})

# Descriptives
print(mydata['Sex'].value_counts())
print(mydata['Region'].value_counts())
print(mydata['Language'].value_counts())
print(mydata['Income'].value_counts())
print(mydata['EthnicGrp'].value_counts())
print(pd.crosstab(mydata['Sex'], mydata['Language']))
print(pd.crosstab(mydata['Income'], mydata['Sex']))
print(mydata['E17'].value_counts())
print(mydata['Sex'].value_counts()) 

# Recode Income to numeric
income_map = {
    "Less than 2,801 som": 1400,
    "2,801 - 4,100 som": 3400,
    "4,101 - 6,000 som": 5000,
    "6,001 - 8,000 som": 7000,
    "8,001 - 10,000 som": 9000,
    "10,001 - 12,000 som": 11000,
    "12,001 - 16,000 som": 14000,
    "16,001 - 20,000 som": 18000,
    "20,001 - 28,000 som": 24000,
    "More than 28,000 som": 40000,
    "Don't Know (vol.)": np.nan,
    "Refused (vol.)": np.nan
}
mydata['Income_Numeric'] = mydata['Income'].map(income_map)

# Mean Income_Numeric ignoring NaNs
mean_income = mydata['Income_Numeric'].mean(skipna=True)
print(mean_income)

# Histogram of Income_Numeric
plt.hist(mydata['Income_Numeric'].dropna())
plt.xlabel('Income_Numeric')
plt.ylabel('Frequency')
plt.title('Histogram of Income_Numeric')
plt.show()

# Group by Sex and mean Income_Numeric
print(mydata.groupby('Sex')['Income_Numeric'].mean())

# t-test Income_Numeric by Sex
group1 = mydata.loc[mydata['Sex'] == mydata['Sex'].unique()[0], 'Income_Numeric'].dropna()
group2 = mydata.loc[mydata['Sex'] == mydata['Sex'].unique()[1], 'Income_Numeric'].dropna()
t_stat, p_val = stats.ttest_ind(group1, group2, equal_var=False)
print(f"T-test statistic: {t_stat}, p-value: {p_val}")

# Tables for research
print(pd.crosstab(mydata['Sex'], mydata['A3a']))
print(mydata['D1'].value_counts())
print(pd.crosstab(mydata['D1'], mydata['Sex']))
print(pd.crosstab(mydata['D1'], mydata['Region']))
print(pd.crosstab(mydata['D1'], mydata['Language']))
print(pd.crosstab(mydata['D1'], mydata['Income_Numeric']))

# Recode D1
def recode_d1(val):
    if val == "Right direction":
        return "Right"
    elif val == "Wrong direction":
        return "Wrong"
    elif val in ["Don't Know (vol.)", "Refused (vol.)"]:
        return np.nan
    else:
        return val

mydata['D1_recode'] = mydata['D1'].apply(recode_d1).astype('category')

# Illustrative plots
plt.clf()
sns.scatterplot(data=mydata, x='Income_Numeric', y='Region')
plt.show()

plt.clf()
sns.stripplot(data=mydata, x='Region', y='Income_Numeric', jitter=True)
plt.show()

plt.clf()
mydata.boxplot(column='Income_Numeric', by='D1', grid=False)
plt.suptitle('')
plt.show()

plt.clf()
mydata.boxplot(column='Income_Numeric', by='D1_recode', grid=False)
plt.suptitle('')
plt.show()

plt.clf()
sns.countplot(data=mydata, x='D1_recode', hue='Sex')
plt.show()

# Logistic regression
# Drop rows with missing values in relevant columns
logistic_data = mydata.dropna(subset=['D1_recode', 'Sex', 'Language', 'Income_Numeric'])

# Convert categorical variables to category dtype for statsmodels
# one spot where the syntax is a little questionable
logistic_data['Sex'] = logistic_data['Sex'].astype('category')
logistic_data['Language'] = logistic_data['Language'].astype('category')
logistic_data['D1_recode'] = logistic_data['D1_recode'].astype('category')

# Fit logistic regression model
model = smf.glm(formula='D1_recode ~ Sex + Language + Income_Numeric', data=logistic_data,
                family=sm.families.Binomial()).fit()
print(model.summary())
