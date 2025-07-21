-- University ERP Database Schema

-- Create database
CREATE DATABASE university_erp;
USE university_erp;

-- Common Tables
CREATE TABLE departments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,
    description TEXT,
    head_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    permissions JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    role_id BIGINT,
    department_id BIGINT,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE audit_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Agriculture Department Tables
CREATE TABLE agriculture_fields (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    area_hectares DECIMAL(10,2),
    soil_type VARCHAR(50),
    ph_level DECIMAL(3,1),
    department_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE agriculture_crops (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    variety VARCHAR(100),
    field_id BIGINT,
    planting_date DATE,
    expected_harvest_date DATE,
    actual_harvest_date DATE,
    quantity_planted DECIMAL(10,2),
    quantity_harvested DECIMAL(10,2),
    unit VARCHAR(20),
    status ENUM('planted', 'growing', 'harvested', 'failed') DEFAULT 'planted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (field_id) REFERENCES agriculture_fields(id)
);

CREATE TABLE agriculture_equipment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    model VARCHAR(100),
    purchase_date DATE,
    purchase_cost DECIMAL(12,2),
    maintenance_schedule VARCHAR(100),
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    status ENUM('active', 'maintenance', 'retired') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE agriculture_research_projects (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    principal_investigator_id BIGINT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    funding_source VARCHAR(100),
    status ENUM('proposed', 'active', 'completed', 'cancelled') DEFAULT 'proposed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (principal_investigator_id) REFERENCES users(id)
);

-- Physiotherapy Department Tables
CREATE TABLE physiotherapy_patients (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(15),
    medical_history TEXT,
    current_diagnosis TEXT,
    referring_physician VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE physiotherapy_appointments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT,
    therapist_id BIGINT,
    appointment_date DATE,
    appointment_time TIME,
    duration_minutes INT DEFAULT 60,
    appointment_type VARCHAR(50),
    status ENUM('scheduled', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES physiotherapy_patients(id),
    FOREIGN KEY (therapist_id) REFERENCES users(id)
);

CREATE TABLE physiotherapy_treatment_records (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT,
    therapist_id BIGINT,
    appointment_id BIGINT,
    treatment_date DATE,
    treatment_type VARCHAR(100),
    session_notes TEXT,
    progress_notes TEXT,
    pain_level_before INT CHECK (pain_level_before BETWEEN 0 AND 10),
    pain_level_after INT CHECK (pain_level_after BETWEEN 0 AND 10),
    exercises_prescribed TEXT,
    next_session_plan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES physiotherapy_patients(id),
    FOREIGN KEY (therapist_id) REFERENCES users(id),
    FOREIGN KEY (appointment_id) REFERENCES physiotherapy_appointments(id)
);

CREATE TABLE physiotherapy_equipment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    model VARCHAR(100),
    serial_number VARCHAR(100),
    purchase_date DATE,
    calibration_date DATE,
    next_calibration_date DATE,
    status ENUM('active', 'maintenance', 'calibration', 'retired') DEFAULT 'active',
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Academic Department Tables (BMRIT, BTP, MLP, BCA, BBA)
CREATE TABLE academic_students (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(20) UNIQUE NOT NULL,
    user_id BIGINT,
    department_id BIGINT,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    batch_year INT,
    semester INT,
    program VARCHAR(50),
    admission_date DATE,
    graduation_date DATE,
    status ENUM('active', 'graduated', 'dropped', 'suspended') DEFAULT 'active',
    cgpa DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE academic_courses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    department_id BIGINT,
    credits INT,
    semester INT,
    course_type ENUM('core', 'elective', 'lab', 'project') DEFAULT 'core',
    description TEXT,
    prerequisites TEXT,
    instructor_id BIGINT,
    max_students INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (instructor_id) REFERENCES users(id)
);

CREATE TABLE academic_enrollments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT,
    course_id BIGINT,
    enrollment_date DATE,
    grade VARCHAR(5),
    grade_points DECIMAL(3,2),
    status ENUM('enrolled', 'completed', 'dropped', 'failed') DEFAULT 'enrolled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES academic_students(id),
    FOREIGN KEY (course_id) REFERENCES academic_courses(id),
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

CREATE TABLE academic_attendance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT,
    course_id BIGINT,
    attendance_date DATE,
    status ENUM('present', 'absent', 'late', 'excused') DEFAULT 'present',
    marked_by BIGINT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES academic_students(id),
    FOREIGN KEY (course_id) REFERENCES academic_courses(id),
    FOREIGN KEY (marked_by) REFERENCES users(id),
    UNIQUE KEY unique_attendance (student_id, course_id, attendance_date)
);

CREATE TABLE academic_assignments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    assignment_type ENUM('homework', 'project', 'quiz', 'exam') DEFAULT 'homework',
    max_marks DECIMAL(5,2),
    due_date DATETIME,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES academic_courses(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE academic_submissions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    assignment_id BIGINT,
    student_id BIGINT,
    submission_text TEXT,
    file_path VARCHAR(500),
    submitted_at TIMESTAMP,
    marks_obtained DECIMAL(5,2),
    feedback TEXT,
    graded_by BIGINT,
    graded_at TIMESTAMP,
    status ENUM('submitted', 'graded', 'late', 'missing') DEFAULT 'submitted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES academic_assignments(id),
    FOREIGN KEY (student_id) REFERENCES academic_students(id),
    FOREIGN KEY (graded_by) REFERENCES users(id),
    UNIQUE KEY unique_submission (assignment_id, student_id)
);

-- Notification Tables
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'warning', 'error', 'success') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- File Management Tables
CREATE TABLE file_uploads (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    original_filename VARCHAR(255) NOT NULL,
    stored_filename VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_by BIGINT,
    entity_type VARCHAR(50),
    entity_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(id)
);

-- Insert Initial Data
INSERT INTO departments (name, code, description) VALUES
('Agriculture', 'AGR', 'Department of Agriculture'),
('Physiotherapy', 'PHY', 'Department of Physiotherapy'),
('Bachelor of Management and Research in Information Technology', 'BMRIT', 'BMRIT Department'),
('Bachelor of Technology Program', 'BTP', 'BTP Department'),
('Master of Liberal Arts Program', 'MLP', 'MLP Department'),
('Bachelor of Computer Applications', 'BCA', 'BCA Department'),
('Bachelor of Business Administration', 'BBA', 'BBA Department');

INSERT INTO roles (name, permissions) VALUES
('Super Admin', '["all"]'),
('Department Head', '["department_manage", "user_manage", "report_view"]'),
('Faculty', '["course_manage", "student_manage", "grade_manage"]'),
('Student', '["profile_view", "course_view", "assignment_submit"]'),
('Staff', '["data_entry", "report_view"]');

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_department ON users(department_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);
CREATE INDEX idx_students_department ON academic_students(department_id);
CREATE INDEX idx_courses_department ON academic_courses(department_id);
CREATE INDEX idx_attendance_date ON academic_attendance(attendance_date);
CREATE INDEX idx_appointments_date ON physiotherapy_appointments(appointment_date);
CREATE INDEX idx_notifications_user ON notifications(user_id);
