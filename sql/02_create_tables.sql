
-- Create the seven relational tables in dependency order
-- to ensure referenced tables exist before defining foreign keys.


-- 1. Hosts: stores unique host information.
CREATE TABLE IF NOT EXISTS hosts (
    host_id BIGINT PRIMARY KEY,
    host_name TEXT NOT NULL,
    host_profile_id BIGINT,
    host_location TEXT,
    host_is_superhost BOOLEAN,
    host_identity_verified BOOLEAN,
    host_has_profile_pic BOOLEAN,
    host_listings_count INTEGER,
    hosts_time_as_host_years INTEGER,
    hosts_time_as_host_months INTEGER,
    hosts_time_as_user_years INTEGER,
    hosts_time_as_user_months INTEGER,
    host_url TEXT
);


-- 2. Neighbourhoods: stores unique neighbourhoods in Malaga.
CREATE TABLE IF NOT EXISTS neighbourhoods (
    neighbourhood TEXT PRIMARY KEY
);


-- 3. Amenities: stores unique amenities with generated IDs.
CREATE TABLE IF NOT EXISTS amenities (
    amenity_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    amenity_name TEXT NOT NULL UNIQUE
);


-- 4. Listings: stores property information and references
-- hosts and neighbourhoods through foreign keys (1:N).
CREATE TABLE IF NOT EXISTS listings (
    listing_id BIGINT PRIMARY KEY,
    host_id BIGINT NOT NULL,
    neighbourhood TEXT NOT NULL,
    listing_url TEXT,
    name TEXT NOT NULL,
    description TEXT,
    property_type TEXT,
    room_type TEXT,
    accommodates INTEGER,
    bedrooms INTEGER,
    beds INTEGER,
    bathrooms_count NUMERIC(4,1),
    bathroom_type TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    price NUMERIC(12,2),
    license TEXT,

-- foreing key from host_id (1:N)
    CONSTRAINT fk_listings_host
        FOREIGN KEY (host_id)
        REFERENCES hosts(host_id),

-- foreing key from neighbourhood (1:N)
    CONSTRAINT fk_listings_neighbourhood
        FOREIGN KEY (neighbourhood)
        REFERENCES neighbourhoods(neighbourhood)
);




-- 5. Calendar: stores daily availability and stay restrictions.
-- Each listing can have multiple calendar records (1:N).
CREATE TABLE IF NOT EXISTS calendar (
    listing_id BIGINT NOT NULL,
    date DATE NOT NULL,
    available BOOLEAN NOT NULL,
    minimum_nights INTEGER NOT NULL,
    maximum_nights INTEGER NOT NULL,

    -- Composite primary key: one record per listing and date.
    CONSTRAINT pk_calendar
        PRIMARY KEY (listing_id, date),

    -- Foreign key: each calendar record belongs to one listing.
    CONSTRAINT fk_calendar_listing
        FOREIGN KEY (listing_id)
        REFERENCES listings(listing_id)
);


-- 6. Reviews: stores reviews associated with each listing.
-- A listing can have multiple reviews (1:N).
CREATE TABLE IF NOT EXISTS reviews (
    listing_id BIGINT NOT NULL,
    review_id BIGINT NOT NULL,
    date DATE NOT NULL,
    reviewer_id BIGINT,
    reviewer_name TEXT,
    comments TEXT,

    -- Composite PK: review IDs are unique within each listing.
    CONSTRAINT pk_reviews
        PRIMARY KEY (listing_id, review_id),

    -- FK: each review belongs to an existing listing.
    CONSTRAINT fk_reviews_listing
        FOREIGN KEY (listing_id)
        REFERENCES listings(listing_id)
);



-- 7. Listing amenities: links listings to their amenities.
-- Implements the many-to-many relationship (N:M).
CREATE TABLE IF NOT EXISTS listing_amenities (
    listing_id BIGINT NOT NULL,
    amenity_id BIGINT NOT NULL,

    -- Composite PK: prevents duplicate listing-amenity pairs.
    CONSTRAINT pk_listing_amenities
        PRIMARY KEY (listing_id, amenity_id),

    -- FK: each listing must exist in listings.
    CONSTRAINT fk_listing_amenities_listing
        FOREIGN KEY (listing_id)
        REFERENCES listings(listing_id),

    -- FK: each amenity must exist in amenities.
    CONSTRAINT fk_listing_amenities_amenity
        FOREIGN KEY (amenity_id)
        REFERENCES amenities(amenity_id)
);
