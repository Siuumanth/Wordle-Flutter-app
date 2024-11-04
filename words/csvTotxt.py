import pandas as pd


df = pd.read_csv("words/wordle.csv")



allWords = df['word'].tolist()


f1 = open("words/twelveK.txt","w",encoding="utf-8")

for word in allWords:
    temp = str(word) + '\n'
    f1.write(temp)

