# Hafiz — Next Phases Implementation Roadmap

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the MVP from ~55% to ~90% by finishing the critical teacher workflow loop (tasmi → revision → notifications) and filling gaps in attendance, parent portal, tests, and localization.

**Architecture:** Feature-first MVVM with Riverpod, Supabase, Freezed, GoRouter. All changes follow existing patterns in the codebase.

**Tech Stack:** Flutter 3.47.2, Dart 3.13.2, Riverpod 2.6+, Supabase, Freezed (hand-maintained), GoRouter 14.x

**Specs:** `Quran_School_Management_PRD.md`, `Quran_School_UI_UX_Design_Spec.md`

## Global Constraints

- Arabic is primary language (RTL), LTR as secondary
- Supabase RLS for multi-tenant isolation (organization_id on all tables)
- Feature-first folder structure, MVVM pattern, Riverpod for state
- All user-facing strings via AppLocalizations (no hardcoded Arabic in views)
- Freezed for all data models (currently hand-maintained due to build_runner breakage)
- GoRouter for navigation with auth guards
- Directional widgets (EdgeInsetsDirectional, AlignmentDirectional)
- **DO NOT commit or push until explicitly told to**

---

## Current State Summary

| Module | Status | Score |
|--------|--------|-------|
| Foundation (theme, router, widgets, network) | Solid | 90% |
| Auth (login, signup, roles, auto-org) | Working | 95% |
| Students (CRUD) | Working, missing enrollment UI | 85% |
| Teachers (CRUD) | Working, missing edit view | 80% |
| Classes (CRUD) | Working, missing enrollment actions | 80% |
| Qur'an (browse, plans) | Working, missing ayah-level tracking | 70% |
| Hifz (assignments) | Working | 85% |
| Dashboard (owner) | Working, spacing fixes in progress | 60% |
| Guardians (list, profile) | Working, nullable fixes applied | 80% |
| Schedule (calendar, sessions) | Working | 70% |
| Notifications (list) | Working, no creation/push | 50% |
| Assessments (list, create) | Working, entity not freezed | 70% |
| Reports (stub) | Single view, no real data | 30% |
| Attendance | Marking view only, route broken | 40% |
| Tasmi' | Eval view only, no session flow | 30% |
| Revision | Single view, no engine | 25% |
| Parent Portal | Stub only | 10% |
| Settings | Stub only | 20% |
| Tests | 1 placeholder test | 0% |
| Localization | Stub class, hardcoded strings | 25% |
| Offline/Sync | Dependencies installed, 0% code | 0% |

---

## Phase 14: Stabilization & Bug Fixes (Current Session)

> Complete the bug fixes started in this session and verify all existing features work.

### Task 1: Verify Branch Dropdown End-to-End

**Files:**
- Modify: `lib/features/auth/domain/repositories/user_role_provider.dart`
- Modify: `lib/core/widgets/branch_dropdown.dart`
- Modify: `lib/features/students/presentation/views/add_student_view.dart`
- Modify: `lib/features/teachers/presentation/views/add_teacher_view.dart`
- Modify: `lib/features/classes/presentation/views/add_class_view.dart`

- [ ] **Step 1:** Hot restart the app and navigate to Add Student
- [ ] **Step 2:** Verify BranchDropdown shows a spinner while loading, then shows the branch name (not "لا يوجد مؤسسة محددة")
- [ ] **Step 3:** Repeat for Add Teacher and Add Class
- [ ] **Step 4:** If still broken, add `AppLogger.log` calls in `userRolesProvider` and `activeOrganizationIdProvider` to trace the data flow
- [ ] **Step 5:** Pull logs via `adb shell "run-as com.hafiz.hafiz cat /data/data/com.hafiz.hafiz/app_flutter/app_debug.log"`

### Task 2: Verify Dashboard Loads Data

**Files:**
- Modify: `lib/features/dashboard/presentation/views/owner_dashboard_view.dart`
- Modify: `lib/features/dashboard/domain/repositories/dashboard_provider.dart`

- [ ] **Step 1:** Hot restart and check if stat cards show numbers (not "لا توجد بيانات")
- [ ] **Step 2:** Check logs for any errors from dashboard providers
- [ ] **Step 3:** Verify quick actions spacing looks correct

### Task 3: Fix All Remaining `$enumDecode` Case Sensitivity

**Files:**
- Modify: `lib/features/tasmi/domain/entities/tasmi_session.g.dart`
- Modify: `lib/features/attendance/domain/entities/attendance.g.dart`
- Modify: `lib/features/hifz/domain/entities/hifz_assignment.g.dart`
- Modify: `lib/features/schedule/domain/entities/session.g.dart`
- Modify: `lib/features/schedule/domain/entities/schedule_event.g.dart`
- Modify: `lib/features/revision/domain/entities/revision.g.dart`
- Modify: `lib/features/quran/domain/entities/memorization_plan.g.dart`
- Modify: `lib/features/quran/domain/entities/surah.g.dart`
- Modify: `lib/features/notifications/domain/entities/notification.g.dart`
- Modify: `lib/features/reports/domain/entities/report.g.dart`

- [ ] **Step 1:** Replace all `$enumDecode(_$XEnumMap, json['field'])` with case-insensitive `XEnum.values.firstWhere((e) => e.name == (json['field'] as String).toLowerCase(), orElse: () => XEnum.defaultValue)`
- [ ] **Step 2:** Replace all `$enumDecodeNullable` with nullable version using `firstOrNull`
- [ ] **Step 3:** Run `flutter analyze` — expect 0 errors
- [ ] **Step 4:** Hot restart and verify no new crashes

### Task 4: Update AGENTS.md

**Files:**
- Modify: `AGENTS.md`

- [ ] **Step 1:** Update Current Phase to "Phase 14: Stabilization"
- [ ] **Step 2:** Update Current Branch to actual branch name
- [ ] **Step 3:** Update Last Updated date

- [ ] **Step 5: Commit**
```bash
git add -A
git commit -m "fix(core): stabilize auth, branch dropdown, enum decoding, dashboard spacing"
```

---

## Phase 15: Tasmi' Completion (The Heart of the Product)

> Complete the 5-screen tasmi' workflow: Setup → Evaluation → Errors → Notes → Result. Target: teacher records a session in 10-20 seconds.

### Task 1: Tasmi' Session List View

**Files:**
- Create: `lib/features/tasmi/presentation/views/tasmi_session_list_view.dart`
- Modify: `lib/core/router/app_router.dart` (add route)
- Modify: `lib/features/tasmi/domain/repositories/tasmi_provider.dart` (add list provider)

- [ ] **Step 1:** Create `tasmiSessionListProvider` that fetches sessions for the active branch
- [ ] **Step 2:** Create `TasmiSessionListView` with:
  - AppBar with title "التمعيين" and add button
  - List of session cards showing: student name, passage, outcome badge, date, score
  - Filter by: today, this week, all
  - Pull-to-refresh
  - Empty state when no sessions
- [ ] **Step 3:** Add route `/tasmi` → `TasmiSessionListView`
- [ ] **Step 4:** Add route `/tasmi/add` → existing `TasmiEvalView`
- [ ] **Step 5:** Update sidebar navigation to use session list as entry point

### Task 2: Tasmi' Session Detail View

**Files:**
- Create: `lib/features/tasmi/presentation/views/tasmi_session_detail_view.dart`
- Modify: `lib/core/router/app_router.dart` (add route)

- [ ] **Step 1:** Create `TasmiSessionDetailView` showing:
  - Student name and passage
  - All 5 dimension scores (accuracy, tajwid, fluency, pronunciation, confidence)
  - Overall outcome badge (pass/needs revision/fail)
  - List of errors with type, severity, verse reference
  - Teacher notes
  - Date and duration
- [ ] **Step 2:** Add route `/tasmi/:id` → `TasmiSessionDetailView`

### Task 3: Complete the 5-Screen Eval Workflow

**Files:**
- Modify: `lib/features/tasmi/presentation/views/tasmi_eval_view.dart`

- [ ] **Step 1:** Screen 1 (Setup): Student selector (dropdown from branch students), passage range picker, session type dropdown, "Start" button
- [ ] **Step 2:** Screen 2 (Evaluation): Large PASS / NEEDS REVISION / FAIL buttons at top, score sliders for each dimension below
- [ ] **Step 3:** Screen 3 (Errors): Quick chips for error types (omission, addition, substitution, hesitation, tajwid, pronunciation, stopping, starting) + verse selector
- [ ] **Step 4:** Screen 4 (Notes): Teacher note textarea
- [ ] **Step 5:** Screen 5 (Result): Outcome display, "Save & Next Student" button (primary), "Save & Exit" button (secondary)
- [ ] **Step 6:** Wire save to `tasmiRepository.createSession()`
- [ ] **Step 7:** After save, auto-update memorization progress if outcome is "pass"

### Task 4: Tasmi' Error Tracking

**Files:**
- Modify: `lib/features/tasmi/domain/entities/tasmi_session.dart` (verify entity)
- Modify: `lib/features/tasmi/domain/repositories/tasmi_repository.dart` (verify methods)

- [ ] **Step 1:** Verify `TasmiSession` entity has all required fields from DB schema
- [ ] **Step 2:** Verify `TasmiError` entity matches DB schema
- [ ] **Step 3:** Add error chip grid UI in eval view Screen 3
- [ ] **Step 4:** Wire error creation to session save

- [ ] **Step 5: Commit**
```bash
git add lib/features/tasmi/ lib/core/router/app_router.dart
git commit -m "feat(tasmi): complete 5-screen evaluation workflow with session list and detail"
```

---

## Phase 16: Revision Engine

> Build the revision pool management system. This is the second most important feature after tasmi'.

### Task 1: Revision Plan Management

**Files:**
- Modify: `lib/features/revision/domain/entities/revision.dart` (verify entity)
- Modify: `lib/features/revision/domain/repositories/revision_repository.dart`
- Modify: `lib/features/revision/domain/repositories/revision_provider.dart`
- Create: `lib/features/revision/presentation/views/revision_plan_view.dart`

- [ ] **Step 1:** Verify `Revision` entity matches DB schema (student_id, passage, due_date, status, score, last_reviewed)
- [ ] **Step 2:** Create `revisionPlansProvider` for student's revision plan
- [ ] **Step 3:** Create `RevisionPlanView` showing:
  - Student info header
  - Configurable revision frequency (daily/weekly/spaced)
  - Current revision pool stats (due today, overdue, weak, strong)
  - Action: "Start Revision Session"

### Task 2: Revision Tracking View (Complete)

**Files:**
- Modify: `lib/features/revision/presentation/views/revision_tracking_view.dart`

- [ ] **Step 1:** Redesign to show:
  - Summary cards: Due Today (yellow), Overdue (red), Weak (orange), Strong (green)
  - List of passages with: surah range, last score, status badge, days since last review
  - "Start Revision" button per passage
  - After revision: mark as Strong/Needs Repetition/Weak
- [ ] **Step 2:** Wire to revision repository for CRUD
- [ ] **Step 3:** After tasmi' pass, auto-add passage to revision pool (configurable delay)

### Task 3: Revision Heatmap

**Files:**
- Create: `lib/features/revision/presentation/widgets/revision_heatmap.dart`

- [ ] **Step 1:** Create a visual heatmap widget showing:
  - Surah-by-surah color coding (strong=green, due=yellow, overdue=red, weak=orange, not started=gray)
  - Tap to see details
- [ ] **Step 2:** Integrate into student profile and revision plan views

- [ ] **Step 3: Commit**
```bash
git add lib/features/revision/
git commit -m "feat(revision): complete revision engine with plan management and heatmap"
```

---

## Phase 17: Attendance Completion

> Wire the attendance module end-to-end. Currently only a marking view with broken route.

### Task 1: Fix Attendance Route

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1:** Change attendance route to accept classId and sessionId as query params
- [ ] **Step 2:** Update `AttendanceMarkingView` to read params from route
- [ ] **Step 3:** Add "Mark Attendance" button on class detail view that navigates with correct IDs

### Task 2: Attendance History View

**Files:**
- Create: `lib/features/attendance/presentation/views/attendance_history_view.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1:** Create `AttendanceHistoryView` showing:
  - Date picker at top
  - Class selector dropdown
  - List of students with status badges (present=green, late=yellow, absent=red, excused=blue)
  - Monthly attendance percentage per student
- [ ] **Step 2:** Add route `/attendance/history` → `AttendanceHistoryView`

### Task 3: Class Attendance Overview

**Files:**
- Modify: `lib/features/classes/presentation/views/class_detail_view.dart`

- [ ] **Step 1:** Add "Attendance" tab to class detail view
- [ ] **Step 2:** Show attendance stats: present %, late %, absent %
- [ ] **Step 3:** Show recent attendance records list

- [ ] **Step 4: Commit**
```bash
git add lib/features/attendance/ lib/core/router/app_router.dart lib/features/classes/
git commit -m "feat(attendance): complete attendance module with history and class overview"
```

---

## Phase 18: Parent Portal

> Build real parent-facing features. Currently a stub view with no data.

### Task 1: Parent Portal Data Layer

**Files:**
- Create: `lib/features/parent_portal/domain/entities/parent_student.dart`
- Create: `lib/features/parent_portal/domain/repositories/parent_repository.dart`
- Create: `lib/features/parent_portal/domain/repositories/parent_provider.dart`

- [ ] **Step 1:** Create `ParentStudent` entity (student info + progress summary + attendance stats)
- [ ] **Step 2:** Create `ParentRepository` with methods:
  - `getMyChildren()` — returns list of students linked to current parent
  - `getStudentProgress(studentId)` — memorization stats, revision pool
  - `getStudentAttendance(studentId)` — attendance records
  - `getStudentTasmiSessions(studentId)` — recent tasmi sessions
- [ ] **Step 3:** Create providers for each method

### Task 2: Parent Portal Views

**Files:**
- Modify: `lib/features/parent_portal/presentation/views/parent_portal_view.dart`
- Create: `lib/features/parent_portal/presentation/views/parent_progress_view.dart`
- Create: `lib/features/parent_portal/presentation/views/parent_attendance_view.dart`
- Create: `lib/features/parent_portal/presentation/views/parent_schedule_view.dart`

- [ ] **Step 1:** Redesign `ParentPortalView` as tab-based with 4 tabs: Home, Progress, Attendance, Schedule
- [ ] **Step 2:** Home tab: greeting, child selector, today's status card (attendance, current lesson, progress ring), recent teacher feedback
- [ ] **Step 3:** Progress tab: memorized/strong/needs-revision summary, progress over time, recent tasmi sessions with teacher comments
- [ ] **Step 4:** Attendance tab: calendar view with status indicators, monthly percentage
- [ ] **Step 5:** Schedule tab: upcoming classes and assignments

### Task 3: Parent Notification Preferences

**Files:**
- Modify: `lib/features/notifications/domain/repositories/notification_provider.dart`

- [ ] **Step 1:** Add notification preferences entity (absence alerts, tasmi results, payment reminders)
- [ ] **Step 2:** Add preferences UI in parent portal settings

- [ ] **Step 3: Commit**
```bash
git add lib/features/parent_portal/
git commit -m "feat(parent-portal): complete parent portal with progress, attendance, and notifications"
```

---

## Phase 19: Reports & Analytics

> Build real report generation with data visualization.

### Task 1: Report Data Layer

**Files:**
- Modify: `lib/features/reports/domain/repositories/report_repository.dart`
- Modify: `lib/features/reports/domain/repositories/report_provider.dart`

- [ ] **Step 1:** Create report data methods:
  - `getStudentProgressReport(studentId, dateRange)`
  - `getClassPerformanceReport(classId, dateRange)`
  - `getAttendanceReport(branchId, dateRange)`
  - `getTeacherActivityReport(teacherId, dateRange)`
  - `getMemorizationProgressReport(branchId, dateRange)`
- [ ] **Step 2:** Create providers for each report type

### Task 2: Report Views

**Files:**
- Modify: `lib/features/reports/presentation/views/reports_view.dart`
- Create: `lib/features/reports/presentation/views/report_detail_view.dart`

- [ ] **Step 1:** Redesign `ReportsView` as category-based: Students, Qur'an, Attendance, Teachers, Classes
- [ ] **Step 2:** Each category shows available report types with date range picker
- [ ] **Step 3:** `ReportDetailView` shows:
  - Summary statistics at top
  - Data table or chart below
  - Export button (PDF/CSV)
- [ ] **Step 4:** Add route `/reports/:type` → `ReportDetailView`

### Task 3: At-Risk Student Detection

**Files:**
- Create: `lib/features/reports/domain/services/at_risk_engine.dart`
- Modify: `lib/features/dashboard/presentation/views/owner_dashboard_view.dart`

- [ ] **Step 1:** Create `AtRiskEngine` that computes risk signals:
  - Repeated absences (>=3 in 2 weeks)
  - Declining tasmi scores
  - Increasing error count
  - Missed assignments
  - Revision backlog growth
  - Long inactivity (>7 days)
- [ ] **Step 2:** Add "Students Needing Attention" section to owner dashboard
- [ ] **Step 3:** Each flagged student shows: name, risk level (normal/attention/high), reason, suggested action

- [ ] **Step 4: Commit**
```bash
git add lib/features/reports/ lib/features/dashboard/
git commit -m "feat(reports): complete report generation with at-risk student detection"
```

---

## Phase 20: Notifications Enhancement

> Build real notification creation and delivery.

### Task 1: Notification Creation

**Files:**
- Modify: `lib/features/notifications/domain/repositories/notification_repository.dart`
- Create: `lib/features/notifications/presentation/views/create_notification_view.dart`

- [ ] **Step 1:** Create `CreateNotificationView` with:
  - Title, body, type selector
  - Audience selector (all parents, specific class, specific student)
  - Schedule (now or later)
- [ ] **Step 2:** Wire to notification repository

### Task 2: Auto-Notification Rules

**Files:**
- Create: `lib/features/notifications/domain/services/notification_rules.dart`

- [ ] **Step 1:** Create rule engine:
  - Absence threshold: notify guardian after N absences in M days
  - Tasmi result: notify parent after teacher records session
  - Assignment due: remind student/parent 1 day before
  - Payment overdue: remind parent after due date
- [ ] **Step 2:** Trigger rules after relevant events (tasmi save, attendance save, etc.)

### Task 3: Notification Preferences

**Files:**
- Create: `lib/features/notifications/domain/entities/notification_preference.dart`
- Modify: `lib/features/settings/presentation/views/settings_view.dart`

- [ ] **Step 1:** Create notification preferences per user (which events, which channel)
- [ ] **Step 2:** Add notification settings section to settings view

- [ ] **Step 3: Commit**
```bash
git add lib/features/notifications/ lib/features/settings/
git commit -m "feat(notifications): complete notification creation, auto-rules, and preferences"
```

---

## Phase 21: Settings & Organization Management

> Build real settings and organization management.

### Task 1: Organization Settings

**Files:**
- Modify: `lib/features/settings/presentation/views/settings_view.dart`
- Create: `lib/features/settings/presentation/views/org_settings_view.dart`
- Create: `lib/features/settings/domain/repositories/settings_repository.dart`

- [ ] **Step 1:** Create `OrgSettingsView` with:
  - Organization name, logo, contact info
  - Branch management (list, create, edit)
  - Academic settings (methodology, grading scales)
  - User management (list, invite, role assignment)
- [ ] **Step 2:** Create `SettingsRepository` with CRUD methods

### Task 2: User Management

**Files:**
- Create: `lib/features/settings/presentation/views/user_management_view.dart`

- [ ] **Step 1:** Create `UserManagementView` showing:
  - List of users with name, email, role, status
  - Invite user button
  - Edit role per user
  - Deactivate user
- [ ] **Step 2:** Wire to Supabase auth admin APIs

- [ ] **Step 3: Commit**
```bash
git add lib/features/settings/
git commit -m "feat(settings): complete organization settings and user management"
```

---

## Phase 22: Tests

> Add comprehensive tests for all features.

### Task 1: Unit Tests for Domain Layer

**Files:**
- Create: `test/features/auth/domain/repositories/auth_repository_test.dart`
- Create: `test/features/students/domain/repositories/student_repository_test.dart`
- Create: `test/features/teachers/domain/repositories/teacher_repository_test.dart`
- Create: `test/features/classes/domain/repositories/class_repository_test.dart`
- Create: `test/features/tasmi/domain/repositories/tasmi_repository_test.dart`
- Create: `test/features/attendance/domain/repositories/attendance_repository_test.dart`
- Create: `test/features/hifz/domain/repositories/hifz_assignment_repository_test.dart`
- Create: `test/features/guardians/domain/repositories/guardian_repository_test.dart`

- [ ] **Step 1:** For each repository, create tests using `mocktail`:
  - Test `getOrg*()` returns list when data exists
  - Test `getOrg*()` returns empty list when no data
  - Test `create*()` sends correct data to Supabase
  - Test `update*()` sends correct updates
  - Test `delete*()` removes record
  - Test error handling (network error, RLS violation)
- [ ] **Step 2:** For each provider, test:
  - Provider returns data when repository succeeds
  - Provider throws when repository fails
  - Provider refetches when dependencies change

### Task 2: Widget Tests for Critical Views

**Files:**
- Create: `test/features/auth/presentation/views/login_view_test.dart`
- Create: `test/features/students/presentation/views/student_list_view_test.dart`
- Create: `test/features/tasmi/presentation/views/tasmi_eval_view_test.dart`
- Create: `test/features/attendance/presentation/views/attendance_marking_view_test.dart`

- [ ] **Step 1:** For each view, create widget tests using `ProviderContainer`:
  - Test view renders without errors
  - Test loading state shows spinner
  - Test error state shows error message
  - Test data state shows content
  - Test empty state shows empty message
- [ ] **Step 2:** Test navigation (tap button → navigate to route)

### Task 3: Integration Test for Critical Workflow

**Files:**
- Create: `test/integration/tasmi_workflow_test.dart`

- [ ] **Step 1:** Test the critical 13-step loop:
  - Login → navigate to tasmi → select student → record session → save → verify progress updated
- [ ] **Step 2:** Test attendance flow:
  - Navigate to class → mark attendance → save → verify records created

- [ ] **Step 3: Commit**
```bash
git add test/
git commit -m "test: add unit, widget, and integration tests for critical features"
```

---

## Phase 23: Localization

> Complete the localization system. Currently a stub class with hardcoded Arabic.

### Task 1: Fix Localization Infrastructure

**Files:**
- Create: `l10n.yaml` (if missing)
- Modify: `lib/core/localization/app_localizations.dart`

- [ ] **Step 1:** Create `l10n.yaml` with:
  ```yaml
  arb-dir: lib/core/localization/l10n
  output-localization-file: app_localizations.dart
  output-class: AppLocalizations
  preferred-supported-locales: ["ar"]
  ```
- [ ] **Step 2:** Run `flutter gen-l10n`
- [ ] **Step 3:** If codegen fails, expand the stub class to include ALL strings from ARB files

### Task 2: Replace Hardcoded Strings

**Files:**
- All view files with hardcoded Arabic text

- [ ] **Step 1:** Grep for hardcoded Arabic in all `.dart` files
- [ ] **Step 2:** For each hardcoded string, add entry to ARB files (ar, en, fr)
- [ ] **Step 3:** Replace with `context.l.stringName`

### Task 3: Complete ARB Files

**Files:**
- Modify: `lib/core/localization/l10n/app_ar.arb`
- Modify: `lib/core/localization/l10n/app_en.arb`
- Modify: `lib/core/localization/l10n/app_fr.arb`

- [ ] **Step 1:** Add missing strings for all features:
  - Tasmi' terms
  - Revision terms
  - Report terms
  - Settings terms
  - Parent portal terms
- [ ] **Step 2:** Verify all 3 languages have complete translations

- [ ] **Step 3: Commit**
```bash
git add lib/core/localization/ l10n.yaml
git commit -m "feat(localization): complete ARB files and replace hardcoded strings"
```

---

## Phase 24: Offline/Sync (Drift)

> Implement offline-first for teacher workflows. Dependencies are installed but 0% code.

### Task 1: Drift Database Setup

**Files:**
- Create: `lib/core/database/app_database.dart`
- Create: `lib/core/database/tables/` (student_table.dart, schedule_table.dart, attendance_table.dart, etc.)

- [ ] **Step 1:** Define Drift tables for offline-cached data:
  - `CachedStudent` (id, name, branch_id, json_data, last_synced)
  - `CachedSchedule` (id, class_id, day, time, json_data)
  - `CachedAttendance` (id, student_id, class_id, date, status, synced)
  - `CachedTasmiSession` (id, student_id, passage, outcome, json_data, synced)
  - `SyncQueue` (id, table_name, record_id, action, payload, created_at, synced)
- [ ] **Step 2:** Create `AppDatabase` class with Drift
- [ ] **Step 3:** Initialize in `bootstrap.dart`

### Task 2: Sync Service

**Files:**
- Create: `lib/core/services/sync_service.dart`

- [ ] **Step 1:** Create `SyncService` with methods:
  - `cacheStudent(student)` — save to local DB
  - `getCachedStudents()` — read from local DB
  - `queueAction(table, recordId, action, payload)` — add to sync queue
  - `syncPendingActions()` — process queue when online
  - `resolveConflict(local, remote)` — conflict resolution strategy
- [ ] **Step 2:** Use `connectivity_plus` to detect online/offline
- [ ] **Step 3:** Auto-sync when connection restored

### Task 3: Offline Teacher Workflow

**Files:**
- Modify: `lib/features/tasmi/presentation/views/tasmi_eval_view.dart`
- Modify: `lib/features/attendance/presentation/views/attendance_marking_view.dart`

- [ ] **Step 1:** In tasmi eval view, check connectivity before save:
  - If online: save to Supabase directly
  - If offline: save to local DB + queue sync action
- [ ] **Step 2:** Same for attendance marking
- [ ] **Step 3:** Show offline indicator in app bar when not connected
- [ ] **Step 4:** Show "Syncing..." status when queue is processing

- [ ] **Step 5: Commit**
```bash
git add lib/core/database/ lib/core/services/
git commit -m "feat(offline): implement Drift database and sync service for teacher workflows"
```

---

## Phase 25: Polish & Performance

> Final polish before launch.

### Task 1: Performance Optimization

- [ ] **Step 1:** Add pagination to all list views (students, teachers, classes, sessions)
- [ ] **Step 2:** Add image caching for avatars
- [ ] **Step 3:** Optimize Supabase queries (select only needed columns)
- [ ] **Step 4:** Add skeleton loading to all data views
- [ ] **Step 5:** Verify dashboard loads in < 2.5 seconds

### Task 2: Error Handling

- [ ] **Step 1:** Add user-friendly error messages to all catch blocks
- [ ] **Step 2:** Add retry buttons on error states
- [ ] **Step 3:** Add offline-specific error messages
- [ ] **Step 4:** Test all error paths

### Task 3: UX Refinement

- [ ] **Step 1:** Add confirmation dialogs for destructive actions
- [ ] **Step 2:** Add optimistic UI for save operations
- [ ] **Step 3:** Add pull-to-refresh on all list views
- [ ] **Step 4:** Test RTL layout on all screens
- [ ] **Step 5:** Test on different screen sizes (mobile, tablet, desktop)

### Task 4: Duplicate Widget Cleanup

**Files:**
- Delete or merge duplicate widgets in `lib/core/widgets/`

- [ ] **Step 1:** Identify all duplicate pairs (button.dart vs app_button.dart, etc.)
- [ ] **Step 2:** Migrate all views to use the `app_*` prefixed widgets
- [ ] **Step 3:** Delete the old unprefixed duplicates

- [ ] **Step 4: Commit**
```bash
git add -A
git commit -m "chore(polish): performance optimization, error handling, UX refinement, widget cleanup"
```

---

## Summary: Phase Order & Dependencies

```
Phase 14: Stabilization ← (current, do first)
    ↓
Phase 15: Tasmi' ← (most critical, blocks revision)
    ↓
Phase 16: Revision ← (depends on tasmi pass events)
    ↓
Phase 17: Attendance ← (independent)
Phase 18: Parent Portal ← (depends on data from tasmi/attendance)
Phase 19: Reports ← (depends on all data sources)
Phase 20: Notifications ← (depends on events from all modules)
Phase 21: Settings ← (independent)
Phase 22: Tests ← (can start anytime, best after features are stable)
Phase 23: Localization ← (can start anytime)
Phase 24: Offline/Sync ← (best after core features are complete)
Phase 25: Polish ← (final phase)
```

## Estimated Effort

| Phase | Tasks | Estimated Time |
|-------|-------|---------------|
| 14: Stabilization | 4 | 1-2 hours |
| 15: Tasmi' | 4 | 3-4 hours |
| 16: Revision | 3 | 2-3 hours |
| 17: Attendance | 3 | 2-3 hours |
| 18: Parent Portal | 3 | 3-4 hours |
| 19: Reports | 3 | 3-4 hours |
| 20: Notifications | 3 | 2-3 hours |
| 21: Settings | 2 | 2-3 hours |
| 22: Tests | 3 | 4-6 hours |
| 23: Localization | 3 | 2-3 hours |
| 24: Offline/Sync | 3 | 4-6 hours |
| 25: Polish | 4 | 3-4 hours |
| **Total** | **38** | **31-45 hours** |

## Critical Path

The absolute minimum for a usable MVP:

1. ✅ Phase 14: Stabilization
2. Phase 15: Tasmi' (the heart)
3. Phase 17: Attendance (wired)
4. Phase 18: Parent Portal (basic)
5. Phase 22: Tests (at least unit tests)
6. Phase 25: Polish (error handling, UX)

**Estimated MVP completion: 15-20 hours of focused work**
