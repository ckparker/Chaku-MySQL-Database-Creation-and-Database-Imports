SELECT 
	f.first_name,
    f.last_name,
    fa.farm_number,
    fa.farm_id,
    t.tree_number,
    t.picture_1_url,
    t.picture_2_url,
    t.picture_3_url,
    t.picture_4_url,
    t.picture_5_url,
    t.picture_6_url,
    t.picture_7_url,
    t.picture_8_url
FROM farmer f
JOIN farm fa
	ON f.farmer_id = fa.farmer_id
JOIN tree_data t
	ON fa.farm_id = t.farm_id
WHERE CONCAT_WS('|',
    IFNULL(CAST(picture_1_url AS CHAR), ''),
    IFNULL(CAST(picture_2_url AS CHAR), ''),
    IFNULL(CAST(picture_3_url AS CHAR), ''),
    IFNULL(CAST(picture_4_url AS CHAR), ''),
    IFNULL(CAST(picture_5_url AS CHAR), ''),
    IFNULL(CAST(picture_6_url AS CHAR), ''),
    IFNULL(CAST(picture_7_url AS CHAR), ''),
    IFNULL(CAST(picture_8_url AS CHAR), '')
    -- add additional columns as needed
) LIKE '%1730908045197%';