# Design Document: Professional Hospital Management System (HMS)

**Author:** Ferit Bulut
**Project Version:** 1.0.0
**Date:** 2025-12-23

**youube Video: https://youtu.be/6mFaWdqOW6s

## 1. Scope

### Purpose
The purpose of this database is to provide a robust, scalable, and secure infrastructure for managing patient-doctor interactions, medical record keeping, and clinical audit trails. It is designed to handle high-concurrency environments while maintaining strict data integrity.

### In-Scope
* **Organizational Hierarchy:** Management of Clinics and Doctors.
* **Scheduling:** Defining doctor work hours and managing appointment slots.
* **Patient Management:** Comprehensive patient demographics and contact details.
* **Clinical Documentation:** Storage of diagnoses, symptoms, and prescriptions (using JSONB for flexibility).
* **Security & Compliance:** Audit logging of all sensitive data modifications.

### Out-of-Scope
* Financial accounting, billing, and insurance claim processing.
* Pharmacy inventory and real-time medicine stock tracking.
* HR systems (Payroll, shift management for nurses/staff).
* Large-scale medical imaging storage (e.g., raw MRI/CT scan files).

---

## 2. Functional Requirements

### User Capabilities
* **Administrative Staff:** Can register patients and manage appointment bookings without viewing sensitive medical notes.
* **Doctors:** Can view patient history, record clinical findings, and issue digital prescriptions.
* **System Auditors:** Can review the `audit_logs` to track unauthorized or accidental changes to medical records.
* **Patients (via API):** Can query their own upcoming appointments and past medical history.

### Constraints & Limitations
* The system prevents double-booking for doctors at the database level.
* Medical records cannot be deleted; they can only be updated, with every change tracked in audit logs.
* National IDs must be unique and follow a strict 11-character format.

---

## 3. Representation

### Entities

```mermaid
flowchart TD
    %% Clinics to Doctors
    C[Clinics] -->|One-to-Many| D(Doctors)
    D -->|Foreign Key| FK1[clinic_id]

    %% Doctors to Schedules
    D -->|One-to-Many| S{Schedules}
    S -->|Foreign Key| FK2[doctor_id]

    %% Appointments Hub
    D -->|One-to-Many| A[Appointments]
    P[Patients] -->|One-to-Many| A
    A -->|Foreign Key| FK3[doctor_id & patient_id]

    %% Appointments to Medical Records
    A -->|One-to-One| MR[Medical Records]
    MR -->|Foreign Key| FK4[appointment_id]

    %% Audit Logging
    MR -->|One-to-Many| AL[Audit Logs]
    A -->|One-to-Many| AL
    AL -->|Foreign Key| FK5[record_id]
    ```

### Relationships



* **One-to-Many:** One Clinic has many Doctors.
* **One-to-Many:** One Doctor has many Appointments.
* **One-to-Many:** One Patient has many Appointments.
* **One-to-One:** One Appointment results in exactly one Medical Record.
* **Many-to-Many (Conceptual):** Doctors and Patients are linked through the Appointments table.

---

## 4. Optimizations

### Indexes
* `idx_appointment_time`: A B-Tree index on `appointments(appointment_time)` to optimize daily schedule lookups.
* `idx_patient_search`: A unique index on `patients(national_id)` for O(1) complexity searches.
* `gin_prescriptions_search`: A GIN (Generalized Inverted Index) on `medical_records(prescriptions)` to allow efficient querying inside JSON medication data.

### Database Views
* `vw_clinic_daily_stats`: Aggregates appointment counts and no-show rates per clinic to provide real-time management insights without calculating on-the-fly.
* `vw_secure_patient_list`: Provides patient contact info while excluding sensitive medical data for use by administrative staff.

---

## 5. Limitations
* **Binary Data:** The database is not an Image Archive (PACS). It stores references (URLs/Paths) to medical images stored on external Object Storage (like AWS S3).
* **High-Volume Concurrency:** In extreme cases (100k+ concurrent users), the unique constraint on appointments may lead to database contention; a Redis-based locking mechanism might be required in the future.
* **Hard Deletes:** The current design uses `ON DELETE RESTRICT` for most relations to ensure historical medical data is never lost, which may lead to database growth over time requiring partitioning.
