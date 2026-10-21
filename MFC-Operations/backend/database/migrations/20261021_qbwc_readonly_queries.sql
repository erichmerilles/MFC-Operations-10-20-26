-- Read-only QuickBooks Web Connector lifecycle for customer and item queries.
-- This migration adds a dedicated session/request table pair for QBWC calls.
-- It does not create or modify QuickBooks records; only local app state is written.

CREATE TABLE IF NOT EXISTS qbwc_sessions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ticket VARCHAR(64) NOT NULL UNIQUE,
    username VARCHAR(80) NOT NULL,
    status ENUM('active','closed','failed','expired') NOT NULL DEFAULT 'active',
    authenticated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    last_error TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_qbwc_sessions_username (username),
    INDEX idx_qbwc_sessions_status (status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS qbwc_requests (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id BIGINT UNSIGNED NOT NULL,
    request_type ENUM('CustomerQuery','ItemQuery','Other') NOT NULL DEFAULT 'Other',
    request_xml MEDIUMTEXT NULL,
    response_xml MEDIUMTEXT NULL,
    status ENUM('pending','received','failed','stale','expired') NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME NULL,
    CONSTRAINT fk_qbwc_requests_session FOREIGN KEY (session_id) REFERENCES qbwc_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB;
