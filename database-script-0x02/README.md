# Database Seeding: Airbnb Clone

This directory contains **sample data population scripts** for the Airbnb clone database.

## Files
- `seed.sql`: Inserts realistic sample data into all tables.

## Entities Covered
- **User**: 4 users (2 guests, 2 hosts).
- **Property**: 2 sample listings.
- **Booking**: 2 bookings (one confirmed, one pending).
- **Payment**: Payments linked to bookings.
- **Review**: Guest reviews for properties.
- **Message**: Direct communication between users.

## Usage
1. Ensure you’ve already created the schema:
   ```bash
   psql -U <username> -d <database_name> -f ../database-script-0x01/schema.sql
