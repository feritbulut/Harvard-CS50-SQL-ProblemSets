/* 1. DAILY DOCTOR SCHEDULE
  Retrieves all scheduled appointments for a specific doctor on a given day.
  Essential for the "Doctor's Dashboard" view.
*/
SELECT
    a.appointment_time,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.phone_number,
    a.status,
    a.notes
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.doctor_id = 'your-doctor-uuid-here'
  AND a.appointment_time::DATE = '2025-12-23' -- Replace with current date
ORDER BY a.appointment_time ASC;

/* 2. COMPREHENSIVE PATIENT MEDICAL HISTORY
  Fetches all past diagnoses and treatments for a patient.
  We join medical_records with doctors to see who provided the care.
*/
SELECT
    mr.recorded_at AS visit_date,
    d.first_name || ' ' || d.last_name AS treated_by,
    mr.symptoms,
    mr.diagnosis,
    mr.treatment_plan,
    mr.prescriptions -- This is the JSONB column
FROM medical_records mr
JOIN doctors d ON mr.doctor_id = d.id
WHERE mr.patient_id = 'your-patient-uuid-here'
ORDER BY mr.recorded_at DESC;

/* 3. CLINIC PERFORMANCE ANALYTICS (Management View)
  Calculates total appointments and "No Show" rates per clinic.
  Uses a CASE statement to calculate a specific metric inside a COUNT.
*/
SELECT
    c.name AS clinic_name,
    COUNT(a.id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'no_show' THEN 1 END) AS no_show_count,
    ROUND(100.0 * COUNT(CASE WHEN a.status = 'no_show' THEN 1 END) / COUNT(a.id), 2) AS no_show_rate_percentage
FROM clinics c
JOIN doctors d ON c.id = d.clinic_id
JOIN appointments a ON d.id = a.doctor_id
GROUP BY c.id, c.name
ORDER BY total_appointments DESC;

/* 4. ADVANCED PRESCRIPTION SEARCH (JSONB Querying)
  Finding all patients who were prescribed a specific medication (e.g., 'Arveles').
  The @> operator checks if the JSONB array contains a specific object.
*/
SELECT
    p.first_name,
    p.last_name,
    mr.diagnosis,
    mr.recorded_at
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.id
WHERE mr.prescriptions @> '[{"name": "Arveles"}]';

/* 5. SECURITY AUDIT TRAIL
  Check who modified a patient's medical record in the last 24 hours.
  Crucial for HIPAA/GDPR compliance investigations.
*/
SELECT
    executed_by AS staff_member,
    action_type,
    changed_at,
    old_data ->> 'diagnosis' AS previous_diagnosis,
    new_data ->> 'diagnosis' AS updated_diagnosis
FROM audit_logs
WHERE table_name = 'medical_records'
  AND changed_at > NOW() - INTERVAL '24 hours'
ORDER BY changed_at DESC;

/* 6. IDENTIFYING "RECURRING" PATIENTS
  Finds patients who have booked more than 3 appointments in the last month.
  Useful for identifying chronic cases or system abuse.
*/
SELECT
    p.id,
    p.first_name,
    p.last_name,
    COUNT(a.id) as visit_count
FROM patients p
JOIN appointments a ON p.id = a.patient_id
WHERE a.appointment_time > NOW() - INTERVAL '30 days'
GROUP BY p.id
HAVING COUNT(a.id) > 3;
