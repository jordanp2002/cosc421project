#use this to split up the data into smaller chunks
import pandas as pd

# Step 2: Read the CSV file into a DataFrame
df = pd.read_csv('large_twitch_edges.csv')

# Step 3: Select the top whatever rows
top_10000 = df.head(300000)

# Step 4: Save the selected rows to a new CSV file
top_10000.to_csv('top_300000_edges.csv', index=False)