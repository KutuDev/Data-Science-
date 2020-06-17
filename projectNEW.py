import numpy as np 
import pandas as pd
from pandas import DataFrame
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix

#(1) reading the two sheets in dataset

### "existing employees" data is stored in the variable sheet1 while "employees who have left" data is stored in sheet2

sheet1 = excelFile.parse('Existing employees')
sheet2 = excelFile.parse('Employees who have left')
excelFile = pd.ExcelFile("TakenMind-Python-Analytics-Problem-case-study-1-1.xlsx")

#(2) Data preprocessing
print("The sheet named 'Existing employees' has the below dimension:")
print(sheet1.shape)

print("The sheet named 'Employees who have left' has the below dimension:")
print(sheet2.shape)

#removing unneeded 'Emp_ID' column in both sheets
sheet1 = sheet1.drop('Emp ID', axis = 1)
sheet2 = sheet2.drop('Emp ID', axis = 1)

#list of column titles present in dataset
col_names = sheet1.columns.tolist()
print("Column names:")
print(col_names)

print("The elements present in sheet1's 'dept' column are:")
print(sheet1['dept'].unique())

sheet1['dept']=np.where(sheet1['dept'] =='support', 'technical', sheet1['dept'])
sheet1['dept']=np.where(sheet1['dept'] =='IT', 'technical', sheet1['dept'])

print("The elements present in sheet1's 'dept' column after combining 3 subsets into 1 are:")
print(sheet1['dept'].unique())

print("The elements present in sheet2's 'dept' column are:")
print(sheet2['dept'].unique())

# variables support, technical, IT in the 'dept' column are all combined into the technical variable
sheet2['dept']=np.where(sheet2['dept'] =='support', 'technical', sheet2['dept'])
sheet2['dept']=np.where(sheet2['dept'] =='IT', 'technical', sheet2['dept'])

print("The elements present in sheet2's 'dept' column after combining 3 subsets into 1 are:")
print(sheet2['dept'].unique())

#checks if sheet1 and sheet2 contains empty values
print("NaN boolean dataframe for sheet1 is:")
print(sheet1.isnull().any())

print("NaN boolean dataframe for sheet2 is:")
print(sheet2.isnull().any())

#(3) Data exploration

print("Total existing employees that have not left is:")
print(sheet1.shape[0])

print("Total employees that had left is:")
print(sheet2.shape[0])

print("The mean values of total employees that have not left are:")
print(sheet1.mean())

print("The mean values of total employees that had left are:")
print(sheet2.mean())

print("The mean values for the 'dept' categorical data in sheet1 are:")
print(sheet1.groupby('dept').mean())

print("The mean values for the 'dept' categorical data in sheet2 are:")
print(sheet2.groupby('dept').mean())

print("The mean values for the 'salary' categorical data in sheet1 are:")
print(sheet1.groupby('salary').mean())

print("The mean values for the 'salary' categorical data in sheet2 are:")
print(sheet2.groupby('salary').mean())

#(4)visualization of data

#histogram plots for the numerical data in sheet1
figA = sns.distplot(sheet1['Work_accident'], bins = 15, kde = False).get_figure()
figA.savefig('histPlotA.png')

figB = sns.distplot(sheet1['average_montly_hours'], bins = 15, kde = False).get_figure()
figB.savefig('histPlotB.png')

figC = sns.distplot(sheet1['last_evaluation'], bins = 15, kde = False).get_figure()
figC.savefig('histPlotC.png')

figD = sns.distplot(sheet1['number_project'], bins = 15, kde = False).get_figure()
figD.savefig('histPlotD.png')

figE = sns.distplot(sheet1['promotion_last_5years'], bins = 15, kde = False).get_figure()
figE.savefig('histPlotE.png')

figF = sns.distplot(sheet1['satisfaction_level'], bins = 15, kde = False).get_figure()
figF.savefig('histPlotF.png')

figG = sns.distplot(sheet1['time_spend_company'], bins = 15, kde = False).get_figure()
figG.savefig('histPlotG.png')

#histogram plots for the numerical data in sheet2
fig1 = sns.distplot(sheet2['Work_accident'], bins = 15, kde = False).get_figure()
fig1.savefig('histPlot1.png')

fig2 = sns.distplot(sheet2['average_montly_hours'], bins = 15, kde = False).get_figure()
fig2.savefig('histPlot2.png')

fig3 = sns.distplot(sheet2['last_evaluation'], bins = 15, kde = False).get_figure()
fig3.savefig('histPlot3.png')

fig4 = sns.distplot(sheet2['number_project'], bins = 15, kde = False).get_figure()
fig4.savefig('histPlot4.png')

fig5 = sns.distplot(sheet2['promotion_last_5years'], bins = 15, kde = False).get_figure()
fig5.savefig('histPlot5.png')

fig6 = sns.distplot(sheet2['satisfaction_level'], bins = 15, kde = False).get_figure()
fig6.savefig('histPlot6.png')

fig7 = sns.distplot(sheet2['time_spend_company'], bins = 15, kde = False).get_figure()
fig7.savefig('histPlot7.png')

# Model creation

#creating dummies for categorical variables 
dummy1 = pd.get_dummies(sheet1.dept, prefix = "dept").iloc[:, 1:]
dummy2 = pd.get_dummies(sheet1.salary, prefix = "salary").iloc[:, 1:]
sheet1 = pd.concat([sheet1,dummy1, dummy2], axis = 1)
sheet1 = sheet1.drop(["dept", "salary"], axis= 1)

dummy3 = pd.get_dummies(sheet2.dept, prefix = "dept").iloc[:, 1:]
dummy4 = pd.get_dummies(sheet2.salary, prefix = "salary").iloc[:, 1:]
sheet2 = pd.concat([sheet2, dummy3, dummy4], axis = 1)
sheet2 = sheet2.drop(["dept", "salary"], axis= 1)

#adds a new column bt the name attritionn_status filled with boolean True or False
sheet1 = DataFrame(sheet1, columns = ['satisfaction_level', 'last_evaluation', 'number_project', 'average_monthly_hours', 'time_spend_company', 'promotion_last_5years', 'dept', 'salary', 'attrition_status'])
sheet1 = sheet1.fillna(bool(0))

sheet2 = DataFrame(sheet1, columns = ['satisfaction_level', 'last_evaluation', 'number_project', 'average_monthly_hours', 'time_spend_company', 'promotion_last_5years', 'dept', 'salary', 'attrition_status'])
sheet2 = sheet2.fillna(bool(1))

#creates a single dataframe needed for model prediction from sheet1 and sheet2
sheet = pd.concat([sheet1, sheet2], ignore_index=True)

#setting training and test attributes
X = sheet.drop('attrition_status', axis = 1)
y = sheet['attrition_status']

#splitting dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30)

#training algorithm
classifier = DecisionTreeClassifier()
classifier.fit(X_train, y_train)

#prediction
y_pred = classifier.predict(X_test)

#trained algorithm evaluation
print("confusion matrix is:")
print(confusion_matrix(y_test, y_pred))

percentage_of_accuracy = accuracy_score(y_test, y_pred)*100
print("model's percentage of accuracy is:")
print(percentage_of_accuracy)