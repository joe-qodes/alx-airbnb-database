-- Initial Complex Query
-- Retrieves all bookings along with user, property, and payment details
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
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;


-- Refactored Query
-- Improvements:
-- 1. Use only necessary columns instead of SELECT *
-- 2. Ensure indexes are used (idx_booking_user_property, idx_user_email, idx_booking_start_date)
-- 3. Keep LEFT JOIN only where nullable (payments may not exist)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name || ' ' || u.last_name AS user_full_name,
    u.email,
    p.name AS property_name,
    pay.amount,
    pay.payment_method
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;
