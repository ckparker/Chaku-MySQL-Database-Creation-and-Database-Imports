import pandas as pd
import mysql.connector

# Database connection
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '*****',
    'database': '*****'
}

# Load the Excel file
excel_file_path = r"C:\Users\CHAKU FOODS\Documents\MySQL Chaku Database Creation\Picture Dates.xlsx"
data = pd.read_excel(excel_file_path)

# Connect to the database
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()

# Iterate through the DataFrame and update data in the tree_data table
for index, row in data.iterrows():
    last_name = row['last_name']
    first_name = row['first_name']
    picture_date = row['picture_date']

    # Get farmer_id based on last_name and first_name
    cursor.execute("""
        SELECT farmer_id FROM farmer 
        WHERE last_name = %s AND first_name = %s
    """, (last_name, first_name))
    
    result = cursor.fetchone()
    
    if result:
        farmer_id = result[0]
        
        # Update the existing row in tree_data table
        cursor.execute("""
            UPDATE tree_data 
            SET picture_date = %s 
            WHERE farmer_id = %s
        """, (picture_date, farmer_id))
    else:
        print(f"Farmer not found for {first_name} {last_name}")

# Commit the changes and close the connection
connection.commit()
cursor.close()
connection.close()

# Print success message
print("Data has been updated successfully.")