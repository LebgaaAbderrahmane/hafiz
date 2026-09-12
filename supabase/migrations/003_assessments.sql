-- Assessment types
CREATE TYPE assessment_type AS ENUM (
  'quiz',         -- اختبار قصير
  'exam',         -- امتحان
  'memorization', -- تقييم حفظ
  'tajwid',       -- تقييم تجويد
  'reading',      -- تقييم قراءة
  'participation' -- مشاركة
);

-- Assessment results
CREATE TYPE assessment_result AS ENUM (
  'excellent',    -- ممتاز
  'veryGood',     -- جيد جداً
  'good',         -- جيد
  'acceptable',   -- مقبول
  'weak',         -- ضعيف
  'fail'          -- راسب
);

-- Assessments table
CREATE TABLE IF NOT EXISTS assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
  class_id UUID REFERENCES classes(id) ON DELETE SET NULL,
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  type assessment_type NOT NULL DEFAULT 'exam',
  max_score DECIMAL(5,2) DEFAULT 100,
  passing_score DECIMAL(5,2) DEFAULT 50,
  assessment_date DATE NOT NULL DEFAULT CURRENT_DATE,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Assessment results table
CREATE TABLE IF NOT EXISTS assessment_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id UUID NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  score DECIMAL(5,2),
  result assessment_result,
  teacher_notes TEXT,
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(assessment_id, student_id)
);

-- RLS policies
ALTER TABLE assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view assessments in their org"
  ON assessments FOR SELECT
  USING (organization_id IN (
    SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
  ));

CREATE POLICY "Teachers can create assessments"
  ON assessments FOR INSERT
  WITH CHECK (organization_id IN (
    SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
  ));

CREATE POLICY "Teachers can update their assessments"
  ON assessments FOR UPDATE
  USING (teacher_id IN (
    SELECT id FROM teachers WHERE user_id = auth.uid()
  ));

CREATE POLICY "Teachers can delete their assessments"
  ON assessments FOR DELETE
  USING (teacher_id IN (
    SELECT id FROM teachers WHERE user_id = auth.uid()
  ));

CREATE POLICY "Users can view assessment results in their org"
  ON assessment_results FOR SELECT
  USING (assessment_id IN (
    SELECT id FROM assessments WHERE organization_id IN (
      SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
    )
  ));

CREATE POLICY "Teachers can create assessment results"
  ON assessment_results FOR INSERT
  WITH CHECK (assessment_id IN (
    SELECT id FROM assessments WHERE organization_id IN (
      SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
    )
  ));

CREATE POLICY "Teachers can update assessment results"
  ON assessment_results FOR UPDATE
  USING (assessment_id IN (
    SELECT id FROM assessments WHERE organization_id IN (
      SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
    )
  ));

CREATE POLICY "Teachers can delete assessment results"
  ON assessment_results FOR DELETE
  USING (assessment_id IN (
    SELECT id FROM assessments WHERE organization_id IN (
      SELECT organization_id FROM user_roles WHERE user_id = auth.uid()
    )
  ));

-- Indexes
CREATE INDEX idx_assessments_org ON assessments(organization_id);
CREATE INDEX idx_assessments_branch ON assessments(branch_id);
CREATE INDEX idx_assessments_class ON assessments(class_id);
CREATE INDEX idx_assessments_teacher ON assessments(teacher_id);
CREATE INDEX idx_assessments_date ON assessments(assessment_date);
CREATE INDEX idx_assessment_results_assessment ON assessment_results(assessment_id);
CREATE INDEX idx_assessment_results_student ON assessment_results(student_id);
