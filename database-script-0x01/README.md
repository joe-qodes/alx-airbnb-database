# Database Schema: Airbnb Clone

This directory contains the SQL schema for the **Airbnb-style database project**.

## Files
- `schema.sql`: Defines all tables, constraints, and indexes.

## Entities
- **User**: Stores information about users (guests, hosts, admins).
- **Property**: Listings created by hosts.
- **Booking**: Reservations linking users and properties.
- **Payment**: Records payments for bookings.
- **Review**: Reviews left by users on properties.
- **Message**: Direct messages between users.

## Features
- ✅ Primary keys with UUIDs.
- ✅ Foreign keys with cascading deletes.
- ✅ Unique constraint on `email`.
- ✅ ENUM-like constraints using `CHECK`.
- ✅ Indexes on frequently queried columns for performance.

## Usage
Run the schema in your PostgreSQL database:

```bash
psql -U <username> -d <database_name> -f schema.sql
