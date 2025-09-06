
-- User table
CREATE INDEX idx_user_email ON "User"(email);
CREATE INDEX idx_user_role ON "User"(role);

-- Property table
CREATE INDEX idx_property_location ON Property(location);

-- Booking table
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

-- Performance Test Queries
-- Query performance BEFORE and AFTER indexes are visible with EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
  AND b.start_date > '2025-09-01';

EXPLAIN ANALYZE
SELECT p.property_id, p.name, COUNT(b.booking_id) AS total_bookings
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY total_bookings DESC;
