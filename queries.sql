
-- -------------------------------
-- 1. USERS TABLE
-- -------------------------------
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,  -- EMPLOYEE, MANAGER, ADMIN
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------
-- 2. PROJECTS TABLE (Internal Master Data)
-- -------------------------------
CREATE TABLE projects (
    id BIGSERIAL PRIMARY KEY,
    project_code VARCHAR(50) UNIQUE NOT NULL,
    project_name VARCHAR(150) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------
-- 3. TIMESHEETS TABLE
-- -------------------------------
CREATE TABLE timesheets (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    project_id BIGINT NOT NULL,
    work_date DATE NOT NULL,
    hours_worked NUMERIC(5,2) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL, -- DRAFT, SUBMITTED, APPROVED
    approved_by BIGINT,
    approved_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,

    CONSTRAINT fk_timesheet_employee
        FOREIGN KEY (employee_id)
        REFERENCES users(id),

    CONSTRAINT fk_timesheet_project
        FOREIGN KEY (project_id)
        REFERENCES projects(id),

    CONSTRAINT fk_timesheet_approver
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
);

-- -------------------------------
-- 4. TIMESHEET AUDIT TABLE
-- -------------------------------
CREATE TABLE timesheet_audit (
    id BIGSERIAL PRIMARY KEY,
    timesheet_id BIGINT NOT NULL,
    action VARCHAR(50) NOT NULL, -- CREATED, UPDATED, APPROVED, DELETED
    performed_by BIGINT NOT NULL,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,

    CONSTRAINT fk_audit_timesheet
        FOREIGN KEY (timesheet_id)
        REFERENCES timesheets(id),

    CONSTRAINT fk_audit_user
        FOREIGN KEY (performed_by)
        REFERENCES users(id)
);

-- -------------------------------
-- INDEXES (Performance Optimization)
-- -------------------------------
CREATE INDEX idx_timesheets_employee ON timesheets(employee_id);
CREATE INDEX idx_timesheets_project ON timesheets(project_id);
CREATE INDEX idx_timesheets_status ON timesheets(status);
CREATE INDEX idx_timesheets_work_date ON timesheets(work_date);
CREATE INDEX idx_timesheets_deleted ON timesheets(is_deleted);
CREATE INDEX idx_audit_timesheet ON timesheet_audit(timesheet_id);

-- =====================================================
-- END OF SCHEMA
-- =====================================================
