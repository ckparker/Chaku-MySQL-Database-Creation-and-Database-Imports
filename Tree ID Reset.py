import mysql.connector
from mysql.connector import Error

# MySQL connection configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '*****',
    'database': '*****'
}

try:
    # Establish MySQL connection
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    # Step 1: Drop the temporary table if it exists
    cursor.execute("DROP TABLE IF EXISTS temp_tree_data;")

    # Step 2: Create a temporary table with the same structure but without AUTO_INCREMENT
    cursor.execute("""
        CREATE TABLE temp_tree_data (
            tree_id INT NOT NULL,
            farm_id INT,
            farmer_id INT,
            tree_number INT,
            tree_geopoint POINT,
            picture_1_url VARCHAR(255),
            picture_2_url VARCHAR(255),
            picture_3_url VARCHAR(255),
            picture_4_url VARCHAR(255),
            picture_5_url VARCHAR(255),
            picture_6_url VARCHAR(255),
            picture_7_url VARCHAR(255),
            picture_8_url VARCHAR(255),
            PRIMARY KEY (tree_id)
        );
    """)

    # Step 3: Get the current data ordered by tree_id
    select_query = """
        SELECT tree_id, farm_id, farmer_id, tree_number, tree_geopoint, 
               picture_1_url, picture_2_url, picture_3_url, 
               picture_4_url, picture_5_url, picture_6_url, 
               picture_7_url, picture_8_url
        FROM tree_data
        ORDER BY tree_id
    """
    cursor.execute(select_query)
    records = cursor.fetchall()
    
    if records:
        print(f"Found {len(records)} records to reindex")
        
        # Step 4: Insert data into the temporary table with new sequential IDs
        for new_id, record in enumerate(records, start=1):
            insert_query = """
                INSERT INTO temp_tree_data (tree_id, farm_id, farmer_id, tree_number, 
                                            tree_geopoint, picture_1_url, picture_2_url, 
                                            picture_3_url, picture_4_url, picture_5_url, 
                                            picture_6_url, picture_7_url, picture_8_url)
                VALUES (%s, %s, %s, %s, ST_GeomFromText(%s), %s, %s, %s, %s, %s, %s, %s);
            """
            # Unpack the record, skipping the old tree_id (record[0])
            cursor.execute(insert_query, (new_id, *record[1:], record[4]))  # record[4] is tree_geopoint

        # Step 5: Drop the original table
        cursor.execute("DROP TABLE tree_data;")

        # Step 6: Rename the temporary table to the original table name
        cursor.execute("ALTER TABLE temp_tree_data RENAME TO tree_data;")

        # Step 7: Reset the auto_increment to start after the last used ID
        cursor.execute(f"ALTER TABLE tree_data AUTO_INCREMENT = {len(records) + 1};")

        # Commit the changes
        connection.commit()
        print("\nSuccessfully reset primary key sequence for tree_id")
        
    else:
        print("No records found in tree_data table")

except Error as e:
    print(f"Error: {e}")

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("MySQL connection closed.")