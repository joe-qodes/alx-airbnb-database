-- seed.sql
-- Populate Airbnb clone database with sample data

-- Clear existing data (respecting FK constraints order)
TRUNCATE TABLE Message, Review, Payment, Booking, Property, "User" RESTART IDENTITY CASCADE;

-- ========================
-- Insert Users
-- ========================
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw_1', '+233501234567', 'guest'),
  ('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw_2', '+233541234567', 'host'),
  ('33333333-3333-3333-3333-333333333333', 'Charlie', 'Brown', 'charlie@example.com', 'hashed_pw_3', '+233561234567', 'guest'),
  ('44444444-4444-4444-4444-444444444444', 'Diana', 'Prince', 'diana@example.com', 'hashed_pw_4', '+233591234567', 'host');

-- ========================
-- Insert Properties
-- ========================
INSERT INTO Property (property_id, host_id, name, description, location, price_per_night)
VALUES
  ('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222',
   'Beachside Villa', 'Luxury villa by the sea with 3 bedrooms and pool.', 'Accra, Ghana', 200.00),
  ('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '44444444-4444-4444-4444-444444444444',
   'City Apartment', 'Modern apartment in downtown with fast Wi-Fi.', 'Kumasi, Ghana', 80.00);

-- ========================
-- Insert Bookings
-- ========================
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  ('ccccccc1-cccc-cccc-cccc-cccccccccccc', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', '2025-09-10', '2025-09-15', 1000.00, 'confirmed'),
  ('ccccccc2-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '33333333-3333-3333-3333-333333333333', '2025-10-01', '2025-10-05', 320.00, 'pending');

-- ========================
-- Insert Payments
-- ========================
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
  ('ddddddd1-dddd-dddd-dddd-dddddddddddd', 'ccccccc1-cccc-cccc-cccc-cccccccccccc', 1000.00, 'credit_card'),
  ('ddddddd2-dddd-dddd-dddd-dddddddddddd', 'ccccccc2-cccc-cccc-cccc-cccccccccccc', 320.00, 'paypal');

-- ========================
-- Insert Reviews
-- ========================
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
  ('eeeeeee1-eeee-eeee-eeee-eeeeeeeeeeee', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 5, 'Amazing villa! Highly recommend.'),
  ('eeeeeee2-eeee-eeee-eeee-eeeeeeeeeeee', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '33333333-3333-3333-3333-333333333333', 4, 'Nice apartment, good location.');

-- ========================
-- Insert Messages
-- ========================
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
  ('fffffff1-ffff-ffff-ffff-ffffffffffff', '11111111-1111-1111-1111-111111111111',
   '22222222-2222-2222-2222-222222222222', 'Hi Bob, is the villa available for next month?'),
  ('fffffff2-ffff-ffff-ffff-ffffffffffff', '22222222-2222-2222-2222-222222222222',
   '11111111-1111-1111-1111-111111111111', 'Yes Alice, the villa is free after September 20th.');
