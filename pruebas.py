import pandas as pd
import numpy as np

df = pd.DataFrame({'uno': [1, 2, 3], 'dos': [4, 5, 6], 'tres': [7, 8, 9]}, index=['x', 'y', 'z'])

# Iteración por columnas del DataFrame:
for col in df:
	print(df[col].mean())
	
print()

