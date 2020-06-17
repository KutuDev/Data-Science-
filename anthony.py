import pandas as pd

#score_table = pd.read_csv("/storage/emulated/0/python/scores.csv")

score_table = pd.read_csv("/storage/emulated/0/python/grades.csv")

#print(score_table.head())

#remove irrelevant columns
score_table = score_table.drop(['Unnamed: 0'], axis = 1)

#remove irrelevant columns
#score_table = score_table.drop(['Unnamed: 0', 'Unnamed: 2', 'Unnamed: 3', 'Unnamed: 5', 'Unnamed: 6', 'Total Points ', 'S.P'], axis = 1)

#score_table.to_csv("grades.csv", sep = ",")

#list of column titles present in dataset
#col_names = score_table.columns.tolist()
#print("Column names:", col_names)

#print("The dimension of the dataset is:", score_table.shape)

#fill NaN values
score_table = score_table.fillna("—")

#checks if contains empty values
#print("NaN boolean dataframe for sheet is:")
#print(score_table.isnull().any())

def swap(input):
	for i in score_table[input]:
		score_table[input] = score_table[input].replace("—", 0) 
		if type(i) == str:
			for j in range(0, 200):
				score_table[input].iloc[j] = int(score_table[input].iloc[j]) 

swap("Quiz ")
swap("W.A")
swap("C.E")

total_points = []
S_P = []

for i in range(0, 200):
	total = score_table["Quiz "].iloc[i] + score_table["W.A"].iloc[i] + score_table["C.E"].iloc[i]
	total_percentage = round(((total/110) * 100), 2)
	
	total_points.append(total)
	S_P.append(total_percentage)
		
score_table["Total Points"] = total_points
score_table["S.P(%)"] = S_P

print(score_table.tail())

#score_table.to_csv("results.csv", sep = ",")
score_table.to_excel("results.xlsx", sheet_name = "Sheet1", index = False)