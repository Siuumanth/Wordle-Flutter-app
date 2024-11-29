
input_file = "D:/code/Flutter/Wordle/assets/filtered-words.txt"  
output_file = "D:/code/Flutter/Wordle/assets/filtered-words2.txt"  


f1 = open(input_file,"r")
f2 = open(output_file,"w")
words1 = f1.readlines()
print(words1[0:5])
fivePlus = 0
for i in range(len(words1)-1):
    if(words1[i][5]!=' '):
        fivePlus+=1
        

print(fivePlus)
