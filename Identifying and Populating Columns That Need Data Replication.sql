-- Identifying farms that need data replication
WITH farmer_farm_counts AS (
    -- This CTE (Common Table Expression) identifies farmers who own multiple farms
    SELECT f.farmer_id, COUNT(DISTINCT f.farm_id) as farm_count
    FROM farm f
    GROUP BY f.farmer_id
    HAVING COUNT(DISTINCT f.farm_id) > 1  -- Only keep farmers with more than 1 farm
),
farms_with_mango_data AS (
    -- This CTE identifies which farms already have mango data recorded
    SELECT DISTINCT f.farmer_id, f.farm_id
    FROM farm f
    JOIN main_crop_data mcd ON f.farm_id = mcd.farm_id
    WHERE mcd.crop_name = 'Mango'  -- Only look at mango crops
)
-- Main query to show the status of each farm
SELECT 
    f.farmer_id,
    f.farm_id,
    f.farm_number,
    f.farm_location,
    CASE 
        WHEN mcd.farm_id IS NOT NULL THEN 'Has Data'  -- If farm has mango data
        ELSE 'Missing Data'  -- If farm is missing mango data
    END as data_status
FROM farm f
-- Join with farmers who have multiple farms
JOIN farmer_farm_counts ffc ON f.farmer_id = ffc.farmer_id
-- Left join with main_crop_data to check if mango data exists
LEFT JOIN main_crop_data mcd ON f.farm_id = mcd.farm_id AND mcd.crop_name = 'Mango'
WHERE EXISTS (
    -- Only show farms where the farmer has at least one farm with mango data
    SELECT 1 
    FROM farms_with_mango_data fmd 
    WHERE fmd.farmer_id = f.farmer_id
)
ORDER BY f.farmer_id, f.farm_id;  -- Sort by farmer and then farm for easy reading

-- Replicating the mango data
INSERT INTO main_crop_data (farmer_id, farm_id, crop_name, variety)
SELECT 
    f.farmer_id,
    f.farm_id,
    mcd.crop_name,
    mcd.variety
FROM farm f
-- Subquery to identify farmers with multiple farms
JOIN (
    SELECT DISTINCT farmer_id
    FROM farm
    GROUP BY farmer_id
    HAVING COUNT(DISTINCT farm_id) > 1  -- Only farmers with multiple farms
) multi_farm_farmers ON f.farmer_id = multi_farm_farmers.farmer_id
-- Join with existing mango data to get the crop details
JOIN main_crop_data mcd ON mcd.farmer_id = f.farmer_id AND mcd.crop_name = 'Mango'
-- Left join to check if the farm already has mango data
LEFT JOIN main_crop_data existing ON existing.farm_id = f.farm_id AND existing.crop_name = 'Mango'
WHERE existing.farm_id IS NULL;  -- Only insert for farms that don't have mango data yet