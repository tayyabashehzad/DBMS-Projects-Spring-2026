-- =====================================================================
--  INCIDENT REPORTING SYSTEM  -  DATABASE SCHEMA
--  Database Systems Project
--  Engine: MySQL 8.0 (InnoDB)
-- =====================================================================
--  This file CREATES the whole database. Every table, every primary key
--  (PK) and every foreign key (FK) is defined here. Read the comments -
--  they explain WHY each table and column exists (useful for viva).
-- =====================================================================

-- Create the database and switch to it
CREATE DATABASE IF NOT EXISTS incident_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE incident_db;

-- Drop old tables first (so the script can be re-run cleanly).
-- Order matters: drop children (tables with FKs) BEFORE parents.
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS resolutions;
DROP TABLE IF EXISTS verifications;
DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS users;


-- ---------------------------------------------------------------------
-- 1) USERS  (the people who REPORT incidents)
--    Maps to the "User" entity in the ER diagram.
-- ---------------------------------------------------------------------
CREATE TABLE users (
    user_id      INT AUTO_INCREMENT PRIMARY KEY,   -- PK: unique id for each user
    name         VARCHAR(100)  NOT NULL,
    email        VARCHAR(120)  NOT NULL UNIQUE,     -- UNIQUE: no two users share an email
    password     VARCHAR(255)  NOT NULL,            -- stored hashed, never plain text
    contact_info VARCHAR(50),                       -- phone number, etc.
    role         VARCHAR(20)   NOT NULL DEFAULT 'Reporter',
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 2) USER_PROFILES  (extra optional details for a user)
--    Maps to the "User Profile" entity. This is a 1-to-1 relationship
--    with users: each user has AT MOST ONE profile. We enforce 1:1 by
--    making user_id a UNIQUE foreign key.
-- ---------------------------------------------------------------------
CREATE TABLE user_profiles (
    profile_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL UNIQUE,                -- UNIQUE FK  => 1:1 link to users
    department  VARCHAR(80),
    designation VARCHAR(80),
    address     VARCHAR(200),
    CONSTRAINT fk_profile_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE                           -- delete user -> delete their profile
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 3) ADMINS  (administrators / support staff who MANAGE incidents)
--    Maps to the "User (Admin)" entity in the ER diagram.
-- ---------------------------------------------------------------------
CREATE TABLE admins (
    admin_id    INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(120) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    designation VARCHAR(50)  NOT NULL DEFAULT 'Administrator', -- e.g. Admin / Support Staff
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 4) INCIDENTS  (the core table - one row per reported incident)
--    Maps to the "Incident" entity.
--    Relationships:
--      reported_by -> users   (who reported it)        : many incidents : 1 user
--      assigned_to -> admins  (who is handling it)      : many incidents : 1 admin
-- ---------------------------------------------------------------------
CREATE TABLE incidents (
    incident_id INT AUTO_INCREMENT PRIMARY KEY,
    reported_by INT NOT NULL,                        -- FK -> users
    title       VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    -- ENUM = the value must be one of a fixed list. Keeps data clean.
    category    ENUM('Technical','Security','Workplace','Other') NOT NULL DEFAULT 'Other',
    severity    ENUM('Low','Medium','High','Critical')           NOT NULL DEFAULT 'Low',
    location    VARCHAR(120),
    status      ENUM('Pending','Verified','Assigned','In Progress','Resolved','Rejected')
                    NOT NULL DEFAULT 'Pending',
    assigned_to INT NULL,                            -- FK -> admins (NULL until assigned)
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_at TIMESTAMP NULL,
    CONSTRAINT fk_incident_user
        FOREIGN KEY (reported_by) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_incident_admin
        FOREIGN KEY (assigned_to) REFERENCES admins(admin_id)
        ON DELETE SET NULL                           -- if admin removed, keep incident
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 5) VERIFICATIONS  (an admin checks if a reported incident is valid)
--    Maps to the "Verification" entity.
--    1:1 with incidents  -> incident_id is UNIQUE.
--      incident_id -> incidents
--      verified_by -> admins  (who verified it)
-- ---------------------------------------------------------------------
CREATE TABLE verifications (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id     INT NOT NULL UNIQUE,             -- UNIQUE => one verification per incident
    verified_by     INT NOT NULL,
    status          ENUM('Verified','Rejected') NOT NULL,
    notes           TEXT,
    verified_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_verif_incident
        FOREIGN KEY (incident_id) REFERENCES incidents(incident_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_verif_admin
        FOREIGN KEY (verified_by) REFERENCES admins(admin_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 6) RESOLUTIONS  (how an incident was finally resolved)
--    Maps to the "Resolution" entity.
--    1:1 with incidents -> incident_id is UNIQUE.
--      incident_id -> incidents
--      resolved_by -> admins (the responsible admin)
-- ---------------------------------------------------------------------
CREATE TABLE resolutions (
    resolution_id   INT AUTO_INCREMENT PRIMARY KEY,
    incident_id     INT NOT NULL UNIQUE,             -- UNIQUE => one resolution per incident
    resolved_by     INT NOT NULL,
    actions_taken   TEXT NOT NULL,
    status          ENUM('Resolved','Closed','Reopened') NOT NULL DEFAULT 'Resolved',
    completion_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_resol_incident
        FOREIGN KEY (incident_id) REFERENCES incidents(incident_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_resol_admin
        FOREIGN KEY (resolved_by) REFERENCES admins(admin_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- 7) NOTIFICATIONS  (messages sent to a user about their incident)
--    Maps to the "Notification" entity.
--    1:N  -> one incident can generate MANY notifications.
--      incident_id  -> incidents (what it is about)
--      recipient_id -> users     (who receives it)
-- ---------------------------------------------------------------------
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id     INT NOT NULL,
    recipient_id    INT NOT NULL,
    message         VARCHAR(255) NOT NULL,
    type            ENUM('System','Email','SMS') NOT NULL DEFAULT 'System',
    status          ENUM('Unread','Read') NOT NULL DEFAULT 'Unread',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_incident
        FOREIGN KEY (incident_id) REFERENCES incidents(incident_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_notif_user
        FOREIGN KEY (recipient_id) REFERENCES users(user_id)
        ON DELETE CASCADE
) ENGINE=InnoDB;


-- ---------------------------------------------------------------------
-- INDEXES (speed up the lookups the app does most often).
-- The PK and UNIQUE columns are already indexed automatically; these
-- add indexes on the foreign-key columns we filter/join on a lot.
-- ---------------------------------------------------------------------
CREATE INDEX idx_incident_reporter ON incidents(reported_by);
CREATE INDEX idx_incident_status   ON incidents(status);
CREATE INDEX idx_notif_recipient   ON notifications(recipient_id);

-- =====================================================================
--  END OF SCHEMA
-- =====================================================================
