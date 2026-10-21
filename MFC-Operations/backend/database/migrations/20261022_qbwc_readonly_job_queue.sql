-- Durable, session-scoped queue for server-generated read-only QBWC queries.
-- No QuickBooks write operations or response payloads are stored by this queue.
CREATE TABLE IF NOT EXISTS qbwc_readonly_jobs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id BIGINT UNSIGNED NULL,
    request_type ENUM('CustomerQuery','ItemQuery') NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    request_xml MEDIUMTEXT NOT NULL,
    status ENUM('queued','in_flight','retry','completed','failed') NOT NULL DEFAULT 'queued',
    attempts TINYINT UNSIGNED NOT NULL DEFAULT 0,
    response_code VARCHAR(20) NOT NULL DEFAULT '',
    response_hash CHAR(64) NULL,
    diagnostic VARCHAR(255) NOT NULL DEFAULT '',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at DATETIME NULL,
    INDEX idx_qbwc_readonly_jobs_claim (session_id, status, id),
    INDEX idx_qbwc_readonly_jobs_queue (status, session_id, id),
    INDEX idx_qbwc_readonly_jobs_response (session_id, response_hash),
    CONSTRAINT fk_qbwc_readonly_jobs_session
        FOREIGN KEY (session_id) REFERENCES qbwc_sessions(id) ON DELETE SET NULL
) ENGINE=InnoDB;
