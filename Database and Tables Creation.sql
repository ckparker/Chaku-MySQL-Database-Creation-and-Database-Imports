USE chaku_foods;

-- Create the Farmers Table
CREATE TABLE farmer (
    farmer_id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    sex CHAR(1),
    dob DATE,
    id_type VARCHAR(50),
    id_number VARCHAR(100),
    id_doc_number VARCHAR(50),
    id_image_url VARCHAR(255),
    farmer_image_url VARCHAR(255),
    marital_status ENUM('Single', 'Married', 'Divorced', 'Widowed'),
    contact_number VARCHAR(20),
    mobile_money_number VARCHAR(20),
    is_mobile_money_same BOOLEAN DEFAULT TRUE,
    association VARCHAR(100),
    location VARCHAR(100),
    global_gap_certified ENUM('Yes','No, but interested and qualified','No and not interested'),
    usda_organic_certified ENUM('Yes','No, but interested and qualified','No and not interested')
);  

/**
ALTER TABLE farmer
ADD COLUMN farmer_image VARCHAR(255);

ALTER TABLE farmer
MODIFY COLUMN farmer_image VARCHAR(255) AFTER id_image_url;

ALTER TABLE farmer
MODIFY COLUMN first_name VARCHAR(100) NOT NULL AFTER last_name;

ALTER TABLE farmer
ADD COLUMN id_doc_number VARCHAR(50);

ALTER TABLE farmer
MODIFY COLUMN id_doc_number VARCHAR(100) AFTER id_number;

ALTER TABLE farmer
ADD COLUMN association VARCHAR(100);

ALTER TABLE farmer
MODIFY COLUMN association VARCHAR(100) AFTER is_mobile_money_same;

ALTER TABLE farmer
MODIFY COLUMN marital_status ENUM('Single', 'Married', 'Divorced', 'Widowed') AFTER id_image_url;

ALTER TABLE farmer
MODIFY COLUMN global_gap_certified ENUM('Yes','No, but interested and qualified','No and not interested');

ALTER TABLE farmer
MODIFY COLUMN usda_organic_certified ENUM('Yes','No, but interested and qualified','No and not interested');
**/

-- Create the Farms Table
CREATE TABLE farm (
    farm_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    farm_number VARCHAR(10),
    farm_location VARCHAR(100),
    acreage DECIMAL(10,2),
    geo_coordinates POINT,
    geo_boundaries POLYGON,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    road_accessibility ENUM('accessible', 'difficult', 'not accessible'),
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

-- Create the intercropping data Table
CREATE TABLE intercropping_data (
    crop_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    intercropped_crops TEXT, -- List of intercrops (e.g., 'Okra, Cocoa')
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);


-- Create the Dependents Table
CREATE TABLE dependents (
    dependent_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    age_range VARCHAR(20), -- e.g., '0-5', '6-10', etc.
    num_dependents INT,
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

-- Create the Farm Inputs Table
CREATE TABLE farm_inputs (
    input_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    input_type VARCHAR(50), -- e.g., Fertilizer, Pesticide, etc.
    details VARCHAR(255),
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

-- Create the Impact Assessment Table
CREATE TABLE impact_assessment (
    assessment_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    disability ENUM("Yes","No"),
    farming_income_type ENUM('Primary', 'Secondary'), -- Primary or Secondary
    primary_income_source VARCHAR(255), -- Shows primary income source if farming is secondary
    post_harvest_loss_percent INT, -- Percentage of post-harvest losses incurred
    relies_on_rainfall ENUM("Yes","No"),
    other_irrigation_methods TEXT,
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
); 

/** ALTER TABLE impact_assessment
ADD primary_income_source VARCHAR(255); 

ALTER TABLE impact_assessment
MODIFY COLUMN primary_income_source VARCHAR(255) AFTER farming_income_type;

ALTER TABLE impact_assessment
DROP COLUMN collected_or_harvested;

ALTER TABLE impact_assessment
ADD COLUMN disability BOOLEAN DEFAULT FALSE;

ALTER TABLE impact_assessment
MODIFY COLUMN disability BOOLEAN DEFAULT FALSE AFTER farm_id;

ALTER TABLE impact_assessment
MODIFY COLUMN crops_cultivated TEXT AFTER primary_income_source;

ALTER TABLE impact_assessment
MODIFY COLUMN uneaten_scale INT AFTER crops_cultivated; **/


-- Create the Main Crop Data Table
CREATE TABLE main_crop_data (
    crop_data_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    farm_id INT,
    crop_name VARCHAR(50),
    variety VARCHAR(100),
    initial_planting_year YEAR,
    tree_spacing VARCHAR(50),
    tree_flower_percentage INT,
    flowering_image_url VARCHAR(255),
    predicted_harvest_time VARCHAR(255),
    FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE,
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

/** RENAME TABLE crop_data TO main_crop_data; **/

/** ALTER TABLE main_crop_data
DROP COLUMN fruit_set_percentage; **/

/**
ALTER TABLE main_crop_data
ADD COLUMN variety VARCHAR(100);

ALTER TABLE main_crop_data
ADD COLUMN initial_planting_year YEAR;

ALTER TABLE main_crop_data
ADD COLUMN tree_spacing VARCHAR(50);

ALTER TABLE main_crop_data
ADD COLUMN fruit_flower_count INT;

ALTER TABLE main_crop_data
RENAME COLUMN fruit_flower_count TO tree_flower_count;
**/
/**
ALTER TABLE main_crop_data
MODIFY COLUMN  predicted_harvest_time VARCHAR(255) AFTER tree_flower_count;

ALTER TABLE main_crop_data
MODIFY COLUMN variety VARCHAR(100) AFTER crop_name;
**/


-- Create the Harvesting Table
CREATE TABLE harvesting (
    harvesting_id INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id INT,
    collected_or_harvested ENUM("Yes","No"),
    harvesting_process VARCHAR(100), -- e.g., 'Hand-picking', 'Bamboo'
    harvest_responsibility VARCHAR(100), -- Farmer, Labourers, etc.
    labourers_count INT,
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

/** ALTER TABLE harvesting
ADD COLUMN collected_or_harvested BOOLEAN;

ALTER TABLE harvesting
RENAME COLUMN collection_process TO harvesting_process;

ALTER TABLE harvesting
MODIFY COLUMN collected_or_harvested BOOLEAN AFTER farm_id;

ALTER TABLE harvesting
MODIFY COLUMN harvest_responsibility VARCHAR(100) AFTER harvesting_process; **/

-- Create the Tree Table
CREATE TABLE tree_data (
	tree_id INT AUTO_INCREMENT PRIMARY KEY,
	farm_id INT,
	picture_date DATE,
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
	fruit_count INT, 
	FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE 
); 

/**
ALTER TABLE tree_data
ADD CONSTRAINT fk_farmer_in_tree_data
FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id);
**/

/**
SET SQL_SAFE_UPDATES = 0;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE tree_data; **/ 

/** This part was to add the ON DELETE CASCADE constraint
That way, when a record is deleted from the parent table, it is automatically deleted from all other tables as well

SELECT TABLE_NAME, CONSTRAINT_NAME -- This block checks the actual constraint name for each table
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_NAME = "tree_data" AND COLUMN_NAME = "farmer_id";

ALTER TABLE tree_data -- This block removes the foreign key constraint using the actual constraint name
DROP FOREIGN KEY tree_data_ibfk_1;

ALTER TABLE tree_data -- This block adds the new constraint. Remember that every constraint name must be unique!
ADD CONSTRAINT td_farmer_id FOREIGN KEY (farmer_id)
REFERENCES farmer(farmer_id) ON DELETE CASCADE;
**/


# This code helps you find delete rules for each of your tables based on their constraints
SELECT TABLE_NAME, CONSTRAINT_NAME, DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'chaku_foods';


/**
SELECT * 
FROM farmer 
WHERE farmer_id NOT IN (SELECT farmer_id FROM main_crop_data);
**/

CREATE TABLE yield_and_revenue (
	yield_id INT AUTO_INCREMENT PRIMARY KEY,
	farm_id INT,
	yield_date DATE,
	season ENUM ("Major","Minor"),
    initial_yield_mt DECIMAL(10,2),
    loss_percentage DECIMAL(10,2),
	total_yield_mt DECIMAL(10,2),
	tonnage_sold DECIMAL(10,2),
	percentage_sold DECIMAL(10,2),
	total_production_cost_ghs DECIMAL(10,2),
    price_per_kilo_ghs INT,
	revenue_from_sales_ghs DECIMAL(10,2),
	income_lost_ghs DECIMAL(10,2),
    FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE
);

# Creating a before insert trigger for total production cost (ghs) calculation
DELIMITER $$

CREATE TRIGGER production_cost 
BEFORE INSERT ON yield_and_revenue
FOR EACH ROW
BEGIN
    DECLARE farm_acreage INT;
    
    -- Fetch the acreage value from the farm table
    SELECT acreage INTO farm_acreage FROM farm WHERE farm_id = NEW.farm_id;

    -- Calculate total production cost using the fetched acreage value
    SET NEW.total_production_cost_ghs = farm_acreage * 16000;
END $$

DELIMITER ;

# This trigger works when acreage is updated
DELIMITER $$

CREATE TRIGGER after_update_farm_acreage
AFTER UPDATE ON farm
FOR EACH ROW
BEGIN
    -- Update total production cost in yield_and_revenue when acreage changes in farm
    UPDATE yield_and_revenue 
    SET total_production_cost_ghs = NEW.acreage * 16000
    WHERE farm_id = NEW.farm_id;
END $$

DELIMITER ;

# Creating a before insert trigger for revenue from tonnage sold (ghs) calculation
DELIMITER $$

CREATE TRIGGER sales_revenue 
BEFORE INSERT ON yield_and_revenue
FOR EACH ROW
BEGIN
	SET NEW.revenue_from_sales_ghs = (NEW.tonnage_sold*1000)*NEW.price_per_kilo_ghs;
END $$

DELIMITER ;

# Creating a before update trigger for for revenue from tonnage sold (ghs) calculation
DELIMITER $$

CREATE TRIGGER before_update_sales_revenue 
BEFORE UPDATE ON yield_and_revenue
FOR EACH ROW
BEGIN
	SET NEW.revenue_from_sales_ghs = (NEW.tonnage_sold*1000)*NEW.price_per_kilo_ghs;
END $$

DELIMITER ;

# Creating a before insert trigger for income lost (ghs) calculation
DELIMITER $$

CREATE TRIGGER income_lost 
BEFORE INSERT ON yield_and_revenue
FOR EACH ROW
BEGIN
    SET NEW.income_lost_ghs = (((NEW.loss_percentage / 100) * NEW.total_yield_mt) + ((NEW.total_yield_mt - NEW.tonnage_sold))) * 1000 * NEW.price_per_kilo_ghs;
END $$

DELIMITER ;

# Creating a before update trigger for income lost (ghs) calculation
DELIMITER $$

CREATE TRIGGER before_update_income_lost 
BEFORE UPDATE ON yield_and_revenue
FOR EACH ROW
BEGIN
    SET NEW.income_lost_ghs = (((NEW.loss_percentage / 100) * NEW.total_yield_mt) + ((NEW.total_yield_mt - NEW.tonnage_sold))) * 1000 * NEW.price_per_kilo_ghs;
END $$

DELIMITER ;

# Creating a before insert trigger for total yield (MT) calculation
DELIMITER $$

CREATE TRIGGER final_yield
BEFORE INSERT ON yield_and_revenue
FOR EACH ROW
BEGIN
	SET NEW.total_yield_mt = NEW.total_yield_mt/((100 - NEW.loss_percentage)/100);
END $$

DELIMITER ;

# Creating a before update trigger for total yield (MT) calculation
DELIMITER $$

CREATE TRIGGER before_update_final_yield
BEFORE UPDATE ON yield_and_revenue
FOR EACH ROW
BEGIN
	SET NEW.total_yield_mt = NEW.total_yield_mt/((100 - NEW.loss_percentage)/100);
END $$

DELIMITER ;

DROP TRIGGER IF EXISTS production_cost;

-- Create yield predictions table
CREATE TABLE yield_predictions (
    prediction_id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    harvest_date DATE,
    predicted_yield_mt DECIMAL(10,2),
    actual_yield_mt DECIMAL(10,2),
    season ENUM('Major','Minor'),
    -- Metadata
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Foreign keys
    FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE,
    -- Index
    INDEX idx_harvest_date (farm_id, harvest_date)
);

/** add confidence level for user-friendly interpretation of results
ALTER TABLE yield_predictions
ADD COLUMN confidence_level VARCHAR(20) 
GENERATED ALWAYS AS (
    CASE 
        WHEN prediction_confidence >= 80 THEN 'High'
        WHEN prediction_confidence >= 65 THEN 'Medium'
        ELSE 'Low'
    END
) STORED;
**/

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'partner', 'user') NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_last_login (last_login),
    INDEX idx_username_active (username, is_active),
    INDEX idx_email_active (email, is_active)
);

-- New table for projects
CREATE TABLE project (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(255),
    crop_name VARCHAR(100),
    product_type VARCHAR(50),  -- (Fresh, Flour, Dried, Chips)
    quantity_required DECIMAL(10,2),  -- in metric tons
    quantity_unit VARCHAR(20),  -- (Metric Tons, Kilogrammes, Litres, Pounds)
    harvest_time_start DATE,
    harvest_time_end DATE,
    created_by INT NOT NULL,  -- User who created the project
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',  -- (active, completed, cancelled)
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- New table for project-farm assignments
CREATE TABLE project_farm_assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    farm_id INT,
    farmer_id INT,
    contribution_amount DECIMAL(10,2),  -- in metric tons
    contribution_percentage DECIMAL(5,2),
    estimated_revenue DECIMAL(12,2),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'assigned',  -- (assigned, fulfilled, cancelled)
    FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE,
    FOREIGN KEY (farmer_id) REFERENCES farmer(farmer_id) ON DELETE CASCADE
);

-- Project tracking table
CREATE TABLE project_tracking (
    tracking_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    farm_id INT,
    actual_contribution DECIMAL(10,2),
    delivery_date DATE,
    quality_grade VARCHAR(20),
    notes TEXT,
    FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (farm_id) REFERENCES farm(farm_id) ON DELETE CASCADE
);

