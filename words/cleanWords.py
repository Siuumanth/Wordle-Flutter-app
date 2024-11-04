f1 = open("assets/filtered-words.txt","r")
f2 = open("assets/twelveK.txt","r")

words1 = f1.readlines()
words2 = f2.readlines()

c=0
temp = []

for i in range(len(words1)):
    low = 0
    high = len(words2) - 1
    key_word =words1[i].lower()
    index = -1
    while high>=low:
        mid = (low + high) //2
        if key_word[0:5] == words2[mid][0:5]:
            index = mid
            break
        elif key_word[0:5] > words2[mid][0:5]:
            low = mid + 1
        elif key_word[0:5] < words2[mid][0:5]:
            high = mid - 1
    

    if index== -1:
        temp.append(key_word)
        c+=1
        print(key_word)
        print(words1.index(key_word))
        

print(c)
