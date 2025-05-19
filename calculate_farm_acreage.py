import mysql.connector
from shapely import wkb
import numpy as np
from pyproj import Geod

def calculate_geodesic_area(coordinates):
    """
    Calculate area using geodesic calculations from pyproj
    This provides accurate area calculations on the Earth's surface
    """
    # Create a Geod object using WGS84 ellipsoid
    geod = Geod(ellps='WGS84')
    
    # Extract coordinates
    lons = coordinates[:, 0]
    lats = coordinates[:, 1]
    
    # Check if coordinates form a closed polygon
    if not (lons[0] == lons[-1] and lats[0] == lats[-1]):
        lons = np.append(lons, lons[0])
        lats = np.append(lats, lats[0])
    
    # Calculate area in square meters
    area_m2, _ = geod.polygon_area_perimeter(lons, lats)
    
    # Return absolute value (area can be negative depending on coordinate order)
    return abs(area_m2)

def validate_polygon(coordinates):
    """
    Validate polygon coordinates
    """
    # Check if we have enough points (at least 3 for a polygon)
    if len(coordinates) < 3:
        return False, "Polygon has less than 3 points"
    
    # Check if the polygon is closed
    is_closed = np.allclose(coordinates[0], coordinates[-1])
    
    return is_closed, None

def update_acreage_values():
    # Database connection
    db = mysql.connector.connect(
        host="chakutech.com",
        user="ckparker_dba",
        password="KpakpoParker700!",
        database="chaku_foods"
    )
    cursor = db.cursor()

    try:
        # Fetch all farms with geo_boundaries
        cursor.execute("""
            SELECT f.farm_id, 
                   CONCAT(fr.first_name, ' ', fr.last_name) as farmer_name,
                   ST_AsWKB(f.geo_boundaries) as geo_boundaries
            FROM farm f
            JOIN farmer fr ON f.farmer_id = fr.farmer_id
            WHERE f.geo_boundaries IS NOT NULL
        """)
        
        farms = cursor.fetchall()
        
        for farm_id, farmer_name, wkb_data in farms:
            try:
                # Convert WKB to shapely polygon
                polygon = wkb.loads(wkb_data)
                
                # Get coordinates
                coords = np.array(polygon.exterior.coords)
                
                # Validate polygon
                is_valid, error_msg = validate_polygon(coords)
                if not is_valid:
                    print(f"Warning: Farm {farm_id} ({farmer_name}) has invalid polygon: {error_msg}")
                    continue
                
                # Calculate area in square meters using geodesic calculations
                area_m2 = calculate_geodesic_area(coords)
                
                # Convert to acres (1 acre = 4046.86 square meters)
                calculated_acreage = float(area_m2 / 4046.86)
                
                # Update the farm table
                update_query = "UPDATE farm SET acreage = %s WHERE farm_id = %s"
                cursor.execute(update_query, (calculated_acreage, farm_id))
                
                print(f"Updated farm {farm_id} ({farmer_name}): {calculated_acreage:.2f} acres")
                
            except Exception as e:
                print(f"Error processing farm {farm_id} ({farmer_name}): {str(e)}")
        
        # Commit changes
        db.commit()
        print("\nAll updates completed successfully!")
        
    finally:
        cursor.close()
        db.close()

if __name__ == "__main__":
    update_acreage_values() 