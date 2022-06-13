import pandas as pd
from lyricsgenius import Genius
#Musestra el dataFrame completo
df = pd.read_csv('C:\\Users\\Alfonso\\Dropbox\\python ciencia de datos\\surveys.csv')
#remover celdas vacias

new_df = df.dropna()
print(new_df.head())

#remplazar vacios

df = pd.read_csv('C:\\Users\\Alfonso\\Dropbox\\python ciencia de datos\\surveys.csv')
df.fillna(130,inplace=True)
print(df.head())


