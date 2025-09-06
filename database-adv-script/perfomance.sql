-- Initial Complex Query
-- Retrieves all bookings with user, property, and payment details (unoptimized)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    u.email,
    p.name AS property_name,
    p.location,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE u.email = 'alice@example.com'
  AND b.start_date > '2025-09-01';


-- Refactored Query
-- Optimized: fewer columns, uses indexes, avoids unnecessary data
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name || ' ' || u.last_name AS user_full_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_method
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE u.email = 'alice@example.com'
  AND b.start_date > '2025-09-01';
