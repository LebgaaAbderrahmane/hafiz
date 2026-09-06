-- Hafiz Database Schema
-- Version: 001_initial
-- Date: 2026-09-06

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
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
CREATE TYPE user_role AS ENUM (
  'owner', 'super_admin', 'branch_manager', 'supervisor',
  'teacher', 'assistant', 'reception', 'finance', 'parent', 'student'
);

CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
  role user_role NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, organization_id, role)
);

-- ── Students ──
CREATE TYPE student_status AS ENUM (
  'lead', 'applicant', 'active', 'suspended', 'graduated', 'withdrawn', 'archived'
);

CREATE TYPE gender AS ENUM ('male', 'female');

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
  status student_status DEFAULT 'lead',
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
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  relationship TEXT,
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
  UNIQUE(student_id, guardian_id)
);

-- ── Teachers ──
CREATE TYPE employment_status AS ENUM ('active', 'inactive', 'on_leave');

CREATE TABLE teachers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  qualifications TEXT,
  ijazah_info TEXT,
  tajwid_specialization TEXT,
  employment_status employment_status DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

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
  program_id UUID REFERENCES programs(id) ON DELETE SET NULL,
  level_id UUID REFERENCES levels(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  teacher_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  assistant_id UUID REFERENCES teachers(id) ON DELETE SET NULL,
  room TEXT,
  capacity INTEGER DEFAULT 30,
  is_active BOOLEAN DEFAULT true,
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

-- ── Attendance ──
CREATE TYPE attendance_status AS ENUM ('present', 'late', 'absent', 'excused', 'left_early');

CREATE TABLE attendance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  status attendance_status NOT NULL,
  recorded_by UUID REFERENCES users(id) ON DELETE SET NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(class_id, student_id, date)
);

-- ── Memorization Plans ──
CREATE TABLE memorization_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  target TEXT,
  daily_target INTEGER,
  weekly_target INTEGER,
  planned_completion_date DATE,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Memorization Assignments ──
CREATE TYPE assignment_status AS ENUM (
  'assigned', 'practiced', 'submitted', 'assessed', 'passed', 'needs_retry', 'cancelled'
);

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
  status assignment_status DEFAULT 'assigned',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Memorization Progress ──
CREATE TYPE memorization_status AS ENUM (
  'not_started', 'assigned', 'in_progress', 'memorized',
  'passed', 'strong', 'needs_revision', 'weak', 'relearning'
);

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

-- ── Tasmi Sessions ──
CREATE TYPE session_type AS ENUM (
  'new_memorization', 'revision', 'comprehensive_revision',
  'exam', 'placement', 'competition'
);

CREATE TYPE tasmi_outcome AS ENUM ('pass', 'needs_revision', 'fail');

CREATE TABLE tasmi_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  session_type session_type NOT NULL,
  duration_minutes INTEGER,
  accuracy_score DECIMAL(5,2),
  tajwid_score DECIMAL(5,2),
  fluency_score DECIMAL(5,2),
  pronunciation_score DECIMAL(5,2),
  confidence_score DECIMAL(5,2),
  overall_rating DECIMAL(5,2),
  outcome tasmi_outcome,
  teacher_notes TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Tasmi Errors ──
CREATE TYPE error_type AS ENUM (
  'omission', 'addition', 'substitution', 'hesitation',
  'repeated_mistake', 'tajwid_error', 'pronunciation_error',
  'stopping_error', 'starting_error'
);

CREATE TYPE error_severity AS ENUM ('minor', 'moderate', 'major');

CREATE TABLE tasmi_errors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES tasmi_sessions(id) ON DELETE CASCADE,
  surah_number INTEGER NOT NULL,
  ayah_number INTEGER NOT NULL,
  word_location TEXT,
  error_type error_type NOT NULL,
  category TEXT,
  severity error_severity DEFAULT 'moderate',
  is_resolved BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Revision Plans ──
CREATE TYPE revision_frequency AS ENUM ('daily', 'weekly', 'spaced', 'teacher_defined');

CREATE TABLE revision_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  revision_frequency revision_frequency DEFAULT 'daily',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Revision Items ──
CREATE TYPE revision_status AS ENUM ('due', 'completed', 'strong', 'weak', 'failed', 'rescheduled');

CREATE TABLE revision_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_id UUID NOT NULL REFERENCES revision_plans(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  start_surah INTEGER NOT NULL,
  start_ayah INTEGER NOT NULL,
  end_surah INTEGER NOT NULL,
  end_ayah INTEGER NOT NULL,
  status revision_status DEFAULT 'due',
  next_review_date DATE,
  last_reviewed_at TIMESTAMPTZ,
  last_score DECIMAL(5,2),
  review_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Notifications ──
CREATE TYPE notification_type AS ENUM (
  'absence', 'assignment', 'assessment', 'announcement',
  'payment', 'schedule', 'achievement', 'emergency'
);

CREATE TYPE notification_channel AS ENUM ('in_app', 'email', 'sms', 'push');

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  recipient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
  type notification_type NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB DEFAULT '{}',
  is_read BOOLEAN DEFAULT false,
  channel notification_channel DEFAULT 'in_app',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Audit Logs ──
CREATE TYPE audit_action AS ENUM ('create', 'update', 'delete', 'login', 'logout', 'permission_change');

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  actor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  action audit_action NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID,
  old_value JSONB,
  new_value JSONB,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ── Indexes ──
CREATE INDEX idx_branches_org ON branches(organization_id);
CREATE INDEX idx_user_roles_org ON user_roles(organization_id);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
CREATE INDEX idx_students_org ON students(organization_id);
CREATE INDEX idx_students_branch ON students(branch_id);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_teachers_org ON teachers(organization_id);
CREATE INDEX idx_classes_org ON classes(organization_id);
CREATE INDEX idx_classes_teacher ON classes(teacher_id);
CREATE INDEX idx_class_enrollments_class ON class_enrollments(class_id);
CREATE INDEX idx_class_enrollments_student ON class_enrollments(student_id);
CREATE INDEX idx_attendance_class ON attendance(class_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_tasmi_sessions_student ON tasmi_sessions(student_id);
CREATE INDEX idx_tasmi_sessions_teacher ON tasmi_sessions(teacher_id);
CREATE INDEX idx_revision_items_student ON revision_items(student_id);
CREATE INDEX idx_revision_items_status ON revision_items(status);
CREATE INDEX idx_notifications_recipient ON notifications(recipient_id);
CREATE INDEX idx_audit_logs_org ON audit_logs(organization_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);

-- ── Updated At Trigger ──
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
CREATE TRIGGER update_revision_plans_updated_at BEFORE UPDATE ON revision_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_revision_items_updated_at BEFORE UPDATE ON revision_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
