-- Table for ranger information
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);

-- Populate rangers table
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

-- Table for species data
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) 
        CHECK (conservation_status IN (
            'Endangered', 
            'Vulnerable', 
            'Critically Endangered', 
            'Near Threatened', 
            'Historic'
        ))
);

-- Insert species records
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', DATE '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', DATE '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', DATE '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', DATE '1758-01-01', 'Endangered');

-- Table for sightings log
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id) ON DELETE CASCADE,
    ranger_id INT REFERENCES rangers(ranger_id) ON DELETE CASCADE,
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Populate sightings table
INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', TIMESTAMP '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', TIMESTAMP '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', TIMESTAMP '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', TIMESTAMP '2024-05-18 18:30:00', NULL);


-- Problem 1: Add new ranger to the table
INSERT INTO rangers (name, region) 
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2: Count how many distinct species have been sighted
SELECT COUNT(DISTINCT s.species_id) AS unique_species_count 
FROM sightings s;

-- Problem 3: Find all sightings that occurred in locations containing 'Pass'
SELECT * 
FROM sightings 
WHERE location ILIKE '%Pass%';

-- Problem 4: List each ranger's name and the number of sightings they've logged
SELECT r.name, COUNT(s.sighting_id) AS sighting_total
FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.ranger_id, r.name
ORDER BY r.name;

-- Problem 5: Find species that have not yet been recorded in any sightings
SELECT sp.common_name
FROM species sp
LEFT JOIN sightings s ON sp.species_id = s.species_id
WHERE s.sighting_id IS NULL;

-- Problem 6: Retrieve the two most recent sightings, including ranger and species info
SELECT 
    sp.common_name, 
    s.sighting_time, 
    r.name AS ranger_name
FROM sightings s
JOIN species sp ON s.species_id = sp.species_id
JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7: Update conservation status to 'Historic' for species discovered before 1800
UPDATE species 
SET conservation_status = 'Historic' 
WHERE discovery_date < DATE '1800-01-01';

-- Problem 8: Classify sightings based on time of day
SELECT 
    sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period
FROM sightings;

-- Problem 9: Remove any ranger not associated with any sightings
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id 
    FROM sightings
);

-- Verify updated ranger list
SELECT * FROM rangers;
