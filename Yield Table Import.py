import pandas as pd
import mysql.connector
from datetime import datetime

# Database connection configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'KpakpoParker700!',
    'database': 'chaku_foods_db'
}

try:
    # Read the Excel file
    df = pd.read_excel(r"C:\Users\CHAKU FOODS\Documents\MySQL Chaku Database Creation\Yield and Revenue Table.xlsx")
    # Connect to MySQL database
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    # First, get the farm_id mapping from farmer names and farm number
    farm_id_query = """
    SELECT f.farm_id 
    FROM farm f
    JOIN farmer fr ON f.farmer_id = fr.farmer_id
    WHERE fr.first_name = %s AND fr.last_name = %s AND f.farm_number = %s
    """

    # Insert data row by row
    for index, row in df.iterrows():
        # Get farm_id based on farmer name and farm number
        cursor.execute(farm_id_query, (row['first_name'], row['last_name'], row['farm_number']))
        result = cursor.fetchone()
        
        if result:
            farm_id = result[0]
            
            # Prepare the insert query - excluding calculated columns
            insert_query = """
            INSERT INTO yield_and_revenue (
                farm_id, yield_date, season, total_yield_mt, loss_percentage,
                tonnage_sold, percentage_sold, price_per_kilo_ghs
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            # Convert date string to proper date format if needed
            yield_date = pd.to_datetime(row['yield_date']).date()
            
            # Prepare data tuple - excluding calculated columns
            data = (
                farm_id,
                yield_date,
                row['season'],
                row['total_yield_mt'],
                row['loss_percentage'],
                row['tonnage_sold'],
                row['percentage_sold'],
                row['price_per_kilo_ghs']
            )
            
            # Execute insert query
            cursor.execute(insert_query, data)
            conn.commit()
            print(f"Inserted data for farm_id: {farm_id}")
        else:
            print(f"Could not find farm_id for farmer: {row['first_name']} {row['last_name']} with farm number: {row['farm_number']}")

except Exception as e:
    print(f"An error occurred: {str(e)}")
    if 'conn' in locals():
        conn.rollback()

finally:
    if 'cursor' in locals():
        cursor.close()
    if 'conn' in locals():
        conn.close()
    print("Database connection closed.")
