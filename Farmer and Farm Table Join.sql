-- Query to join certain columns in the farmer table with some columns in the farm table
SELECT 
	fa.last_name, 
    fa.first_name, 
    f.farm_number,
    f.farm_id,
    f.geo_coordinates,
    f.geo_boundaries,
    f.farm_location
FROM farmer fa
JOIN farm f
ON fa.farmer_id = f.farmer_id
WHERE farm_location = "Somanya, Eastern Region";