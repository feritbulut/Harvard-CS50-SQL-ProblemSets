-- IMPORTANT: SQLite requires foreign keys to be enabled manually per connection
PRAGMA foreign_keys = ON;

-- 1. CLINICS
CREATE TABLE clinics (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    floor_level INTEGER NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. DOCTORS
CREATE TABLE doctors (
    id TEXT PRIMARY KEY,
    clinic_id TEXT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    title TEXT DEFAULT 'MD',
    specialization TEXT,
    email TEXT UNIQUE NOT NULL,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON DELETE RESTRICT
);

-- 3. DOCTOR_SCHEDULES
CREATE TABLE doctor_schedules (
    id TEXT PRIMARY KEY,
    doctor_id TEXT,
    day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    slot_duration_minutes INTEGER DEFAULT 15,
    UNIQUE(doctor_id, day_of_week),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- 4. PATIENTS
CREATE TABLE patients (
    id TEXT PRIMARY KEY,
    national_id TEXT UNIQUE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth TEXT NOT NULL,
    gender TEXT CHECK (gender IN ('M', 'F', 'O')),
    blood_type TEXT CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    phone_number TEXT NOT NULL,
    emergency_contact_phone TEXT,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 5. APPOINTMENTS
CREATE TABLE appointments (
    id TEXT PRIMARY KEY,
    patient_id TEXT,
    doctor_id TEXT,
    appointment_time DATETIME NOT NULL,
    status TEXT DEFAULT 'scheduled'
        CHECK (status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(doctor_id, appointment_time),
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- 6. MEDICAL_RECORDS
CREATE TABLE medical_records (
    id TEXT PRIMARY KEY,
    appointment_id TEXT UNIQUE,
    patient_id TEXT,
    doctor_id TEXT,
    symptoms TEXT,
    diagnosis TEXT NOT NULL,
    treatment_plan TEXT,
    prescriptions TEXT DEFAULT '[]',
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- 7. AUDIT_LOGS
CREATE TABLE audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    action_type TEXT NOT NULL,
    record_id TEXT NOT NULL,
    executed_by TEXT,
    old_data TEXT,
    new_data TEXT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
