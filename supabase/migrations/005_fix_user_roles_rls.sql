-- Migration 005: Fix user_roles RLS circular dependency
-- The old policy required belongs_to_org() which checks user_roles,
-- creating a circular dependency. New users with no roles couldn't
-- read their own user_roles rows.

DROP POLICY IF EXISTS "Users can view org roles" ON user_roles;

CREATE POLICY "Users can view org roles"
  ON user_roles FOR SELECT
  USING (
    user_id = auth.uid()
    OR belongs_to_org(organization_id)
  );
