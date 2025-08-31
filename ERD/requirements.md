# Airbnb Database ERD Requirements

## Entities and Attributes

### User
- `user_id` (PK, UUID, Indexed)
- `first_name` (VARCHAR, NOT NULL)
- `last_name` (VARCHAR, NOT NULL)
- `email` (VARCHAR, UNIQUE, NOT NULL)
- `password_hash` (VARCHAR, NOT NULL)
- `phone_number` (VARCHAR, NULL)
- `role` (ENUM: guest, host, admin, NOT NULL)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

### Property
- `property_id` (PK, UUID, Indexed)
- `host_id` (FK → User.user_id)
- `name` (VARCHAR, NOT NULL)
- `description` (TEXT, NOT NULL)
- `location` (VARCHAR, NOT NULL)
- `pricepernight` (DECIMAL, NOT NULL)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP)

### Booking
- `booking_id` (PK, UUID, Indexed)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `start_date` (DATE, NOT NULL)
- `end_date` (DATE, NOT NULL)
- `total_price` (DECIMAL, NOT NULL)
- `status` (ENUM: pending, confirmed, canceled, NOT NULL)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

### Payment
- `payment_id` (PK, UUID, Indexed)
- `booking_id` (FK → Booking.booking_id)
- `amount` (DECIMAL, NOT NULL)
- `payment_date` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `payment_method` (ENUM: credit_card, paypal, stripe, NOT NULL)

### Review
- `review_id` (PK, UUID, Indexed)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `rating` (INTEGER, CHECK 1 ≤ rating ≤ 5, NOT NULL)
- `comment` (TEXT, NOT NULL)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

### Message
- `message_id` (PK, UUID, Indexed)
- `sender_id` (FK → User.user_id)
- `recipient_id` (FK → User.user_id)
- `message_body` (TEXT, NOT NULL)
- `sent_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

---

## Relationships
- **User–Property**: One User (host) can have many Properties.
- **User–Booking**: One User (guest) can make many Bookings.
- **Property–Booking**: One Property can have many Bookings.
- **Booking–Payment**: Each Booking has exactly one Payment.
- **User–Review–Property**: A User (guest) can leave many Reviews on a Property.
- **User–Message**: A User can send and receive many Messages (self-referencing).

---

## Indexing
- **Primary Keys**: All entities use UUIDs (indexed automatically).
- **Unique Index**: `email` on User.
- **Foreign Keys**: host_id, property_id, user_id, booking_id, sender_id, recipient_id.
- **Additional Indexes**:
  - `property_id` in Property & Booking.
  - `booking_id` in Booking & Payment.
