-- ============================================================
-- FloraHeal - PostgreSQL Database Schema
-- Date: February 2022
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. CREATE DATABASE (run this separately as postgres superuser)
-- ────────────────────────────────────────────────────────────
-- CREATE DATABASE floraheal;
-- \c FloraHeal

-- ────────────────────────────────────────────────────────────
-- 2. ENABLE EXTENSIONS
-- ────────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ────────────────────────────────────────────────────────────
-- 3. DROP EXISTING TABLES (for clean re-runs)
-- ────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS plant_diseases CASCADE;
DROP TABLE IF EXISTS plant_info CASCADE;
DROP TABLE IF EXISTS diseases CASCADE;
DROP TABLE IF EXISTS plants CASCADE;

-- ────────────────────────────────────────────────────────────
-- 4. CREATE TABLES
-- ────────────────────────────────────────────────────────────

-- 4a. Plants Table
CREATE TABLE plants (
    id              SERIAL PRIMARY KEY,
    common_name     VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL,
    family          VARCHAR(100),
    plant_type      VARCHAR(50),          -- vegetable, fruit, flower, herb, tree, etc.
    growing_season  VARCHAR(100),
    description     TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4b. Diseases Table
CREATE TABLE diseases (
    id                   SERIAL PRIMARY KEY,
    name                 VARCHAR(255) NOT NULL,
    causal_agent         VARCHAR(255),
    disease_type         VARCHAR(50),       -- fungal, bacterial, viral, nematode, etc.
    description          TEXT,
    symptoms             TEXT,
    favorable_conditions TEXT,
    lifecycle            TEXT,
    prevention           TEXT,
    severity             VARCHAR(20),       -- low, moderate, high, critical
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4c. Plant-Disease Junction Table (many-to-many)
CREATE TABLE plant_diseases (
    id          SERIAL PRIMARY KEY,
    plant_id    INTEGER NOT NULL REFERENCES plants(id) ON DELETE CASCADE,
    disease_id  INTEGER NOT NULL REFERENCES diseases(id) ON DELETE CASCADE,
    notes       TEXT,
    UNIQUE(plant_id, disease_id)
);

-- 4d. Plant Info Table (extended plant details)
CREATE TABLE plant_info (
    id               SERIAL PRIMARY KEY,
    plant_id         INTEGER NOT NULL REFERENCES plants(id) ON DELETE CASCADE UNIQUE,
    soil_type        VARCHAR(100),
    sunlight         VARCHAR(100),
    watering         VARCHAR(100),
    hardiness_zone   VARCHAR(50),
    companion_plants TEXT,
    common_pests     TEXT
);

-- ────────────────────────────────────────────────────────────
-- 5. CREATE INDEXES (Trigram + Performance)
-- ────────────────────────────────────────────────────────────

-- Trigram GIN indexes for fuzzy search on plant names
CREATE INDEX idx_plants_common_name_trgm
    ON plants USING GIN (common_name gin_trgm_ops);

CREATE INDEX idx_plants_scientific_name_trgm
    ON plants USING GIN (scientific_name gin_trgm_ops);

-- Standard indexes for foreign key lookups
CREATE INDEX idx_plant_diseases_plant_id
    ON plant_diseases(plant_id);

CREATE INDEX idx_plant_diseases_disease_id
    ON plant_diseases(disease_id);

CREATE INDEX idx_plant_info_plant_id
    ON plant_info(plant_id);

-- Index on disease name for filtering/sorting
CREATE INDEX idx_diseases_name
    ON diseases(name);

-- ────────────────────────────────────────────────────────────
-- 6. SAMPLE SEED DATA
-- ────────────────────────────────────────────────────────────

-- 6a. Plants
INSERT INTO plants (common_name, scientific_name, family, plant_type, growing_season, description) VALUES
('Tomato',      'Solanum lycopersicum',     'Solanaceae',    'vegetable', 'Spring - Summer',  'A widely cultivated warm-season crop grown for its edible fruit. Requires full sun, warm soil, and consistent watering.'),
('Rose',        'Rosa spp.',                'Rosaceae',      'flower',    'Spring - Fall',    'A woody perennial flowering plant prized for its beauty and fragrance. Available in thousands of cultivars.'),
('Potato',      'Solanum tuberosum',        'Solanaceae',    'vegetable', 'Spring - Summer',  'A starchy tuberous crop and one of the most important food crops worldwide. Grows best in cool climates.'),
('Cucumber',    'Cucumis sativus',          'Cucurbitaceae', 'vegetable', 'Summer',           'A warm-season vine crop in the gourd family. Produces long green fruit used fresh in salads or pickled.'),
('Apple',       'Malus domestica',          'Rosaceae',      'fruit',     'Spring (bloom)',   'A deciduous fruit tree widely cultivated around the world. Requires winter chill hours and cross-pollination.'),
('Basil',       'Ocimum basilicum',         'Lamiaceae',     'herb',      'Summer',           'An aromatic annual herb used extensively in cooking. Thrives in warm weather with plenty of sunlight.'),
('Strawberry',  'Fragaria × ananassa',      'Rosaceae',      'fruit',     'Spring - Summer',  'A low-growing perennial fruit plant. Produces sweet red berries and spreads via runners.'),
('Corn',        'Zea mays',                 'Poaceae',       'vegetable', 'Summer',           'A tall annual cereal grain. One of the most widely grown crops globally, used for food, feed, and fuel.'),
('Grape',       'Vitis vinifera',           'Vitaceae',      'fruit',     'Spring - Fall',    'A woody vine cultivated for its fruit used in winemaking, eating fresh, and drying into raisins.'),
('Pepper',      'Capsicum annuum',          'Solanaceae',    'vegetable', 'Summer',           'A warm-season crop producing fruit ranging from sweet bell peppers to hot chili varieties.');

-- 6b. Diseases
INSERT INTO diseases (name, causal_agent, disease_type, description, symptoms, favorable_conditions, lifecycle, prevention, severity) VALUES
(
    'Early Blight',
    'Alternaria solani',
    'fungal',
    'A common fungal disease affecting tomatoes and potatoes. Causes significant leaf damage and can reduce yields.',
    'Dark brown to black concentric rings (target-shaped lesions) on lower, older leaves. Lesions may appear on stems and fruit. Severe infections cause defoliation.',
    'Warm temperatures (75-85°F / 24-29°C), high humidity, prolonged leaf wetness, and overhead irrigation.',
    'The fungus overwinters in infected plant debris and soil. Spores spread by wind, rain splash, and irrigation. Infection begins on older lower leaves and progresses upward.',
    'Use certified disease-free seed. Practice crop rotation (3-year cycle). Remove and destroy infected plant debris. Mulch to prevent soil splash. Ensure adequate plant spacing for air circulation. Apply preventive fungicide sprays if necessary.',
    'high'
),
(
    'Late Blight',
    'Phytophthora infestans',
    'fungal',
    'A devastating oomycete disease of tomatoes and potatoes. Historically responsible for the Irish Potato Famine.',
    'Water-soaked, gray-green lesions on leaves that rapidly turn brown and necrotic. White fuzzy growth on leaf undersides in humid conditions. Firm, brown rot on fruit and tubers.',
    'Cool temperatures (50-70°F / 10-21°C), high humidity (above 90%), and wet foliage.',
    'The pathogen produces sporangia that are dispersed by wind and rain. It can spread rapidly under favorable conditions, devastating entire fields in days. Overwinters in infected tubers and volunteer plants.',
    'Plant resistant varieties. Eliminate volunteer plants and cull piles. Avoid overhead irrigation. Apply protective fungicides before conditions become favorable. Destroy infected plants immediately.',
    'critical'
),
(
    'Powdery Mildew',
    'Various species (Erysiphales order)',
    'fungal',
    'One of the most widespread plant diseases. Appears as white powdery patches on leaves, stems, and sometimes flowers or fruit.',
    'White to gray powdery coating on leaf surfaces, stems, and buds. Leaves may curl, yellow, and drop prematurely. Stunted growth in severe cases.',
    'Moderate temperatures (60-80°F / 15-27°C), high humidity around plants but dry leaf surfaces. Shady conditions and poor air circulation.',
    'The fungus produces chains of spores (conidia) on the plant surface. Spores are wind-dispersed and do not require free water for germination. The fungus feeds on living plant tissue as an obligate parasite.',
    'Improve air circulation through proper spacing and pruning. Avoid excess nitrogen fertilization. Plant resistant varieties. Apply sulfur-based or potassium bicarbonate sprays preventively.',
    'moderate'
),
(
    'Black Spot',
    'Diplocarpon rosae',
    'fungal',
    'The most serious disease of garden roses worldwide. Causes premature defoliation and weakens plants over successive seasons.',
    'Circular black spots with fringed margins on upper leaf surfaces. Yellow halos around spots. Progressive yellowing and premature leaf drop, starting from lower leaves.',
    'Warm temperatures (75°F / 24°C), prolonged leaf wetness (at least 7 hours), high humidity, and frequent rain.',
    'The fungus overwinters on fallen leaves and infected canes. Spores are spread primarily by splashing water. New infections require extended periods of leaf wetness.',
    'Remove and dispose of fallen leaves promptly. Prune to improve air circulation. Water at the base of plants to keep foliage dry. Choose resistant rose cultivars. Apply fungicide sprays on a preventive schedule during the growing season.',
    'high'
),
(
    'Downy Mildew',
    'Various species (Peronosporaceae family)',
    'fungal',
    'A group of oomycete diseases that affect a wide range of plants including cucurbits, grapes, and lettuce.',
    'Yellow to pale green angular lesions on upper leaf surfaces, bounded by veins. Grayish-purple fuzzy growth on leaf undersides. Leaves may curl, brown, and die.',
    'Cool to moderate temperatures (58-72°F / 14-22°C), very high humidity, and prolonged leaf wetness from dew, rain, or overhead irrigation.',
    'Sporangia are produced on the underside of leaves and dispersed by wind over long distances. The pathogen requires free water on leaf surfaces for infection. It can survive between seasons in infected plant debris.',
    'Plant resistant varieties when available. Ensure good air circulation through proper plant spacing. Avoid overhead watering. Remove infected leaves and debris promptly. Apply preventive fungicide sprays in susceptible crops.',
    'high'
),
(
    'Bacterial Wilt',
    'Ralstonia solanacearum',
    'bacterial',
    'A severe soil-borne bacterial disease affecting over 200 plant species, especially solanaceous crops.',
    'Rapid wilting of one or more branches without yellowing. Entire plant can wilt and collapse within days. Cut stems placed in water release milky bacterial streaming.',
    'Warm soil temperatures (above 77°F / 25°C), high soil moisture, and poorly drained soils.',
    'The bacterium enters through root wounds and colonizes the xylem vessels, blocking water transport. It survives in soil for extended periods and spreads via contaminated soil, water, and equipment.',
    'Use resistant varieties. Practice long crop rotations (5+ years). Improve soil drainage. Sanitize tools and equipment. Remove and destroy infected plants immediately. Avoid working in fields when soil is wet.',
    'critical'
),
(
    'Fusarium Wilt',
    'Fusarium oxysporum',
    'fungal',
    'A soil-borne fungal disease that attacks a wide range of crops through the root system.',
    'Yellowing and wilting of leaves on one side of the plant. Brown discoloration of vascular tissue visible when stems are cut. Progressive wilting and plant death.',
    'Warm soil temperatures (75-85°F / 24-29°C), acidic soils (pH below 6.5), and sandy or poorly drained soils.',
    'The fungus produces long-lived chlamydospores that persist in soil for years. It enters through roots and colonizes xylem tissue. Spread occurs through contaminated soil, water, and transplants.',
    'Plant resistant varieties (most effective control). Raise soil pH above 6.5 with lime. Practice crop rotation. Use disease-free transplants. Solarize soil in warm climates.',
    'high'
),
(
    'Mosaic Virus',
    'Various species (e.g., TMV, CMV)',
    'viral',
    'A group of viral diseases causing characteristic mottled patterns on leaves. Affects many vegetables and ornamentals.',
    'Light and dark green mottled or mosaic patterns on leaves. Leaf curling, distortion, and reduced leaf size. Stunted plant growth and reduced fruit yield and quality.',
    'Transmitted mechanically through handling, by aphid vectors, and through infected seed. No specific environmental conditions trigger the disease but aphid activity increases spread.',
    'Viruses replicate inside plant cells and spread systemically. They are transmitted by contact (contaminated hands and tools), by insect vectors (aphids), and sometimes through seed. There is no cure once a plant is infected.',
    'Use certified virus-free seed and transplants. Control aphid vectors. Wash hands and sanitize tools between plants. Remove and destroy infected plants. Plant resistant varieties when available.',
    'moderate'
),
(
    'Fire Blight',
    'Erwinia amylovora',
    'bacterial',
    'A destructive bacterial disease primarily affecting apple and pear trees. Can kill branches and entire trees.',
    'Blossoms turn brown and water-soaked, then wilt and die. Shoots bend into a characteristic shepherd''s crook shape. Dark, sunken cankers form on branches with bacterial ooze.',
    'Warm temperatures (75-85°F / 24-29°C) during bloom, accompanied by rain or high humidity.',
    'Bacteria overwinter in cankers on branches. In spring, ooze containing bacteria is spread by rain, insects (especially bees), and wind to open blossoms. Infection moves rapidly through the tree.',
    'Prune out infected branches at least 12 inches below visible symptoms during dry weather. Sterilize pruning tools between cuts. Avoid heavy nitrogen fertilization. Apply copper or streptomycin sprays during bloom in high-risk years.',
    'critical'
),
(
    'Anthracnose',
    'Various Colletotrichum species',
    'fungal',
    'A common fungal disease causing dark, sunken lesions on leaves, stems, flowers, and fruit of many plant species.',
    'Dark, sunken, water-soaked lesions on leaves, stems, and fruit. Lesions may have pinkish spore masses in moist conditions. Leaf spots may cause holes (shot-hole effect) and premature defoliation.',
    'Warm temperatures (75-85°F / 24-29°C), high humidity, frequent rainfall, and prolonged leaf wetness.',
    'The fungus overwinters in infected plant debris and seeds. Conidia (spores) are spread by rain splash and overhead irrigation. The pathogen requires moisture for spore germination and infection.',
    'Remove and destroy infected plant debris. Practice crop rotation. Avoid overhead irrigation. Ensure good air circulation. Use disease-free seeds and resistant varieties. Apply fungicide sprays preventively in wet seasons.',
    'moderate'
);

-- 6c. Plant-Disease Relationships
INSERT INTO plant_diseases (plant_id, disease_id, notes) VALUES
-- Tomato diseases
(1, 1, 'Very common in tomatoes. Monitor lower leaves closely during warm, humid weather.'),
(1, 2, 'Can devastate tomato crops rapidly. Immediate action required if detected.'),
(1, 3, 'Typically less severe in tomatoes than in cucurbits but can still reduce yields.'),
(1, 6, 'Serious threat in warm climates. No chemical cure available.'),
(1, 7, 'Multiple races of Fusarium affect tomatoes. Use race-specific resistant varieties.'),
(1, 8, 'Tobacco Mosaic Virus (TMV) and Cucumber Mosaic Virus (CMV) both affect tomatoes.'),

-- Rose diseases
(2, 3, 'One of the most common rose diseases. Regular monitoring and air circulation are key.'),
(2, 4, 'The most damaging disease for garden roses. Consistent prevention program recommended.'),

-- Potato diseases
(3, 1, 'Same pathogen as tomato early blight. Crop rotation between solanaceous crops is critical.'),
(3, 2, 'Historically devastating to potato crops. Monitor weather conditions closely.'),
(3, 6, 'Brown rot caused by Ralstonia. Quarantine pest in many regions.'),

-- Cucumber diseases
(4, 3, 'Very common in cucurbits. Multiple powdery mildew species can infect cucumbers.'),
(4, 5, 'Major threat to cucumber production. Scout regularly during cool, wet weather.'),
(4, 10, 'Cucurbit anthracnose can affect leaves, stems, and fruit.'),
(4, 8, 'Cucumber Mosaic Virus is widespread and transmitted by aphids.'),

-- Apple diseases
(5, 3, 'Apple powdery mildew primarily affects young shoots and blossoms.'),
(5, 9, 'Serious threat to apple orchards. Can kill branches and young trees.'),

-- Basil diseases
(6, 5, 'Basil downy mildew has become a major problem for basil growers worldwide.'),
(6, 7, 'Fusarium wilt of basil is soil-borne and difficult to manage once established.'),

-- Strawberry diseases
(7, 3, 'Powdery mildew can affect strawberry leaves, flowers, and fruit.'),
(7, 10, 'Anthracnose fruit rot is a major concern in warm, humid growing regions.'),
(7, 7, 'Fusarium wilt is an increasing problem in strawberry production systems.'),

-- Corn diseases
(8, 10, 'Anthracnose leaf blight and stalk rot are common in corn.'),
(8, 8, 'Several mosaic viruses affect corn, including Maize Dwarf Mosaic Virus.'),

-- Grape diseases
(9, 3, 'Grape powdery mildew is one of the most important diseases in viticulture.'),
(9, 5, 'Grape downy mildew can cause severe crop losses in wet seasons.'),
(9, 10, 'Grape anthracnose (bird''s eye rot) affects leaves, shoots, and berries.'),

-- Pepper diseases
(10, 6, 'Bacterial wilt is a major constraint for pepper production in tropical regions.'),
(10, 7, 'Multiple races of Fusarium affect peppers. Resistant varieties are limited.'),
(10, 8, 'Several viruses including CMV and Pepper Mosaic Virus affect peppers.'),
(10, 10, 'Anthracnose is a significant fruit rot disease of peppers.');

-- 6d. Plant Info (extended details)
INSERT INTO plant_info (plant_id, soil_type, sunlight, watering, hardiness_zone, companion_plants, common_pests) VALUES
(1,  'Well-drained, loamy, slightly acidic (pH 6.0-6.8)',   'Full sun (6-8 hours)',     'Regular, 1-2 inches per week. Consistent moisture is key.',    '3-11',  'Basil, carrots, parsley, marigolds',                 'Aphids, hornworms, whiteflies, spider mites'),
(2,  'Well-drained, loamy, slightly acidic (pH 6.0-6.5)',   'Full sun (6+ hours)',      'Deep watering 1-2 times per week at the base.',               '3-11',  'Lavender, geraniums, garlic, chives',                'Aphids, Japanese beetles, thrips, rose sawfly'),
(3,  'Loose, well-drained, slightly acidic (pH 5.0-6.0)',   'Full sun (6+ hours)',      'Regular, 1-2 inches per week. Keep soil evenly moist.',        '3-10',  'Beans, corn, cabbage, horseradish, marigolds',       'Colorado potato beetle, aphids, wireworms, flea beetles'),
(4,  'Rich, well-drained, neutral (pH 6.0-7.0)',            'Full sun (6-8 hours)',     'Frequent, 1 inch per week. Consistent moisture prevents bitterness.', '4-12', 'Beans, peas, radishes, sunflowers, corn',     'Cucumber beetles, aphids, spider mites, squash bugs'),
(5,  'Well-drained, loamy, slightly acidic (pH 6.0-7.0)',   'Full sun (6-8 hours)',     'Regular during establishment. Mature trees need 1 inch per week.',     '3-8',  'Chives, nasturtiums, comfrey, clover',        'Codling moth, apple maggot, aphids, scale insects'),
(6,  'Rich, moist, well-drained (pH 6.0-7.0)',              'Full sun (6-8 hours)',     'Regular, keep soil moist but not waterlogged.',                '10-11', 'Tomatoes, peppers, oregano, chamomile',              'Aphids, Japanese beetles, slugs, whiteflies'),
(7,  'Well-drained, loamy, slightly acidic (pH 5.5-6.8)',   'Full sun (6-8 hours)',     'Regular, 1-1.5 inches per week. Drip irrigation preferred.',   '3-10',  'Borage, lettuce, spinach, onions, thyme',            'Spider mites, slugs, strawberry bud weevil, birds'),
(8,  'Rich, well-drained, slightly acidic (pH 5.8-7.0)',    'Full sun (8+ hours)',      'Regular, 1-1.5 inches per week. Critical during tasseling.',   '4-8',   'Beans, squash, cucumbers, peas (Three Sisters)',     'Corn earworm, corn borer, armyworm, cutworms'),
(9,  'Well-drained, sandy or loamy (pH 5.5-7.0)',           'Full sun (7-8 hours)',     'Deep, infrequent watering. Reduce before harvest.',            '4-10',  'Roses, hyssop, oregano, clover',                     'Grape berry moth, Japanese beetles, phylloxera, mealybugs'),
(10, 'Rich, well-drained, slightly acidic (pH 6.0-6.8)',    'Full sun (6-8 hours)',     'Regular, 1-2 inches per week. Consistent moisture needed.',    '9-11',  'Tomatoes, basil, carrots, onions',                   'Aphids, pepper weevil, hornworms, flea beetles');

-- ────────────────────────────────────────────────────────────
-- 7. EXAMPLE QUERIES (for testing)
-- ────────────────────────────────────────────────────────────

-- Fuzzy search for plants (trigram similarity)
-- SELECT id, common_name, scientific_name,
--        similarity(common_name, 'tomato') AS score
-- FROM plants
-- WHERE common_name % 'tomato'
--    OR scientific_name % 'tomato'
-- ORDER BY score DESC;

-- Get all diseases for a specific plant
-- SELECT d.id, d.name, d.disease_type, d.severity, pd.notes
-- FROM diseases d
-- JOIN plant_diseases pd ON d.id = pd.disease_id
-- WHERE pd.plant_id = 1
-- ORDER BY d.severity DESC, d.name;

-- Get full disease detail
-- SELECT * FROM diseases WHERE id = 1;

-- Get plant profile with extended info
-- SELECT p.*, pi.soil_type, pi.sunlight, pi.watering,
--        pi.hardiness_zone, pi.companion_plants, pi.common_pests
-- FROM plants p
-- LEFT JOIN plant_info pi ON p.id = pi.plant_id
-- WHERE p.id = 1;
