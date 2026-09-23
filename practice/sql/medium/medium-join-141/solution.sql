-- Xom Data · Consultation revenue by doctor
-- Problem: https://xomdata.com/practice/medium-join-141
-- Solved: 2026-09-23

WITH med_visit_stats AS (
    SELECT
        doctor_id,
        COUNT(*) AS visit_count, 
        ROUND(AVG(COALESCE(visit_fee, 0)), 2) AS avg_exam_fee,
        SUM(COALESCE(visit_fee, 0)) AS total_exam_fee
    FROM medical_visits
    GROUP BY doctor_id
),
doctors_summary AS (
    SELECT 
        f.faculty_name,
        d.full_name AS doctor_name,
        mvs.visit_count,
        mvs.avg_exam_fee,
        mvs.total_exam_fee,
        RANK() OVER (
            ORDER BY total_exam_fee DESC
        ) AS overall_rank,
        DENSE_RANK() OVER (
            PARTITION BY f.id
            ORDER BY total_exam_fee DESC
        ) AS rank_in_faculty
    FROM doctors d
        LEFT JOIN faculties f ON d.faculty_id = f.id
        JOIN med_visit_stats mvs ON mvs.doctor_id = d.id
) 
SELECT
    faculty_name,
    doctor_name,
    visit_count,
    avg_exam_fee,
    total_exam_fee,
    overall_rank,
    rank_in_faculty
FROM doctors_summary
ORDER BY total_exam_fee DESC, doctor_name ASC
LIMIT 15
