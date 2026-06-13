# Incident Reporting System

**Student Names:** Usman Aslam & Abdullah Amjad
**Roll Numbers:** 41566 & 41195
**Section:** BSCS
**Course:** Database Systems (DBMS) — Spring 2026
**Instructor:** Tayyaba Shehzad

---

## Project Description

The **Incident Reporting System** is a database-driven platform that lets an
organization report, track and resolve incidents in an organized way. Users
report incidents; administrators verify, assign and resolve them; and the
reporter is kept informed through notifications. All data is stored in a
relational **MySQL** database.

**Tech stack:** MySQL · Python (Flask, using raw SQL) · HTML / CSS / JavaScript

---

## Database Design

The database (`incident_db`) has **7 related tables**:

| Table | Purpose |
|-------|---------|
| `users` | People who report incidents |
| `user_profiles` | Extra user details (1:1 with users) |
| `admins` | Administrators / staff who manage incidents |
| `incidents` | The central table of reported incidents |
| `verifications` | An admin's validity check of an incident (1:1) |
| `resolutions` | How an incident was resolved (1:1) |
| `notifications` | Messages sent to users (1:N) |

**Relationships**
- `users` 1:1 `user_profiles` (UNIQUE foreign key)
- `users` 1:N `incidents` (a user reports many incidents)
- `admins` 1:N `incidents` (an admin is assigned many incidents)
- `incidents` 1:1 `verifications` and 1:1 `resolutions`
- `incidents` 1:N `notifications`, `users` 1:N `notifications`

The schema uses primary keys, foreign keys, `UNIQUE`, `NOT NULL`, `DEFAULT`,
`ENUM` and `ON DELETE CASCADE / SET NULL` constraints, and is normalized to
**Third Normal Form (3NF)**.

See `schema.sql` for the full database and `queries.sql` for the main SQL queries.

---

## How to Run

1. Start a MySQL server.
2. Run `schema.sql` to create the `incident_db` database and all tables.
3. Configure the database connection and run the Flask app (`python app.py`).
4. Open `http://127.0.0.1:5000` in a browser.

**Demo accounts:** user `alice@example.com` / `password123`,
admin `admin@example.com` / `admin123`.

---

## Full Source Code

The complete application (backend, frontend and setup) is available here:
**https://github.com/Usman66712/incident-reporting-system**
