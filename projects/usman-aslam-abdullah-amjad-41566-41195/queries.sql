-- =====================================================================
--  INCIDENT REPORTING SYSTEM  -  KEY SQL QUERIES
--  These are the main queries the application runs (from app.py).
--  Placeholders shown as ? are filled in safely by the application
--  (parameterized queries -> protection against SQL injection).
-- =====================================================================

USE incident_db;

-- ---------------------------------------------------------------------
-- AUTHENTICATION
-- ---------------------------------------------------------------------
-- Find a user by email (used at login to check the password hash).
SELECT * FROM users  WHERE email = ?;
-- Find an admin by email (admin login).
SELECT * FROM admins WHERE email = ?;


-- ---------------------------------------------------------------------
-- REGISTER A NEW USER  (a user + their 1:1 profile)
-- ---------------------------------------------------------------------
INSERT INTO users (name, email, password, contact_info)
VALUES (?, ?, ?, ?);

INSERT INTO user_profiles (user_id, department)
VALUES (?, ?);


-- ---------------------------------------------------------------------
-- REPORT A NEW INCIDENT
-- ---------------------------------------------------------------------
INSERT INTO incidents (reported_by, title, description, category, severity, location)
VALUES (?, ?, ?, ?, ?, ?);


-- ---------------------------------------------------------------------
-- TRACKING (user side)
-- ---------------------------------------------------------------------
-- All incidents reported by ONE user (newest first).
SELECT incident_id, title, category, severity, status, reported_at
FROM   incidents
WHERE  reported_by = ?
ORDER  BY reported_at DESC;

-- Full detail of one incident, joined with its reporter and (optional) admin.
SELECT i.*,
       u.name AS reporter_name,
       a.name AS admin_name
FROM       incidents i
JOIN       users  u ON i.reported_by = u.user_id      -- reporter always exists
LEFT JOIN  admins a ON i.assigned_to = a.admin_id      -- admin may be NULL
WHERE i.incident_id = ?;

-- The 1:1 verification of an incident (with the admin who did it).
SELECT v.*, a.name AS admin_name
FROM   verifications v
JOIN   admins a ON v.verified_by = a.admin_id
WHERE  v.incident_id = ?;

-- The 1:1 resolution of an incident.
SELECT r.*, a.name AS admin_name
FROM   resolutions r
JOIN   admins a ON r.resolved_by = a.admin_id
WHERE  r.incident_id = ?;


-- ---------------------------------------------------------------------
-- ADMIN DASHBOARD
-- ---------------------------------------------------------------------
-- Every incident with its reporter's name.
SELECT i.*, u.name AS reporter_name
FROM   incidents i
JOIN   users u ON i.reported_by = u.user_id
ORDER  BY i.reported_at DESC;

-- Count of incidents per status (used for the dashboard tabs).
SELECT status, COUNT(*) AS total
FROM   incidents
GROUP  BY status;


-- ---------------------------------------------------------------------
-- ADMIN ACTIONS  (verify -> assign -> resolve)
-- ---------------------------------------------------------------------
-- 1) Verify an incident (insert the verification row, then update status).
INSERT INTO verifications (incident_id, verified_by, status, notes)
VALUES (?, ?, ?, ?);
UPDATE incidents SET status = ? WHERE incident_id = ?;

-- 2) Assign an incident to an admin.
UPDATE incidents
SET    assigned_to = ?, status = 'Assigned', assigned_at = CURRENT_TIMESTAMP
WHERE  incident_id = ?;

-- 3) Resolve an incident (insert the resolution row, then update status).
INSERT INTO resolutions (incident_id, resolved_by, actions_taken, status)
VALUES (?, ?, ?, 'Resolved');
UPDATE incidents SET status = 'Resolved' WHERE incident_id = ?;


-- ---------------------------------------------------------------------
-- NOTIFICATIONS
-- ---------------------------------------------------------------------
-- Create a notification (generated whenever an incident changes).
INSERT INTO notifications (incident_id, recipient_id, message, type)
VALUES (?, ?, ?, ?);

-- A user's notifications (with the incident title).
SELECT n.*, i.title AS incident_title
FROM   notifications n
JOIN   incidents i ON n.incident_id = i.incident_id
WHERE  n.recipient_id = ?
ORDER  BY n.created_at DESC;

-- Mark a user's notifications as read.
UPDATE notifications SET status = 'Read' WHERE recipient_id = ?;
-- =====================================================================
