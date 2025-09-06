# Index Performance Report


## 🔎 Identified High-Usage Columns
Based on queries in `joins_queries.sql`, `subqueries.sql`, and `aggregations_and_window_functions.sql`, the following columns were frequently used in `WHERE`, `JOIN`, and `ORDER BY` clauses:

- **User Table**
  - `email` → used for login lookup
  - `user_id` → used in joins with Booking, Review, Message
  - `role` → often used for filtering

- **Property Table**
  - `host_id` → joins with User
  - `property_id` → joins with Booking and Review
  - `location` → used in property searches

- **Booking Table**
  - `user_id` → joins with User
  - `property_id` → joins with Property
  - `start_date` → filtering for availability
  - (`user_id`, `property_id`) → frequent combined lookups

---

## Indexes Created
Defined in [`database_index.sql`](./database_index.sql):

```sql
-- User table
CREATE INDEX idx_user_role ON "User"(role);

-- Property table
CREATE INDEX idx_property_location ON Property(location);

-- Booking table
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

## Example Query before index
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
AND b.start_date > '2025-09-01';


--Example Query after index
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
AND b.start_date > '2025-09-01';
