SELECT 
	f.first_name, 
	f.last_name,
    f.nationality,
    f.farmer_image_url,
    TIMESTAMPDIFF(YEAR, f.dob, CURDATE()) AS age,
    f.marital_status,
    COALESCE(SUM(d.num_dependents), 0) AS num_dependents,
    im.farming_income_type,
    fa.farm_location,
    f.association,
    fa.farm_number,
    fa.acreage,
    m.crop_name,
    m.variety,
    fa.geo_coordinates,
    fa.geo_boundaries,
    f.global_gap_certified,
    i.relies_on_rainfall,
    i.other_irrigation_methods
FROM farmer f
JOIN main_crop_data m
	ON f.farmer_id = m.farmer_id
JOIN farm fa
	ON f.farmer_id = fa.farmer_id
JOIN irrigation i
	ON f.farmer_id = i.farmer_id
JOIN impact_assessment im
	ON f.farmer_id = im.farmer_id
LEFT JOIN dependents d
    ON f.farmer_id = d.farmer_id
WHERE farm_location = "Somanya, Eastern Region"
GROUP BY 
    f.first_name, 
    f.last_name,
    f.nationality,
    f.farmer_image_url,
    f.dob,
    f.marital_status,
    fa.farm_location,
    f.association,
    fa.farm_number,
    fa.acreage,
    m.crop_name,
    m.variety,
    fa.geo_coordinates,
    fa.geo_boundaries,
    f.global_gap_certified,
    i.relies_on_rainfall,
    i.other_irrigation_methods,
    im.farming_income_type;
