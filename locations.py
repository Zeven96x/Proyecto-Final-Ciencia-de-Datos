from textblob import TextBlob
import pandas as pd
import numpy as np

locations = pd.read_excel(io = 'locations.xls')

top = pd.DataFrame(columns=['lugar', 'cantidas'])
pais= []
cantidad= []

#print(locations)
n=0
for i in locations.index: 
    #print(locations["x"][i])
    if locations["x"][i] in pais:
        print("lel")
    else:
        pais.append(locations["x"][i])
        cantidad.append(0)

for i in locations.index:
    for j in range(2,len(pais)-1): 
        if locations["x"][i] == pais[j]:
            cantidad[j]=cantidad[j]+1


user_list = list(zip(pais, cantidad))
df = pd.DataFrame(user_list)

print(df)

df.to_csv("topLocations.csv")