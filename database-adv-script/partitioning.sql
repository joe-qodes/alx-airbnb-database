-- ========================
-- Step 1: Drop existing Booking table if any
-- ========================
DROP TABLE IF EXISTS Booking CASCADE;

-- ========================
-- Step 2: Create Partitioned Booking Table
-- ========================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
) PARTITION BY RANGE (start_date);

-- ========================
-- Step 3: Create Partitions
-- ========================
-- Example: Partition by year
CREATE TABLE booking_2024 PARTITION OF Booking
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE booking_2025 PARTITION OF Booking
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE booking_future PARTITION OF Booking
FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- ========================
-- Step 4: Test Query Performance
-- ========================
-- Query bookings in 2025
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-09-01' AND '2025-09-30';

-- Query bookings in 2024
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE start_date BETWEEN '2024-05-01' AND '2024-05-31';
