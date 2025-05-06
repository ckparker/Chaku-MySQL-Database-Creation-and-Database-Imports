import pandas as pd
import mysql.connector
from mysql.connector import Error
import numpy as np

# Database connection parameters
DB_CONFIG = {
    'host': 'chakutech.com',
    'user': 'ckparker_dba',
    'password': 'KpakpoParker700!',  # Replace with your MySQL password
    'database': 'chaku_foods'
}

def clear_picture_urls(cursor):
    """Clear all picture URLs in the tree_data table"""
    try:
        print("Clearing existing picture URLs...")
        clear_query = """
            UPDATE tree_data 
            SET 
                picture_1_url = NULL,
                picture_2_url = NULL,
                picture_3_url = NULL,
                picture_4_url = NULL,
                picture_5_url = NULL,
                picture_6_url = NULL,
                picture_7_url = NULL,
                picture_8_url = NULL
        """
        cursor.execute(clear_query)
        print("Successfully cleared existing picture URLs")
    except Error as e:
        print(f"Error clearing picture URLs: {e}")
        raise

def clean_value(val):
    """Convert pandas NaN or empty string to None for MySQL"""
    if pd.isna(val) or val == '' or val == 'nan':
        return None
    return val

def update_tree_pictures(excel_file_path):
    try:
        # Read Excel file
        print("Reading Excel file...")
        df = pd.read_excel(excel_file_path)
        
        # Replace empty strings and NaN with None
        for col in df.columns:
            if col.startswith('picture_'):
                df[col] = df[col].apply(clean_value)
        
        # Establish database connection
        print("Connecting to database...")
        connection = mysql.connector.connect(**DB_CONFIG)
        cursor = connection.cursor(dictionary=True)
        
        # Clear existing picture URLs
        clear_picture_urls(cursor)
        
        # Process each row in the Excel file
        print("Processing Excel data...")
        for index, row in df.iterrows():
            try:
                # Get farmer_id based on first_name and last_name
                cursor.execute("""
                    SELECT farmer_id 
                    FROM farmer 
                    WHERE first_name = %s AND last_name = %s
                """, (row['first_name'], row['last_name']))
                
                farmer_result = cursor.fetchone()
                if not farmer_result:
                    print(f"Farmer not found: {row['first_name']} {row['last_name']}")
                    continue
                
                farmer_id = farmer_result['farmer_id']
                
                # Get farm_id based on farm_number and farmer_id
                cursor.execute("""
                    SELECT farm_id 
                    FROM farm 
                    WHERE farm_number = %s AND farmer_id = %s
                """, (row['farm_number'], farmer_id))
                
                farm_result = cursor.fetchone()
                if not farm_result:
                    print(f"Farm not found for farmer {row['first_name']} {row['last_name']}, farm number {row['farm_number']}")
                    continue
                
                farm_id = farm_result['farm_id']
                
                # Update tree_data table with picture URLs
                update_query = """
                    UPDATE tree_data 
                    SET 
                        picture_1_url = %s,
                        picture_2_url = %s,
                        picture_3_url = %s,
                        picture_4_url = %s,
                        picture_5_url = %s,
                        picture_6_url = %s,
                        picture_7_url = %s,
                        picture_8_url = %s
                    WHERE farm_id = %s
                """
                
                update_values = (
                    clean_value(row.get('picture_1_url')),
                    clean_value(row.get('picture_2_url')),
                    clean_value(row.get('picture_3_url')),
                    clean_value(row.get('picture_4_url')),
                    clean_value(row.get('picture_5_url')),
                    clean_value(row.get('picture_6_url')),
                    clean_value(row.get('picture_7_url')),
                    clean_value(row.get('picture_8_url')),
                    farm_id
                )
                
                cursor.execute(update_query, update_values)
                print(f"Updated pictures for {row['first_name']} {row['last_name']}, farm number {row['farm_number']}")
                
            except Error as e:
                print(f"Error processing row {index}: {e}")
                continue
        
        # Commit changes
        connection.commit()
        print("\nAll updates completed successfully!")
        
    except Error as e:
        print(f"Database error: {e}")
        
    except Exception as e:
        print(f"Error: {e}")
        
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            print("Database connection closed.")

if __name__ == "__main__":
    # Replace with your Excel file path
    excel_file = r"C:\Users\CHAKU FOODS\Documents\Final Tree Photo Taking Cleaning\Tree Data.xlsx"
    update_tree_pictures(excel_file) 