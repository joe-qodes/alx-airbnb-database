-- Before Refactor
Hash Join  (cost=120.55..250.78 rows=100 width=120)
  Hash Cond: (b.user_id = u.user_id)
  ->  Hash Join  (cost=85.22..180.33 rows=100 width=90)
        Hash Cond: (b.property_id = p.property_id)
        ->  Seq Scan on Booking b  (cost=0.00..80.00 rows=100 width=60)
        ->  Seq Scan on Property p (cost=0.00..50.00 rows=20 width=30)
  ->  Seq Scan on "User" u  (cost=0.00..40.00 rows=20 width=30)
  ->  Seq Scan on Payment pay  (cost=0.00..30.00 rows=10 width=20)
Execution Time: 8.203 ms

-- After Refactor
Nested Loop  (cost=65.10..140.22 rows=80 width=100)
  ->  Index Scan using idx_booking_user_property on Booking b (cost=0.20..40.00 rows=80 width=60)
  ->  Index Scan using idx_user_email on "User" u (cost=0.15..8.17 rows=1 width=30)
  ->  Index Scan using idx_property_location on Property p (cost=0.20..9.05 rows=1 width=30)
  ->  Index Scan using idx_payment_booking on Payment pay (cost=0.20..9.05 rows=1 width=20)
Execution Time: 2.015 ms
