import pandas as pd
from shapely.wkt import loads
import geojson

# Load the CSV file
csv_file_path = r"file_path"  # Update with your CSV file path
df = pd.read_csv(csv_file_path)

# Assuming the CSV has columns 'geoboundary' and 'geopoint' in WKT format
features = []

for index, row in df.iterrows():
    # Check if the WKT strings are valid (not NaN)
    if isinstance(row['geo_coordinates'], str) and isinstance(row['geo_boundaries'], str):
        # Convert WKT to geometry
        geo_coordinates = loads(row['geo_coordinates'])
        geo_boundaries = loads(row['geo_boundaries'])
        
        # Create a feature for each farm
        feature = geojson.Feature(
            geometry=geojson.MultiPolygon([list(geo_boundaries.exterior.coords)]) if geo_boundaries.geom_type == 'Polygon' else geojson.Point(list(geo_coordinates.coords)),
            properties={
                'farm_id': index,  # Unique identifier for the farm
                'first_name': row['first_name'],  # Add first name from the CSV
                'last_name': row['last_name'],  # Add last name from the CSV
                'farm_number': row['farm_number'],  # Add farm number from the CSV
            }
        )
        features.append(feature)
    else:
        print(f"Skipping row {index} {row['first_name']} {row['last_name']} due to invalid geometry data.")

# Create a FeatureCollection
feature_collection = geojson.FeatureCollection(features)

# Save to GeoJSON file
geojson_file_path = r"C:\Users\CHAKU FOODS\Documents\MySQL Chaku Database Creation\farm_geojson_output.geojson"  # Update with your desired output path
with open(geojson_file_path, 'w') as f:
    geojson.dump(feature_collection, f)

print(f"GeoJSON file created at: {geojson_file_path}")
