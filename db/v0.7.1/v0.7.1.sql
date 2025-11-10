-- ensure observed habitat species codes match the values present in the BC species code table
-- (ie, capitalized)

UPDATE bcfishpass.user_habitat_classification 
SET species_code = UPPER(species_code);

-- apply this with bcfishobs patch
-- ALTER TABLE whse_fish.species_cd
-- ADD CONSTRAINT uq_species_code UNIQUE (code);

ALTER TABLE bcfishpass.user_habitat_classification
ADD CONSTRAINT fk_species_code
FOREIGN KEY (species_code)
REFERENCES whse_fish.species_cd(code);