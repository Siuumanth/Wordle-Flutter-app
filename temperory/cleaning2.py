
input_file = "D:/code/Flutter/Wordle/assets/filtered-words.txt"  



f1 = open(input_file,"r")

words1 = f1.readlines()
print(words1[0:5])
fivePlus = 0
temp=0
for i in range(len(words1)-1200):
    if(len(words1[i]-1)):
        fivePlus+=1
        print(words1[i][0:5])
    else:
        temp+=1
    
        

print(fivePlus)
print(temp)
