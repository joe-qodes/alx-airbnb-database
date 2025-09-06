-- database_index.sql
-- Indexes to improve query performance in Airbnb clone


-- User table indexes
-- Unique index already exists on email from schema.sql
-- Create index on role (if filtering/admin queries often)
CREATE INDEX idx_user_role ON "User"(role);

-- Property table indexes
-- Already indexed host_id in schema.sql
-- Add index on location for faster search by city
CREATE INDEX idx_property_location ON Property(location);

-- Booking table indexes
-- Already indexed user_id and property_id in schema.sql
-- Add index on start_date for queries filtering by date
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Composite index for frequent user/property queries
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);
