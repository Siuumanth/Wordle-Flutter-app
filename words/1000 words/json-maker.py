import json

f1 = open("words/filtered-words.txt","r",encoding="utf-8")
filtered_words = f1.readlines()
filtered_words = [ word[:5] for word in filtered_words]

f2 = open("words/raw-text.txt","r",encoding="utf-8")
lines = f2.readlines()


unfiltered_words = []
meanings = []
sentances = []

ban_list=[]
for i in range(len(lines)) :
    temp_word = lines[i][0:5]
    unfiltered_words.append(temp_word)

    splitting = lines[i][6:].split('.')
    meanings.append(splitting[0])
    try:
        sentances.append(splitting[1][2:])
    except:
        sentances.append(" ")
        ban_list.append(i)
        continue


final_words = {}

#binary search :
for i in range(len(filtered_words)):
    low = 0
    high = len(unfiltered_words) - 1
    key_word = filtered_words[i]
    index = -1
    while high>=low:
        mid = (low + high) //2
        if key_word == unfiltered_words[mid]:
            index = mid
            break
        elif key_word > unfiltered_words[mid]:
            low = mid + 1
        elif key_word < unfiltered_words[mid]:
            high = mid - 1

    if index!= -1:
        if index not in ban_list:
            final_words[key_word] = [meanings[index],sentances[index]]
    

fjson= open("words/words_meanings.json","w",encoding = "utf-8") 
json.dump(final_words,fjson,indent = 4)




