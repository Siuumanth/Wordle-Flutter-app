f2 = open("words/raw-text.txt","r",encoding="utf-8")
lines = f2.readlines()

line = lines [0]
splitting = line[6:].split('.')
print(splitting[1][2:])