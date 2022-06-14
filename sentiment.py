from textblob import TextBlob
import pandas as pd

df = pd.read_excel(io = 'noticias_x.xls')

new_df = df.assign(score=0)
new_df.columns
string = str(new_df.head(1)['newdata.text'])
for tweet in new_df