# AGENTS.md — Hafiz Development Guide

## Project Status
- **Current Phase:** Phase 2 (Students & Guardians)
- **Current Branch:** feat/phase-2-students
- **Last Updated:** 2026-09-06
- **Flutter Version:** 3.47.2 stable
- **Dart Version:** 3.13.2

## Commands

```bash
# Run
flutter run

# Build
flutter build apk --debug
flutter build web --release

# Test
flutter test

# Lint
flutter analyze

# Code Generation
dart run build_runner build --delete-conflicting-outputs

# Code Gen Watch
dart run build_runner watch --delete-conflicting-outputs

# Supabase
supabase start
supabase db push
supabase db diff
```

## Architecture Rules

- **Feature-first folder structure** — group by feature, not by type
- **MVVM pattern** — Views, ViewModels (not Controllers), Repositories, Services
- **Riverpod for state** — no Provider, no GetX, no Bloc
- **Freezed for all data models** — immutable, copyWith, equality
- **GoRouter for navigation** — declarative, auth guards, ShellRoute for tabs
- **Supabase for backend** — auth, postgres, RLS, realtime, storage
- **Drift for offline local storage** — SQLite-based, reactive streams
- **Always use directional widgets** — EdgeInsetsDirectional, AlignmentDirectional, etc.
- **Always use AppLocalizations for text** — never hardcode user-facing strings
- **Arabic is primary** — RTL by default, LTR as secondary

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | snake_case | `app_colors.dart` |
| Classes | PascalCase | `AppColors` |
| Variables/functions | camelCase | `primaryColor` |
| Constants | camelCase | `maxRetries` |
| Tables | snake_case | `memorization_plans` |
| Enums | camelCase values | `AppBadgeVariant.success` |

## Testing

- **Unit tests** for domain layer (entities, repositories, services)
- **Widget tests** for presentation layer (views, widgets)
- **Integration tests** for critical flows (tasmi, attendance)
- Use `mocktail` for mocking
- Use `ProviderContainer.test()` for Riverpod providers

## Current Sprint — Phase 2: Students & Guardians

### Tasks
- [x] Student entity (freezed)
- [x] Guardian entity (freezed)
- [x] Student repository abstract + impl
- [x] Student state management (Riverpod)
- [x] Student list view
- [x] Student profile view with tabs
- [x] Add student wizard
- [x] Guardian management
- [ ] Update router with student routes

## Key Files

| File | Purpose |
|------|---------|
| `PLAN.md` | Full tech stack, data model, phased plan |
| `AGENTS.md` | This file — status, conventions, commands |
| `Quran_School_Management_PRD.md` | Feature requirements |
| `Quran_School_UI_UX_Design_Spec.md` | UI/UX specifications |
| `lib/core/theme/` | Design tokens implementation |
| `lib/core/widgets/` | Reusable UI components |
| `lib/core/router/` | Route definitions and auth guard |
| `lib/shared/models/` | All data models (freezed) |

## Git Workflow

1. **Start phase:** `git checkout dev && git pull && git checkout -b feat/phase-N-name`
2. **During phase:** Multiple commits with clear messages
3. **End phase:** Push branch, open PR to `dev`
4. **After review:** Merge PR to `dev`

### Commit Convention

```
feat(scope): description
fix(scope): description
test(scope): description
docs(scope): description
refactor(scope): description
chore(scope): description
```

Scopes: `auth`, `students`, `teachers`, `classes`, `quran`, `hifz`, `tasmi`, `revision`, `attendance`, `dashboard`, `notifications`, `finance`, `reports`, `settings`, `core`, `shared`

## Important Decisions

- Arabic is the primary interface language (RTL)
- Supabase RLS for multi-tenant isolation (organization_id on all tables)
- Offline-first for teachers designed from day one (Drift + sync queue)
- Finance module is Phase 2 (skip for MVP)
- Tasmi' speed target: 10-20 seconds for a basic record
