# Index Performance Report

## 🎯 Objective
Measure the performance of queries in the Airbnb Clone database **before and after adding indexes**.

---

## 🛠️ Indexes Created
Defined in [`database_index.sql`](./database_index.sql):

```sql
-- User table
CREATE INDEX idx_user_email ON "User"(email);

-- Property table
CREATE INDEX idx_property_location ON Property(location);

-- Booking table
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
  AND b.start_date > '2025-09-01';

--Before indexing
Seq Scan on "User"  (cost=0.00..15.00 rows=1 width=72)
  Filter: (email = 'alice@example.com')
Seq Scan on Booking  (cost=0.00..25.00 rows=5 width=88)
  Filter: (start_date > '2025-09-01')
Execution Time: 5.103 ms

--AFter indexing
Index Scan using idx_user_email on "User"  (cost=0.15..8.17 rows=1 width=72)
  Index Cond: (email = 'alice@example.com')
Index Scan using idx_booking_start_date on Booking  (cost=0.20..9.05 rows=2 width=88)
  Index Cond: (start_date > '2025-09-01')
Execution Time: 0.247 ms
