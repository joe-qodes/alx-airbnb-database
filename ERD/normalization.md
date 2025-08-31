# normalization.md
## Goal
Bring the `alx-airbnb-database` schema into **Third Normal Form (3NF)**.  
This document:

1. Reviews the original schema for redundancy and normalization violations.
2. Proposes minimal schema changes to comply with 3NF while keeping practical considerations (audit/history, performance) in mind.
3. Provides the revised schema (DDL-style / DBML-style) and explanations for each change.

---

## Quick recap of normalization rules (short)
- **1NF**: Atomic attribute values; no repeating groups.
- **2NF**: In 1NF and every non-key attribute must depend on the whole primary key (no partial dependency on part of a composite PK).
- **3NF**: In 2NF and **no transitive dependencies** — non-key attributes must depend **only** on the key.

---

## Original schema (summary)
Entities: `User`, `Property`, `Booking`, `Payment`, `Review`, `Message`  
Key attributes (excerpt):
- `Property.pricepernight`
- `Booking.total_price` (derived from dates × property.pricepernight)
- `Payment` linked to `Booking`
- `Review.rating` (CHECK 1..5)
- `Message` with `sender_id`, `recipient_id`

Indexes/constraints: UUID PKs, email unique, FKs as specified.

---

## Issues found (potential normalization violations & redundancies)

### 1. Derived attribute: `Booking.total_price`
- **Problem**: `Booking.total_price` depends on `Booking.start_date`, `Booking.end_date` and `Property.pricepernight`. This is a **transitive dependency**:
  - `Booking.total_price` ← depends on `Booking.start_date`/`end_date` and `Property.pricepernight` (an attribute of another table).
- **3NF rule** violation: a non-key attribute (`total_price`) depends on another non-key attribute (`pricepernight` in `Property`) via a relationship.
- **Result**: Redundancy (same price data stored in `Property` and `Booking.total_price`) and risk of inconsistency if `Property.pricepernight` changes after booking.

### 2. Historical pricing vs normalization trade-off
- Real systems often *want* to preserve the price that was in effect at booking time (audit requirement). Storing `total_price` is one way, but it's a **denormalization** or storing a derived value.
- If `total_price` is required for audit/reporting, we must capture **source values** that make it reconstructible (e.g., `price_per_night_at_booking`) rather than keep a live dependent value that can become inconsistent.

### 3. `Payment` cardinality
- The spec stated "Each Booking has exactly one Payment." This is a business rule, not a normalization issue. However, forcing 1:1 may limit future needs (partial payments, refunds) and can be relaxed to 1:N (Booking → Payments) for flexibility. This doesn't affect normalization directly but is a practical design note.

### 4. `role` ENUM and small lookup data
- Using `ENUM('guest','host','admin')` is acceptable for 3NF. Optionally you can create a `Role` lookup table (normalized), but ENUM is fine if roles are fixed and small.

### 5. `location` as a single field
- `location` is a single string. If you need to query by city/country or share addresses across properties, you could normalize into `Address` or `Location`. Not required strictly for 3NF if `location` is atomic (e.g., "Accra, Ghana").

---

## Normalization decisions & recommendations

**A. Booking pricing**
- **Remove** `Booking.total_price` (derived) **OR**
- **Replace** it with `price_per_night_at_booking` (a snapshot) **and** *optionally* `fees` and `taxes` if you want to compute `total_price` deterministically:
  - This preserves the price used for that booking (audit-friendly) without relying on a transitive dependency on the `Property` table.
  - `total_price` can then be computed as:
    ```
    total_price = price_per_night_at_booking * nights + fees + taxes
    ```
  - If you still want `total_price` stored for convenience, recognize it's denormalization and document justification.

**B. Payment cardinality**
- Allow **multiple payments per booking** (Booking → Payment = 1 : N) to support deposits, installments, refunds. This is more flexible and does not harm normalization.

**C. Role, location**
- Keep `role` as ENUM (acceptable). If roles become dynamic, create a `Role` table.
- Keep `location` as VARCHAR for now. Consider `Address` if you need structured address fields.

**D. Other constraints**
- Rating CHECK (1–5) is fine.
- Keep `email` unique and indexed.

---

## Revised schema (DBML / DDL style)
Below is the adjusted schema that satisfies 3NF (eliminates transitive dependency for pricing) while preserving historical pricing data.

### DBML-ready snippet (paste to dbdiagram or use as reference)
```dbml
Table User {
  user_id UUID [pk, unique, not null]
  first_name VARCHAR [not null]
  last_name VARCHAR [not null]
  email VARCHAR [unique, not null]
  password_hash VARCHAR [not null]
  phone_number VARCHAR
  role ENUM('guest', 'host', 'admin') [not null]
  created_at TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table Property {
  property_id UUID [pk, unique, not null]
  host_id UUID [ref: > User.user_id]
  name VARCHAR [not null]
  description TEXT [not null]
  location VARCHAR [not null]
  pricepernight DECIMAL [not null]        // current listed price
  created_at TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  updated_at TIMESTAMP [note: 'Auto-updated on modification']
}

Table Booking {
  booking_id UUID [pk, unique, not null]
  property_id UUID [ref: > Property.property_id]
  user_id UUID [ref: > User.user_id]
  start_date DATE [not null]
  end_date DATE [not null]
  nights INTEGER [note: 'Optional computed field; can also be derived'] 
  price_per_night_at_booking DECIMAL [not null] // snapshot to avoid transitive dependency
  fees DECIMAL [default: 0] 
  taxes DECIMAL [default: 0]
  status ENUM('pending', 'confirmed', 'canceled') [not null]
  created_at TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  // Note: total_price is not stored to avoid transitive dependency; compute when needed:
  // total_price = price_per_night_at_booking * nights + fees + taxes
}

Table Payment {
  payment_id UUID [pk, unique, not null]
  booking_id UUID [ref: > Booking.booking_id]
  amount DECIMAL [not null]
  payment_date TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  payment_method ENUM('credit_card', 'paypal', 'stripe') [not null]
  payment_status ENUM('pending','completed','failed') [default: 'completed']
  // Allow multiple payments per booking (1:N) to support deposits/refunds
}

Table Review {
  review_id UUID [pk, unique, not null]
  property_id UUID [ref: > Property.property_id]
  user_id UUID [ref: > User.user_id]
  rating INTEGER [not null, note: '1 to 5']
  comment TEXT [not null]
  created_at TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table Message {
  message_id UUID [pk, unique, not null]
  sender_id UUID [ref: > User.user_id]
  recipient_id UUID [ref: > User.user_id]
  message_body TEXT [not null]
  sent_at TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}
