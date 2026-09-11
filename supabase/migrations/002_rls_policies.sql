-- RLS Policies for Hafiz
-- Date: 2026-09-11

-- Enable RLS on all tables
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE guardians ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_guardians ENABLE ROW LEVEL SECURITY;
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE class_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE quran_surahs ENABLE ROW LEVEL SECURITY;
ALTER TABLE quran_juz ENABLE ROW LEVEL SECURITY;
ALTER TABLE memorization_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE memorization_checkpoints ENABLE ROW LEVEL SECURITY;
ALTER TABLE memorization_session_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE memorization_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE memorization_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE hifz_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasmi_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasmi_errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE revisions ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedule_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedule_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Helper function: get current user's role for an org
CREATE OR REPLACE FUNCTION get_user_role(org_id UUID)
RETURNS user_role AS $$
  SELECT role FROM user_roles
  WHERE user_id = auth.uid() AND organization_id = org_id
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if user belongs to org
CREATE OR REPLACE FUNCTION belongs_to_org(org_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = auth.uid() AND organization_id = org_id
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ── Organizations: users can read their own orgs ──
CREATE POLICY "Users can view own organizations"
  ON organizations FOR SELECT
  USING (belongs_to_org(id));

-- ── Branches: users can read branches in their orgs ──
CREATE POLICY "Users can view org branches"
  ON branches FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Users: users can read profiles in their orgs ──
CREATE POLICY "Users can view org users"
  ON users FOR SELECT
  USING (
    id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM user_roles ur1
      JOIN user_roles ur2 ON ur1.organization_id = ur2.organization_id
      WHERE ur1.user_id = auth.uid() AND ur2.user_id = users.id
    )
  );

-- ── User Roles ──
CREATE POLICY "Users can view org roles"
  ON user_roles FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Students: org isolation ──
CREATE POLICY "Users can view org students"
  ON students FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can insert students"
  ON students FOR INSERT
  WITH CHECK (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

CREATE POLICY "Teachers can update students"
  ON students FOR UPDATE
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Guardians: org isolation ──
CREATE POLICY "Users can view org guardians"
  ON guardians FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage guardians"
  ON guardians FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Student-Guardian Links ──
CREATE POLICY "Users can view org student_guardians"
  ON student_guardians FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM students s
      WHERE s.id = student_guardians.student_id AND belongs_to_org(s.organization_id)
    )
  );

-- ── Teachers: org isolation ──
CREATE POLICY "Users can view org teachers"
  ON teachers FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Classes: org isolation ──
CREATE POLICY "Users can view org classes"
  ON classes FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage classes"
  ON classes FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager')
  );

-- ── Class Enrollments ──
CREATE POLICY "Users can view org enrollments"
  ON class_enrollments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM classes c
      WHERE c.id = class_enrollments.class_id AND belongs_to_org(c.organization_id)
    )
  );

-- ── Attendance: org isolation ──
CREATE POLICY "Users can view org attendance"
  ON attendance FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage attendance"
  ON attendance FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Quran Reference Data: public read ──
CREATE POLICY "Anyone can read surahs"
  ON quran_surahs FOR SELECT USING (true);

CREATE POLICY "Anyone can read juz"
  ON quran_juz FOR SELECT USING (true);

-- ── Memorization Plans: org isolation ──
CREATE POLICY "Users can view org memorization_plans"
  ON memorization_plans FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Memorization Assignments: org isolation ──
CREATE POLICY "Users can view org memorization_assignments"
  ON memorization_assignments FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Memorization Progress: org isolation ──
CREATE POLICY "Users can view org memorization_progress"
  ON memorization_progress FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Hifz Assignments: org isolation ──
CREATE POLICY "Users can view org hifz_assignments"
  ON hifz_assignments FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage hifz_assignments"
  ON hifz_assignments FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Tasmi Sessions: org isolation ──
CREATE POLICY "Users can view org tasmi_sessions"
  ON tasmi_sessions FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage tasmi_sessions"
  ON tasmi_sessions FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Revisions: org isolation ──
CREATE POLICY "Users can view org revisions"
  ON revisions FOR SELECT
  USING (belongs_to_org(organization_id));

CREATE POLICY "Teachers can manage revisions"
  ON revisions FOR ALL
  USING (
    get_user_role(organization_id) IN ('owner', 'super_admin', 'branch_manager', 'teacher')
  );

-- ── Schedule Sessions: org isolation ──
CREATE POLICY "Users can view org schedule_sessions"
  ON schedule_sessions FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Schedule Events: org isolation ──
CREATE POLICY "Users can view org schedule_events"
  ON schedule_events FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Notifications: user isolation ──
CREATE POLICY "Users can view own notifications"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can update own notifications"
  ON notifications FOR UPDATE
  USING (user_id = auth.uid());

-- ── Reports: org isolation ──
CREATE POLICY "Users can view org reports"
  ON reports FOR SELECT
  USING (belongs_to_org(organization_id));

-- ── Audit Logs: org isolation (read-only for non-owners) ──
CREATE POLICY "Users can view org audit_logs"
  ON audit_logs FOR SELECT
  USING (belongs_to_org(organization_id));
