# PLAN.md — Hafiz Qur'an School Management Platform

**Version:** 1.0 | **Date:** 2026-09-06 | **Status:** Implementation

---

## Tech Stack

| Layer | Choice | Version |
|---|---|---|
| Framework | Flutter | 3.47.2 stable |
| Architecture | MVVM + Feature-First Clean | - |
| State | Riverpod (codegen) | 2.6+ |
| Backend | Supabase | 2.17+ |
| Local DB | Drift (SQLite) | 2.22+ |
| Navigation | go_router | 14.x |
| i18n | Flutter ARB + gen-l10n | - |
| Models | freezed + json_serializable | - |
| Testing | flutter_test + mocktail | - |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── bootstrap.dart
├── core/
│   ├── theme/          (colors, typography, spacing, theme)
│   ├── localization/   (l10n ARB files)
│   ├── router/         (go_router config, auth guard)
│   ├── network/        (supabase client)
│   ├── errors/         (failures, exceptions)
│   ├── utils/          (date, quran, validators)
│   └── widgets/        (reusable UI components)
├── features/
│   ├── auth/           (login, onboarding)
│   ├── students/       (list, profile, wizard)
│   ├── teachers/       (list, profile)
│   ├── classes/        (list, detail)
│   ├── quran/          (range picker, progress map)
│   ├── hifz/           (assignments, memorization)
│   ├── tasmi/          (session, evaluation, result)
│   ├── revision/       (plan, items, engine)
│   ├── attendance/     (marking, history)
│   ├── dashboard/      (owner, teacher, parent)
│   ├── notifications/  (center, creation)
│   ├── finance/        (Phase 2)
│   ├── assessments/    (exams, results)
│   ├── reports/        (generation, export)
│   └── settings/       (org, roles, config)
└── shared/
    ├── models/         (freezed entities)
    ├── providers/      (auth, org, connectivity)
    └── services/       (sync, notification)
```

## Data Model (Supabase PostgreSQL)

### Core Tables
- **organizations** — id, name, slug, settings (jsonb)
- **branches** — id, org_id, name, address
- **users** — id (Supabase auth), email, phone, name, language
- **user_roles** — user_id, org_id, branch_id, role (enum)
- **students** — id, org_id, branch_id, name, status, quran levels
- **guardians** — id, org_id, name, phone, relationship
- **student_guardians** — student_id, guardian_id, is_primary

### Teacher & Classes
- **teachers** — user_id, org_id, qualifications, ijazah
- **programs** — org_id, name
- **levels** — program_id, name, order
- **classes** — org_id, branch_id, program_id, teacher_id, capacity
- **class_enrollments** — class_id, student_id
- **schedules** — class_id, day_of_week, start/end time

### Qur'an
- **quran_surahs** — number (1-114), name_arabic, name_english, ayah_count
- **quran_ayahs** — surah, ayah, juz, hizb, rub, page, sajdah flag
- **quran_juz**, **quran_hizb**, **quran_rub**

### Hifz/Memorization
- **memorization_plans** — student_id, target, daily/weekly targets
- **memorization_assignments** — student_id, teacher_id, passage range, status
- **memorization_progress** — student_id, passage range, status, scores

### Tasmi'
- **tasmi_sessions** — student_id, teacher_id, passage, 5 scores, outcome
- **tasmi_errors** — session_id, surah+ayah, error_type, severity

### Revision
- **revision_plans** — student_id, frequency
- **revision_items** — plan_id, passage, status, next_review_date

### Supporting
- **attendance** — class_id, student_id, date, status
- **assessments** + **assessment_results**
- **notifications**, **audit_logs**
- **invoices** + **payments** (Phase 2)

### Offline (Drift/SQLite)
- **sync_queue** — table_name, record_id, action, payload, synced

## Phases

| Phase | Name | Branch | Focus |
|---|---|---|---|
| 0 | Foundation | feat/phase-0-foundation | Project setup, theme, widgets, infra |
| 1 | Auth | feat/phase-1-auth | Login, roles, onboarding |
| 2 | Students | feat/phase-2-students | Student lifecycle, guardians |
| 3 | Teachers & Classes | feat/phase-3-teachers-classes | Teacher/class management |
| 4 | Qur'an & Hifz | feat/phase-4-quran-hifz | Qur'an model, assignments |
| 5 | Tasmi' | feat/phase-5-tasmi | Core tasmi' workflow |
| 6 | Attendance & Revision | feat/phase-6-attendance-revision | Attendance + revision engine |
| 7 | Dashboards | feat/phase-7-dashboards | Owner, teacher, parent views |
| 8 | Reports & Settings | feat/phase-8-reports-settings | Reports, config, audit |
| 9 | Polish & Offline | feat/phase-9-polish | Offline sync, QA, perf |

## Git Workflow

1. `git checkout dev && git pull`
2. `git checkout -b feat/phase-N-name`
3. Multiple commits during work
4. Push + PR to `dev`
5. Review → merge

### Commit Convention
```
feat(scope): description
fix(scope): description
test(scope): description
docs(scope): description
refactor(scope): description
chore(scope): description
```

## Design Tokens

- **Primary:** #1A6B4F (Deep Qur'anic green)
- **Background:** #F8F7F4 (Warm white)
- **Spacing:** 4px base grid
- **Radius:** 8/12/16/20/999px
- **Fonts:** Noto Sans Arabic + Inter
- **Layout:** Sidebar 248px, top bar 64px, content max 1440px

## Key References

| File | Purpose |
|------|---------|
| AGENTS.md | Status, conventions, commands |
| Quran_School_Management_PRD.md | Feature requirements |
| Quran_School_UI_UX_Design_Spec.md | UI/UX specifications |
