SELECT * FROM chaku_foods.farmer;

SELECT fr.*, d.num_dependents, COUNT(fa.farm_number) AS num_farms
FROM farmer fr
JOIN (
    SELECT farmer_id, COUNT(*) AS num_dependents
    FROM dependents
    GROUP BY farmer_id
) d ON fr.farmer_id = d.farmer_id
JOIN farm fa ON fr.farmer_id = fa.farmer_id
WHERE fr.last_name = "Asante" AND fr.first_name = "Joyce"
GROUP BY fr.farmer_id, d.num_dependents;

# Columns to add
/** induction_date and date of flowering picture - main crop data table
**/

