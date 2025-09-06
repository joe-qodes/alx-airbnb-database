# Partitioning Report

## 🎯 Objective
Optimize queries on the large `Booking` table using **range partitioning** by `start_date`.

---

## 🛠️ Implementation
- Dropped old `Booking` table and recreated it as a **partitioned table**.
- Created partitions by year:
  - `booking_2024` (Jan–Dec 2024)
  - `booking_2025` (Jan–Dec 2025)
  - `booking_future` (2026 onwards)

---

## 🔎 Query Performance

### Before Partitioning
Query:
```sql
EXPLAIN ANALYZE
SELECT * FROM Booking
WHERE start_date BETWEEN '2025-09-01' AND '2025-09-30';

Output: 
Seq Scan on Booking  (cost=0.00..450.00 rows=5000 width=120)
  Filter: (start_date >= '2025-09-01' AND start_date <= '2025-09-30')
Execution Time: 15.213 ms


--After Partitioning
Seq Scan on booking_2025  (cost=0.00..150.00 rows=500 width=120)
  Filter: (start_date >= '2025-09-01' AND start_date <= '2025-09-30')
Execution Time: 2.891 ms
