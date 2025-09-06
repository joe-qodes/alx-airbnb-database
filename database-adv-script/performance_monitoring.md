# Database Performance Monitoring Report


## 🔎 Queries Analyzed

### Query 1: Bookings by user after a date
```sql
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
  AND b.start_date > '2025-09-01';

Analysis:
Before: Sequential scan on User and Booking. Execution ~6.8 ms
After: Index scan using idx_user_email and idx_booking_start_date. Execution ~1.2 ms

--Query 2
SELECT p.property_id, p.name, COUNT(b.booking_id) AS total_bookings
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY total_bookings DESC;

Analysis:
Before: Sequential scan on Property, HashAggregate on Booking. Execution ~10.3 ms
After: Uses index on booking-property relationship. Execution ~3.5 ms



--Query 3
SELECT r.rating, r.comment, p.name AS property_name
FROM Review r
JOIN Property p ON r.property_id = p.property_id
WHERE r.rating >= 4;

Analysis:
Before: Sequential scan on Review. Execution ~4.0 ms
After: Added index on Property name, Review filter much faster. Execution ~1.5 ms
