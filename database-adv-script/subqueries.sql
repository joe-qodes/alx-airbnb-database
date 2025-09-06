--Non-Correlated Subquery(Find all properties where the average rating > 4.0)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.price_per_night
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name ASC;

--Correlated Subquery(Correlated Subquery)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM "User" u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3
ORDER BY u.last_name ASC;

