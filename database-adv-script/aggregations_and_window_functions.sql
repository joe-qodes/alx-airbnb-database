-- aggregations_and_window_functions.sql
-- Aggregation + Window Function practice — explicit RANK() and ROW_NUMBER() ranking by total bookings

-- 1) Total number of bookings made by each user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM "User" u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC, u.last_name ASC;


-- Compute total bookings per property in a CTE (reusable)

WITH property_bookings AS (
    SELECT 
        p.property_id,
        p.name AS property_name,
        p.location,
        COUNT(b.booking_id) AS total_bookings
    FROM Property p
    LEFT JOIN Booking b ON p.property_id = b.property_id
    GROUP BY p.property_id, p.name, p.location
)

-- 2) RANK(): Global ranking of properties by total bookings (ties share the same rank)
SELECT
    pb.property_id,
    pb.property_name,
    pb.location,
    pb.total_bookings,
    RANK() OVER (ORDER BY pb.total_bookings DESC) AS booking_rank
FROM property_bookings pb
ORDER BY booking_rank ASC, pb.total_bookings DESC;


-- 3) ROW_NUMBER(): Strict global ordering of properties by total bookings
--    (tie-breaker added on property_id to make ordering deterministic)
SELECT
    pb.property_id,
    pb.property_name,
    pb.location,
    pb.total_bookings,
    ROW_NUMBER() OVER (
        ORDER BY pb.total_bookings DESC, pb.property_id ASC
    ) AS booking_row_number
FROM property_bookings pb
ORDER BY booking_row_number ASC;
