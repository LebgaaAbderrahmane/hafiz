-- Hafiz Seed Data
-- Date: 2026-09-11

-- ── Test Organization ──
INSERT INTO organizations (id, name, slug) VALUES
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Hafiz Academy', 'hafiz-academy');

-- ── Test Branches ──
INSERT INTO branches (id, organization_id, name, address, phone) VALUES
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Main Branch', '123 Qur''an Street, Algiers', '+213-555-0101'),
  ('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Branch 2', '456 Islamic Ave, Oran', '+213-555-0102');

-- ── Test Users ──
-- Admin user (create in Supabase Auth first, then insert here with same UUID)
-- For now we insert placeholder UUIDs; real auth users will be created via Supabase Studio
INSERT INTO users (id, email, full_name, language) VALUES
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'admin@hafiz.com', 'Admin User', 'ar'),
  ('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'teacher1@hafiz.com', 'Ahmed Al-Qari', 'ar'),
  ('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'teacher2@hafiz.com', 'Fatima Al-Mustafa', 'ar');

-- ── User Roles ──
INSERT INTO user_roles (user_id, organization_id, branch_id, role) VALUES
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NULL, 'owner'),
  ('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'teacher'),
  ('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'teacher');

-- ── Teachers ──
INSERT INTO teachers (id, user_id, organization_id, branch_id, full_name, status, qualifications) VALUES
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Ahmed Al-Qari', 'active', ARRAY['Hifz', 'Tajwid']),
  ('d1eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Fatima Al-Mustafa', 'active', ARRAY['Qira''at', 'Tajwid']);

-- ── Students ──
INSERT INTO students (id, organization_id, branch_id, full_name, gender, status, current_quran_level) VALUES
  ('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Omar Benali', 'male', 'active', 'Intermediate'),
  ('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Youssef Hamidi', 'male', 'active', 'Beginner'),
  ('e2eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Amina Khelifi', 'female', 'active', 'Advanced'),
  ('e3eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Mohamed Saidi', 'male', 'active', 'Intermediate'),
  ('e4eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Salima Boudiaf', 'female', 'lead', NULL);

-- ── Guardians ──
INSERT INTO guardians (id, organization_id, branch_id, full_name, phone, relationship) VALUES
  ('f0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Karim Benali', '+213-555-0201', 'father'),
  ('f1eebc99-9c0b-4ef8-bb6d-6bb9bd380c22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Nadia Hamidi', '+213-555-0202', 'mother');

-- ── Student-Guardian Links ──
INSERT INTO student_guardians (student_id, guardian_id, is_primary, relationship) VALUES
  ('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', true, 'father'),
  ('e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'f1eebc99-9c0b-4ef8-bb6d-6bb9bd380c22', true, 'mother');

-- ── Programs ──
INSERT INTO programs (id, organization_id, name, description) VALUES
  ('a1eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Hifz Program', 'Qur''an memorization program'),
  ('a2eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tajwid Program', 'Qur''an recitation with proper tajwid');

-- ── Classes ──
INSERT INTO classes (id, organization_id, branch_id, name, description, teacher_id, level, days_of_week, start_time, end_time, max_capacity, status) VALUES
  ('a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Hifz Level 1', 'Beginner memorization class', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'Beginner', ARRAY['Saturday', 'Sunday', 'Tuesday'], '09:00', '11:00', 20, 'active'),
  ('a4eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Tajwid Advanced', 'Advanced tajwid and qira''at', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'Advanced', ARRAY['Monday', 'Wednesday'], '14:00', '16:00', 15, 'active');

-- ── Class Enrollments ──
INSERT INTO class_enrollments (class_id, student_id) VALUES
  ('a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99'),
  ('a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11'),
  ('a4eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'e2eebc99-9c0b-4ef8-bb6d-6bb9bd380b22');

-- ── Quran Surahs (subset: first 10) ──
INSERT INTO quran_surahs (number, name_arabic, name_english, name_transliteration, total_ayahs, revelation_type, juz, hizb, page) VALUES
  (1, 'الفاتحة', 'The Opening', 'Al-Fatiha', 7, 'meccan', 1, 1, 1),
  (2, 'البقرة', 'The Cow', 'Al-Baqara', 286, 'medinan', 1, 1, 2),
  (3, 'آل عمران', 'Family of Imran', 'Ali Imran', 200, 'medinan', 3, 1, 50),
  (4, 'النساء', 'The Women', 'An-Nisa', 176, 'medinan', 4, 1, 77),
  (5, 'المائدة', 'The Table Spread', 'Al-Maida', 120, 'medinan', 6, 1, 106),
  (6, 'الأنعام', 'The Cattle', 'Al-Anam', 165, 'meccan', 7, 1, 128),
  (7, 'الأعراف', 'The Heights', 'Al-Araf', 206, 'meccan', 8, 1, 151),
  (8, 'الأنفال', 'The Spoils of War', 'Al-Anfal', 75, 'medinan', 9, 1, 177),
  (9, 'التوبة', 'The Repentance', 'At-Tawba', 129, 'medinan', 10, 1, 187),
  (10, 'يونس', 'Jonah', 'Yunus', 109, 'meccan', 11, 1, 208);

-- ── Quran Juz (subset: first 5) ──
INSERT INTO quran_juz (number, name_arabic, name_english, start_page, end_page, surah_numbers, total_ayahs) VALUES
  (1, 'الجزء 1', 'Juz 1', 1, 21, ARRAY[1, 2], 21),
  (2, 'الجزء 2', 'Juz 2', 22, 41, ARRAY[2], 21),
  (3, 'الجزء 3', 'Juz 3', 42, 61, ARRAY[2, 3], 21),
  (4, 'الجزء 4', 'Juz 4', 62, 81, ARRAY[3, 4], 21),
  (5, 'الجزء 5', 'Juz 5', 82, 101, ARRAY[4, 5], 21);

-- ── Memorization Plans ──
INSERT INTO memorization_plans (id, student_id, teacher_id, organization_id, class_id, status, priority, current_surah, current_ayah, target_surah, target_ayah) VALUES
  ('aaeebc99-9c0b-4ef8-bb6d-6bb9bd380e11', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'in_progress', 'high', 2, 28, 2, 50),
  ('abeebc99-9c0b-4ef8-bb6d-6bb9bd380e22', 'e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'not_started', 'medium', 1, 1, 1, 7);

-- ── Hifz Assignments ──
INSERT INTO hifz_assignments (id, organization_id, branch_id, student_id, teacher_id, start_surah, start_ayah, end_surah, end_ayah, type, status, due_date) VALUES
  ('abeebc99-9c0b-4ef8-bb6d-6bb9bd380f11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 2, 1, 2, 10, 'new_memorization', 'in_progress', NOW() + INTERVAL '7 days'),
  ('abeebc99-9c0b-4ef8-bb6d-6bb9bd380f22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 1, 1, 1, 7, 'new_memorization', 'pending', NOW() + INTERVAL '14 days'),
  ('abeebc99-9c0b-4ef8-bb6d-6bb9bd380f33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e2eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 3, 1, 3, 20, 'revision', 'completed', NOW() - INTERVAL '2 days');

-- ── Tasmi Sessions ──
INSERT INTO tasmi_sessions (id, organization_id, branch_id, student_id, teacher_id, class_id, start_surah, start_ayah, end_surah, end_ayah, session_type, outcome, accuracy_score, tajwid_score, fluency_score, overall_rating, teacher_notes, recorded_at) VALUES
  ('ac0eebc9-9c0b-4ef8-bb6d-6bb9bd380a11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 1, 1, 1, 7, 'new_memorization', 'pass', 85, 80, 90, 85, 'Good recitation, minor tajwid issues', NOW() - INTERVAL '3 days'),
  ('ac0eebc9-9c0b-4ef8-bb6d-6bb9bd380a22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e2eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'a4eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 3, 1, 3, 10, 'revision', 'needs_revision', 70, 65, 75, 70, 'Needs more practice on ghunnah', NOW() - INTERVAL '1 day');

-- ── Attendance ──
INSERT INTO attendance (organization_id, branch_id, student_id, class_id, date, status, check_in_time, marked_by) VALUES
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', CURRENT_DATE - INTERVAL '1 day', 'present', '09:00', 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', CURRENT_DATE - INTERVAL '1 day', 'late', '09:15', 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', CURRENT_DATE, 'present', '09:00', 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'e1eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', CURRENT_DATE, 'absent', NULL, 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a55');

-- ── Schedule Sessions ──
INSERT INTO schedule_sessions (id, organization_id, branch_id, title, type, date, start_time, end_time, class_id, teacher_id, status) VALUES
  ('ad0eebc9-9c0b-4ef8-bb6d-6bb9bd380a11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Hifz Session - Level 1', 'class_session', CURRENT_DATE + INTERVAL '1 day', '09:00', '11:00', 'a3eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'scheduled'),
  ('ad0eebc9-9c0b-4ef8-bb6d-6bb9bd380a22', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Tajwid Session - Advanced', 'class_session', CURRENT_DATE + INTERVAL '2 days', '14:00', '16:00', 'a4eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'd1eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'scheduled');
