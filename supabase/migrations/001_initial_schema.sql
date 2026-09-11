-- Hafiz Database Schema
-- Version: 002_full_rewrite
-- Date: 2026-09-11

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ──────────────────────────────────────────────
-- ENUM TYPES
-- ──────────────────────────────────────────────

CREATE TYPE user_role AS ENUM (
  'owner', 'super_admin', 'branch_manager', 'supervisor',
  'teacher', 'assistant', 'reception', 'finance', 'parent', 'student'
);

CREATE TYPE student_status AS ENUM (
  'lead', 'applicant', 'active', 'suspended', 'graduated', 'withdrawn', 'archived'
);

CREATE TYPE gender AS ENUM ('male', 'female');

CREATE TYPE teacher_status AS ENUM ('active', 'on_leave', 'inactive', 'terminated');

CREATE TYPE class_status AS ENUM ('active', 'inactive', 'completed', 'cancelled');

CREATE TYPE attendance_status AS ENUM ('present', 'late', 'absent', 'excused', 'left_early');

CREATE TYPE assignment_status AS ENUM (
  'pending', 'in_progress', 'completed', 'overdue', 'cancelled'
);

CREATE TYPE memorization_status AS ENUM (
  'not_started', 'in_progress', 'paused', 'completed', 'cancelled'
);

CREATE TYPE memorization_priority AS ENUM ('low', 'medium', 'high');

CREATE TYPE checkpoint_status AS ENUM (
  'pending', 'in_progress', 'completed', 'needs_revision'
);

CREATE TYPE tasmi_session_type AS ENUM (
  'new_memorization', 'revision', 'comprehensive_revision',
  'exam', 'placement', 'competition'
);

CREATE TYPE tasmi_outcome AS ENUM ('pass', 'needs_revision', 'fail');

CREATE TYPE error_type AS ENUM (
  'omission', 'addition', 'substitution', 'hesitation',
  'repeated_mistake', 'tajwid_error', 'pronunciation_error',
  'stopping_error', 'starting_error'
);

CREATE TYPE error_severity AS ENUM ('minor', 'moderate', 'major');

CREATE TYPE revision_status AS ENUM (
  'pending', 'due', 'overdue', 'in_progress', 'completed', 'needs_revision'
);

CREATE TYPE revision_priority AS ENUM ('low', 'medium', 'high', 'urgent');

CREATE TYPE schedule_session_type AS ENUM (
  'class_session', 'tasmi', 'revision', 'exam', 'makeup', 'other'
);

CREATE TYPE schedule_session_status AS ENUM (
  'scheduled', 'in_progress', 'completed', 'cancelled', 'rescheduled'
);

CREATE TYPE event_type AS ENUM (
  'class_session', 'tasmi', 'exam', 'meeting', 'holiday', 'other'
);

CREATE TYPE event_status AS ENUM (
  'scheduled', 'in_progress', 'completed', 'cancelled', 'rescheduled'
);

CREATE TYPE notification_type AS ENUM (
  'attendance', 'memorization', 'tasmi', 'assignment',
  'schedule', 'report', 'system', 'reminder'
);

CREATE TYPE report_type AS ENUM (
  'attendance', 'memorization_progress', 'tasmi_summary',
  'student_performance', 'teacher_performance', 'class_overview', 'custom'
);

CREATE TYPE report_format AS ENUM ('pdf', 'csv', 'excel');

CREATE TYPE revelation_type AS ENUM ('meccan', 'medinan');

-- ──────────────────────────────────────────────
-- CORE TABLES
-- ──────────────────────────────────────────────

-- ── Organizations ──
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Branches ──
CREATE TABLE branches (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  address TEXT,
  phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Users ──
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT,
  phone TEXT,
  full_name TEXT NOT NULL,
  preferred_name TEXT,
  avatar_url TEXT,
  language TEXT DEFAULT 'ar',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── User Roles ──
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  role user_role NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, organization_id, role)
);

-- ──────────────────────────────────────────────
-- PEOPLE TABLES
-- ──────────────────────────────────────────────

-- ── Students ──
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  student_id TEXT,
  full_name TEXT NOT NULL,
  preferred_name TEXT,
  gender gender,
  date_of_birth DATE,
  avatar_url TEXT,
  nationality TEXT,
  language TEXT DEFAULT 'ar',
  phone TEXT,
  email TEXT,
  status student_status DEFAULT 'active',
  previous_quran_education TEXT,
  current_quran_level TEXT,
  reading_level TEXT,
  tajwid_level TEXT,
  memorization_level TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Guardians ──
CREATE TABLE guardians (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  address TEXT,
  occupation TEXT,
  relationship TEXT,
  type TEXT,
  notes TEXT,
  is_emergency_contact BOOLEAN DEFAULT false,
  communication_preference TEXT DEFAULT 'sms',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Student-Guardian Link ──
CREATE TABLE student_guardians (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  guardian_id UUID NOT NULL REFERENCES guardians(id) ON DELETE CASCADE,
  is_primary BOOLEAN DEFAULT false,
  relationship TEXT,
  UNIQUE(student_id, guardian_id)
);

-- ── Teachers ──
CREATE TABLE teachers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  employee_id TEXT,
  full_name TEXT NOT NULL,
  preferred_name TEXT,
  gender gender,
  date_of_birth DATE,
  avatar_url TEXT,
  nationality TEXT,
  phone TEXT,
  email TEXT,
  specialization TEXT,
  qualifications TEXT[] DEFAULT '{}',
  certifications TEXT[] DEFAULT '{}',
  languages_spoken TEXT[] DEFAULT '{}',
  status teacher_status DEFAULT 'active',
  hire_date DATE,
  termination_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- PROGRAM / LEVEL / CLASS TABLES
-- ──────────────────────────────────────────────

-- ── Programs ──
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Levels ──
CREATE TABLE levels (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  "order" INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Classes ──
CREATE TABLE classes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  room_id TEXT,
  teacher_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  level TEXT,
  days_of_week TEXT[] DEFAULT '{}',
  start_time TEXT,
  end_time TEXT,
  max_capacity INTEGER DEFAULT 30,
  status class_status DEFAULT 'active',
  start_date DATE,
  end_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Class Enrollments ──
CREATE TABLE class_enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  status TEXT DEFAULT 'active',
  UNIQUE(class_id, student_id)
);

-- ── Schedules ──
CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- ATTENDANCE
-- ──────────────────────────────────────────────

CREATE TABLE attendance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  session_id UUID,
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  status attendance_status NOT NULL,
  check_in_time TEXT,
  check_out_time TEXT,
  notes TEXT,
  marked_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(class_id, student_id, date)
);

-- ──────────────────────────────────────────────
-- QURAN / MEMORIZATION
-- ──────────────────────────────────────────────

-- ── Quran Surahs (reference data) ──
CREATE TABLE quran_surahs (
  number INTEGER PRIMARY KEY,
  name_arabic TEXT NOT NULL,
  name_english TEXT NOT NULL,
  name_transliteration TEXT NOT NULL,
  total_ayahs INTEGER NOT NULL,
  revelation_type revelation_type NOT NULL,
  juz INTEGER NOT NULL,
  hizb INTEGER,
  page INTEGER,
  description TEXT
);

-- ── Quran Juz (reference data) ──
CREATE TABLE quran_juz (
  number INTEGER PRIMARY KEY,
  name_arabic TEXT NOT NULL,
  name_english TEXT NOT NULL,
  start_page INTEGER NOT NULL,
  end_page INTEGER NOT NULL,
  surah_numbers INTEGER[] NOT NULL,
  total_ayahs INTEGER NOT NULL
);

-- ── Memorization Plans ──
CREATE TABLE memorization_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  status memorization_status NOT NULL DEFAULT 'not_started',
  priority memorization_priority NOT NULL DEFAULT 'medium',
  current_surah INTEGER NOT NULL DEFAULT 1,
  current_ayah INTEGER NOT NULL DEFAULT 1,
  target_surah INTEGER NOT NULL DEFAULT 1,
  target_ayah INTEGER NOT NULL DEFAULT 1,
  notes TEXT,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Memorization Checkpoints ──
CREATE TABLE memorization_checkpoints (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_id UUID NOT NULL REFERENCES memorization_plans(id) ON DELETE CASCADE,
  surah_number INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  status checkpoint_status NOT NULL DEFAULT 'pending',
  quality_score INTEGER,
  teacher_notes TEXT,
  completed_at TIMESTAMPTZ
);

-- ── Memorization Session Logs ──
CREATE TABLE memorization_session_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_id UUID NOT NULL REFERENCES memorization_plans(id) ON DELETE CASCADE,
  date TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER NOT NULL,
  from_surah INTEGER NOT NULL,
  from_ayah INTEGER NOT NULL,
  to_surah INTEGER NOT NULL,
  to_ayah INTEGER NOT NULL,
  quality_score INTEGER,
  notes TEXT
);

-- ── Memorization Assignments ──
CREATE TABLE memorization_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  due_date DATE,
  expected_quality TEXT,
  notes TEXT,
  status assignment_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Memorization Progress ──
CREATE TABLE memorization_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  status memorization_status DEFAULT 'not_started',
  first_memorized_at DATE,
  last_assessed_at DATE,
  assessment_score DECIMAL(5,2),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Hifz Assignments (Phase 11) ──
CREATE TABLE hifz_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  type TEXT NOT NULL DEFAULT 'new_memorization',
  status assignment_status NOT NULL DEFAULT 'pending',
  due_date TIMESTAMPTZ,
  notes TEXT,
  quality_target INTEGER,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- TASMI
-- ──────────────────────────────────────────────

CREATE TABLE tasmi_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  session_id UUID,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  session_type tasmi_session_type NOT NULL,
  outcome tasmi_outcome,
  accuracy_score INTEGER,
  tajwid_score INTEGER,
  fluency_score INTEGER,
  overall_rating INTEGER,
  teacher_notes TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tasmi_errors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES tasmi_sessions(id) ON DELETE CASCADE,
  surah_number INTEGER NOT NULL,
  ayah_number INTEGER NOT NULL,
  word_location TEXT,
  error_type error_type NOT NULL,
  severity error_severity DEFAULT 'moderate',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- REVISION
-- ──────────────────────────────────────────────

CREATE TABLE revisions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  surah_number INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  status revision_status NOT NULL DEFAULT 'pending',
  priority revision_priority NOT NULL DEFAULT 'medium',
  due_date TIMESTAMPTZ,
  completed_date TIMESTAMPTZ,
  quality_score INTEGER,
  review_count INTEGER DEFAULT 0,
  last_reviewed_at TIMESTAMPTZ,
  next_review_at TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- SCHEDULE / EVENTS
-- ──────────────────────────────────────────────

CREATE TABLE schedule_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  type schedule_session_type NOT NULL,
  date TIMESTAMPTZ NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  student_ids UUID[] DEFAULT '{}',
  location TEXT,
  status schedule_session_status DEFAULT 'scheduled',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE schedule_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  event_type event_type NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  location TEXT,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  teacher_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  student_ids UUID[] DEFAULT '{}',
  recurrence_days TEXT[] DEFAULT '{}',
  recurrence_end_date TEXT,
  status event_status DEFAULT 'scheduled',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- NOTIFICATIONS
-- ──────────────────────────────────────────────

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type notification_type NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB DEFAULT '{}',
  action_url TEXT,
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- REPORTS
-- ──────────────────────────────────────────────

CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  generated_by_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type report_type NOT NULL,
  title TEXT NOT NULL,
  parameters JSONB DEFAULT '{}',
  data JSONB DEFAULT '{}',
  format report_format,
  file_path TEXT,
  generated_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- AUDIT LOGS
-- ──────────────────────────────────────────────

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID,
  old_value JSONB,
  new_value JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ──────────────────────────────────────────────
-- INDEXES
-- ──────────────────────────────────────────────

CREATE INDEX idx_branches_org ON branches(organization_id);
CREATE INDEX idx_user_roles_org ON user_roles(organization_id);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_students_org ON students(organization_id);
CREATE INDEX idx_students_branch ON students(branch_id);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_teachers_org ON teachers(organization_id);
CREATE INDEX idx_teachers_user ON teachers(user_id);
CREATE INDEX idx_classes_org ON classes(organization_id);
CREATE INDEX idx_classes_teacher ON classes(teacher_id);
CREATE INDEX idx_class_enrollments_class ON class_enrollments(class_id);
CREATE INDEX idx_class_enrollments_student ON class_enrollments(student_id);
CREATE INDEX idx_attendance_class ON attendance(class_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_memorization_plans_student ON memorization_plans(student_id);
CREATE INDEX idx_memorization_assignments_student ON memorization_assignments(student_id);
CREATE INDEX idx_hifz_assignments_student ON hifz_assignments(student_id);
CREATE INDEX idx_hifz_assignments_teacher ON hifz_assignments(teacher_id);
CREATE INDEX idx_tasmi_sessions_student ON tasmi_sessions(student_id);
CREATE INDEX idx_tasmi_sessions_teacher ON tasmi_sessions(teacher_id);
CREATE INDEX idx_revisions_student ON revisions(student_id);
CREATE INDEX idx_revisions_status ON revisions(status);
CREATE INDEX idx_schedule_sessions_class ON schedule_sessions(class_id);
CREATE INDEX idx_schedule_events_org ON schedule_events(organization_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_reports_org ON reports(organization_id);
CREATE INDEX idx_audit_logs_org ON audit_logs(organization_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);

-- ──────────────────────────────────────────────
-- UPDATED AT TRIGGER
-- ──────────────────────────────────────────────

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_organizations_updated_at BEFORE UPDATE ON organizations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_branches_updated_at BEFORE UPDATE ON branches FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_guardians_updated_at BEFORE UPDATE ON guardians FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_teachers_updated_at BEFORE UPDATE ON teachers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_classes_updated_at BEFORE UPDATE ON classes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_attendance_updated_at BEFORE UPDATE ON attendance FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_memorization_plans_updated_at BEFORE UPDATE ON memorization_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_memorization_assignments_updated_at BEFORE UPDATE ON memorization_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_memorization_progress_updated_at BEFORE UPDATE ON memorization_progress FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasmi_sessions_updated_at BEFORE UPDATE ON tasmi_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_revisions_updated_at BEFORE UPDATE ON revisions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_schedule_sessions_updated_at BEFORE UPDATE ON schedule_sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_schedule_events_updated_at BEFORE UPDATE ON schedule_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_hifz_assignments_updated_at BEFORE UPDATE ON hifz_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
