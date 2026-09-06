# PRD — Qur’an School Management Platform

**Version:** 1.0  
**Date:** 2026-09-06  
**Status:** Product discovery → implementation-ready foundation  
**Product type:** Multi-tenant SaaS / web + mobile platform  
**Primary market assumption:** Qur’an schools, tahfiz centers, masajid, kuttab, Qur’an circles, academies, and organizations managing one or more Qur’an-learning programs.

---

# 1. Executive Summary

The product is a Qur’an-school-native management platform that digitizes the complete operational lifecycle of a Qur’an school.

The central product loop is:

> Student → assignment → practice → tasmiʿ → teacher evaluation → progress update → revision schedule → next assignment

The system must not be a generic school ERP with Qur’an fields added later. Qur’an education is the domain model around which the product is designed.

The platform should manage:

- organizations and branches
- admissions and student lifecycle
- students and guardians
- teachers and staff
- classes and groups
- Qur’an memorization
- daily/new lesson assignments
- tasmiʿ
- mistakes and teacher observations
- murājaʿah/revision
- tajwid and recitation quality
- attendance
- exams and competitions
- curricula and learning plans
- schedules and rooms
- parent communication
- announcements and notifications
- fees, invoices, payments, discounts and financial reporting
- certificates
- reports and analytics
- roles and permissions
- audit logs
- documents
- safeguarding
- optional donations
- multi-branch operations
- mobile/offline teacher workflows
- optional AI assistance

---

# 2. Product Vision

## Vision

Make running a Qur’an school as organized, measurable and easy as running a modern educational institution—without losing the traditional teacher-led nature of Qur’an education.

## Mission

Give school owners and teachers a single source of truth for:

1. who the students are
2. what each student has memorized
3. what each student is currently learning
4. what each student needs to revise
5. how well each student recites
6. whether the student is attending
7. how teachers are performing
8. what parents need to know
9. what the school needs operationally and financially

---

# 3. Product Principles

## 3.1 Qur’an-native

The Qur’an is represented structurally, not as arbitrary text.

The system understands:

- Qur’an
- 114 surahs
- ayahs
- juz
- hizb
- rubʿ al-hizb
- pages
- configurable school-specific units
- ranges from one ayah to another
- memorization status
- revision status

## 3.2 Teacher-first

The teacher should be able to record a tasmiʿ session in seconds.

The primary teacher workflow must be:

> Open app → Today → Student → Lesson → Evaluate → Save → Next student

## 3.3 Parent-friendly

Parents should not need to understand school administration.

They should see:

- attendance
- memorization progress
- revision status
- teacher feedback
- upcoming schedule
- announcements
- fees

## 3.4 Owner-focused

The owner should not need to inspect every student manually.

The dashboard should surface exceptions:

- students falling behind
- students with weak retention
- repeated absences
- overdue payments
- overloaded teachers
- empty classes
- upcoming exams
- operational issues

## 3.5 Offline-first for teachers

Teacher workflows should continue when connectivity is weak.

Changes should queue locally and synchronize safely when online.

## 3.6 Arabic-first and RTL

Arabic is a first-class interface language.

The architecture must support:

- Arabic
- English
- French
- RTL/LTR
- localization
- Hijri/Gregorian date display

## 3.7 Configurable methodology

Different schools use different:

- memorization units
- revision systems
- grading scales
- attendance policies
- curricula
- class structures
- fee models

The platform must support configuration instead of hardcoding one methodology.

---

# 4. Target Customers

## Primary

### A. Small Qur’an school

5–10 teachers, 50–200 students.

Needs:

- students
- attendance
- hifz
- parent communication
- simple fees

### B. Medium academy

10–50 teachers, 200–1,000 students.

Needs:

- scheduling
- teacher management
- analytics
- assessments
- finance
- role permissions

### C. Large organization

Multiple branches, hundreds/thousands of students.

Needs:

- centralized administration
- branch management
- standardized curriculum
- advanced reporting
- permissions
- audit logs
- consolidated finance

### D. Mosque / Qur’an circle

Small group.

Needs:

- attendance
- student records
- memorization
- simple communication

---

# 5. Personas

## 5.1 Owner

Goals:

- know whether the school is healthy
- monitor student progress
- control finances
- manage staff
- grow the school

Pain:

- WhatsApp
- paper records
- Excel
- fragmented information
- no visibility

## 5.2 Administrator

Goals:

- enroll students
- organize classes
- manage schedules
- collect payments
- communicate with parents

## 5.3 Academic Supervisor

Goals:

- monitor teachers
- monitor curriculum
- inspect student progress
- review assessments
- identify weak students

## 5.4 Qur’an Teacher

Goals:

- know today's students
- know each student's assignment
- record tasmiʿ quickly
- track mistakes
- plan revision
- give feedback

Pain:

- paperwork
- repetitive data entry
- forgetting revision history
- difficult parent reporting

## 5.5 Parent / Guardian

Goals:

- know whether child attended
- know what was memorized
- know what needs revision
- receive teacher feedback
- pay fees

## 5.6 Student

Goals:

- know today's lesson
- know revision tasks
- see progress
- prepare for exams
- stay motivated

## 5.7 Finance Staff

Goals:

- invoices
- payments
- receipts
- outstanding balances
- financial reports

---

# 6. Roles & Permissions

Base roles:

- Owner
- Super Admin
- Branch Manager
- Academic Supervisor
- Teacher
- Assistant Teacher
- Reception/Admin
- Finance
- Parent
- Student

Permissions should be granular.

Examples:

- students.view
- students.create
- students.edit
- students.archive
- attendance.view
- attendance.manage
- hifz.view
- hifz.manage
- assessments.create
- assessments.approve
- teachers.view
- teachers.manage
- finance.view
- invoices.create
- payments.record
- reports.view
- settings.manage

Permissions must support:

- organization scope
- branch scope
- class scope
- assigned-student scope

---

# 7. Organization Model

An organization can contain:

- branches
- users
- students
- guardians
- teachers
- programs
- classes
- rooms
- schedules
- financial accounts
- curricula

Hierarchy:

Organization
→ Branch
→ Program
→ Class
→ Teacher
→ Students

A user can belong to multiple scopes.

---

# 8. Student Lifecycle

## Lifecycle states

1. Lead
2. Applicant
3. Application submitted
4. Placement assessment
5. Accepted
6. Enrolled
7. Active
8. Suspended
9. Graduated
10. Withdrawn
11. Archived

## Admission workflow

1. Create application
2. Collect student information
3. Add guardian
4. Record previous Qur’an education
5. Schedule placement assessment
6. Evaluate reading/tajwid/hifz
7. Determine level
8. Accept/reject/waitlist
9. Assign class
10. Assign teacher
11. Create learning plan
12. Activate student

---

# 9. Student Profile

Student profile sections:

## Identity

- full name
- preferred name
- gender
- date of birth
- profile photo
- student ID
- nationality
- language
- contact information

## Guardian

- parent/guardian
- relationship
- phone
- email
- emergency contact
- communication preferences

## Education

- school level
- previous Qur’an education
- current Qur’an level
- reading level
- tajwid level
- memorization level

## Enrollment

- branch
- program
- class
- teacher
- enrollment date
- status

## Learning

- current assignment
- memorized range
- revision range
- retention strength
- tajwid score
- fluency score
- latest assessment

## Attendance

- attendance rate
- absences
- late arrivals
- excuses

## Finance

- fee plan
- invoices
- paid amount
- balance
- discounts

## Notes

- academic notes
- administrative notes
- safeguarding notes with restricted access

---

# 10. Qur’an Domain Model

The canonical Qur’an dataset should contain:

- Surah
- Ayah
- Juz
- Hizb
- Rubʿ
- Page
- optional manzil
- optional sajdah markers
- optional revelation metadata

A passage is represented by:

- start surah
- start ayah
- end surah
- end ayah

Never store important Qur’an progress only as free text.

## Example

Student has memorized:

Al-Baqarah 1 → 20

System should know:

- exact verses
- page coverage
- juz coverage
- hizb coverage
- percentage
- previous assessments
- revision history

---

# 11. Memorization / Hifz

## Statuses

A passage can have:

- Not started
- Assigned
- In progress
- Memorized
- Passed
- Strong
- Needs revision
- Weak
- Relearning

Important distinction:

> "Memorized" does not automatically mean "strongly retained."

## Hifz plan

Each student can have:

- target
- daily target
- weekly target
- monthly target
- planned completion date
- actual completion date

## Assignment

Teacher creates:

- new lesson
- passage
- due date
- expected quality
- notes

Assignment status:

- assigned
- practiced
- submitted
- assessed
- passed
- needs retry
- cancelled

---

# 12. Tasmiʿ

Tasmiʿ is the core operational event.

A session records:

- student
- teacher
- date/time
- passage
- session type
- duration
- score
- errors
- notes
- outcome

Session types:

- new memorization
- revision
- comprehensive revision
- exam
- placement
- competition

## Evaluation dimensions

Configurable, but default:

- memorization accuracy
- tajwid
- fluency
- pronunciation
- confidence
- stopping/starting
- teacher overall rating

## Error types

Examples:

- omission
- addition
- substitution
- hesitation
- repeated mistake
- tajwid error
- pronunciation error
- stopping error
- starting error

Each error should optionally reference:

- surah
- ayah
- word/location
- category
- severity
- resolved status

---

# 13. Revision / Murājaʿah

Revision must be a first-class module.

Each student has:

- revision pool
- due passages
- overdue passages
- weak passages
- recently passed passages
- review frequency

The system should support configurable revision models.

## Example

Daily:

- today's new lesson
- yesterday's lesson
- recent week
- old memorization

The school can configure:

- daily
- weekly
- spaced
- teacher-defined

## Revision statuses

- due
- completed
- strong
- weak
- failed
- rescheduled

---

# 14. Tajwid

Track:

- rule knowledge
- practical application
- pronunciation
- makharij
- fluency

Schools can define their own tajwid curriculum.

Each topic can have:

- lesson
- prerequisite
- learning objective
- assessment
- mastery status

---

# 15. Curriculum

A curriculum consists of:

- levels
- units
- lessons
- learning objectives
- required memorization
- tajwid topics
- Islamic studies
- optional Arabic/literacy subjects

Example:

Level 1
→ Reading foundations
→ Short surahs
→ Basic tajwid

Level 2
→ Juz Amma
→ Tajwid intermediate

Level 3
→ Juz Tabarak
→ advanced revision

The curriculum must be configurable.

---

# 16. Classes

A class contains:

- name
- branch
- program
- level
- teacher
- assistant
- room
- capacity
- students
- schedule
- curriculum

Support:

- recurring classes
- temporary sessions
- substitute teachers
- split groups
- merged groups

---

# 17. Scheduling

Scheduling engine handles:

- teacher availability
- room availability
- student availability
- class timetable
- holidays
- Ramadan schedules
- exceptions
- substitutions

Conflict detection:

- teacher double-booked
- room double-booked
- student double-booked
- capacity exceeded

---

# 18. Attendance

Attendance statuses:

- present
- late
- absent
- excused
- left early

Attendance can be recorded:

- per class
- per session
- manually
- optionally QR-based

Teacher should be able to mark attendance in seconds.

Automatic notifications can trigger after configurable absence thresholds.

---

# 19. Assessments & Exams

Assessment types:

- placement
- daily
- weekly
- monthly
- semester
- final
- comprehensive hifz
- tajwid
- competition

Assessment contains:

- student
- evaluator
- scope
- rubric
- score
- mistakes
- comments
- result
- date

Results:

- pass
- fail
- conditional
- needs improvement

---

# 20. Certificates

Certificate system supports:

- completion
- level completion
- hifz completion
- participation
- competition
- excellence

Template fields:

- student name
- achievement
- date
- organization
- branch
- teacher
- authorized signature
- certificate number

PDF generation should be supported.

---

# 21. Teacher Management

Teacher profile:

- identity
- contact
- qualifications
- Qur’an certifications
- ijazah information
- tajwid specialization
- employment status
- assigned branches
- assigned classes
- schedule

Teacher dashboard:

- today's classes
- students
- pending assignments
- due revisions
- attendance
- recent tasmiʿ
- alerts

Teacher performance analytics should avoid reducing Qur’an teaching to simplistic productivity metrics.

---

# 22. Parent Portal

Parents can:

- view children
- see today's attendance
- see memorization progress
- see recent tasmiʿ
- see teacher comments
- see revision tasks
- see schedule
- receive announcements
- view invoices
- make payments where supported
- download receipts
- contact school

Parents should not edit academic records.

---

# 23. Student Portal

Student can see:

- today's lesson
- revision tasks
- memorized Qur’an
- progress
- streaks
- upcoming assessments
- attendance
- teacher feedback
- achievements

Optional gamification:

- milestones
- badges
- completion percentages
- consistency streaks

Gamification must not encourage unhealthy competition.

---

# 24. Communication

Channels:

- in-app notifications
- email
- SMS
- push notifications
- optional WhatsApp integration where legally/technically appropriate

Message types:

- absence
- assignment
- assessment
- announcement
- payment reminder
- schedule change
- achievement
- emergency

Communication log:

- sender
- recipient
- channel
- timestamp
- status
- message type

---

# 25. Notifications

Notification engine supports:

- immediate notifications
- scheduled notifications
- recurring reminders
- templates
- audience rules

Examples:

"When a student is absent twice in one week, notify guardian."

"When payment is overdue by 7 days, notify guardian."

"When a student passes a level, notify parent."

---

# 26. Finance

Finance is optional for MVP but important for the complete platform.

Support:

- fee plans
- invoices
- payments
- discounts
- scholarships
- refunds
- late fees
- receipts
- outstanding balances
- financial periods

Fee models:

- monthly
- semester
- yearly
- per program
- sibling discount
- scholarship
- custom

Payment statuses:

- pending
- partial
- paid
- overdue
- cancelled
- refunded

---

# 27. Donations

Optional module:

- donor
- donation
- campaign
- amount
- date
- payment method
- restricted/unrestricted fund

Do not mix student tuition and donations conceptually.

---

# 28. Facilities

Manage:

- branches
- rooms
- classrooms
- capacity
- equipment
- availability
- maintenance

---

# 29. Inventory

Optional:

- Qur’an copies
- books
- uniforms
- stationery
- devices
- equipment

Track:

- quantity
- location
- assignment
- condition
- purchase
- maintenance

---

# 30. Documents

Documents:

- student documents
- guardian documents
- teacher certifications
- certificates
- invoices
- school policies

Access must be permission-controlled.

---

# 31. Safeguarding

The system should support:

- emergency contacts
- authorized pickup
- restricted notes
- incident records
- safeguarding roles
- access logs

Sensitive safeguarding information must not be visible to ordinary teachers unless explicitly authorized.

---

# 32. Dashboards

## Owner dashboard

Widgets:

- total students
- active students
- attendance rate
- memorization activity
- students at risk
- teacher workload
- revenue
- outstanding fees
- upcoming exams
- branch comparison

## Supervisor dashboard

- teacher activity
- student progress
- weak students
- curriculum completion
- assessment results
- attendance anomalies

## Teacher dashboard

- today's schedule
- today's students
- pending tasmiʿ
- revision due
- attendance
- recent notes

## Parent dashboard

- children
- today's status
- progress
- feedback
- fees

---

# 33. Analytics

Core metrics:

### Student

- memorized amount
- retained/strong amount
- revision completion
- attendance
- average assessment
- progress velocity
- consistency

### Teacher

- students managed
- sessions completed
- attendance recording
- assignment completion
- student progress distribution

Avoid using raw number of sessions as a quality metric.

### School

- enrollment
- retention
- attendance
- completion
- revenue
- outstanding payments
- teacher utilization
- class utilization

---

# 34. At-Risk Engine

The platform should identify students needing attention.

Signals:

- repeated absences
- declining scores
- increasing mistakes
- missed assignments
- revision backlog
- unusually slow progress
- long inactivity
- payment issues

Risk levels:

- normal
- attention
- high risk

The system should explain why a student is flagged.

Example:

"Attention: revision backlog increased from 3 to 11 passages over the last 14 days."

---

# 35. AI

AI should be assistive.

Potential features:

- summarize teacher notes
- generate parent-friendly progress summaries
- identify patterns in progress data
- suggest revision priorities
- draft announcements
- natural-language reporting
- OCR of paper records
- voice-to-text for teacher notes
- pronunciation assistance
- audio analysis as an experimental feature

AI must never be positioned as replacing a qualified Qur’an teacher.

Any Qur’an correctness evaluation must be treated as assistive and subject to human verification.

---

# 36. Search

Global search should cover:

- students
- parents
- teachers
- classes
- invoices
- assessments
- Qur’an passages

Search filters:

- branch
- class
- teacher
- level
- status
- date

---

# 37. Reports

Reports:

- student progress
- memorization
- revision
- attendance
- teacher activity
- class performance
- assessments
- financial
- enrollment
- withdrawals
- certificates
- parent communication

Exports:

- PDF
- CSV
- Excel

---

# 38. Audit Logs

Track:

- login
- record creation
- record changes
- deletions
- permission changes
- financial actions
- academic record modifications

Audit event:

- actor
- action
- entity
- old value
- new value
- timestamp
- IP/device metadata where appropriate

---

# 39. Data Model

Core entities:

Organization
Branch
User
Role
Permission
Student
Guardian
StudentGuardian
Teacher
Program
Level
Curriculum
CurriculumUnit
Class
ClassEnrollment
Room
Schedule
Attendance
QuranSurah
QuranAyah
QuranJuz
QuranHizb
QuranRub
QuranPage
MemorizationPlan
MemorizationAssignment
TasmiSession
TasmiError
RevisionPlan
RevisionItem
TajwidTopic
TajwidAssessment
Assessment
AssessmentResult
Exam
Certificate
Notification
Message
Invoice
InvoiceItem
Payment
Discount
Scholarship
Donation
Document
Incident
AuditLog

Important relationships:

Student → many guardians  
Student → many enrollments  
Student → many assignments  
Student → many tasmi sessions  
Student → many revision items  
Student → many assessments  
Teacher → many classes  
Teacher → many students  
Class → many students  
Class → schedule entries  
Organization → many branches

---

# 40. API Requirements

API style can be REST or GraphQL.

Recommended initial approach:

REST + OpenAPI.

Examples:

GET /students
POST /students
GET /students/:id
PATCH /students/:id
POST /students/:id/enrollments
GET /students/:id/progress
GET /students/:id/revision
POST /assignments
POST /tasmi-sessions
POST /tasmi-sessions/:id/errors
POST /attendance
GET /classes/:id/students
GET /dashboard
GET /reports/progress

API requirements:

- authentication
- authorization
- pagination
- filtering
- sorting
- validation
- idempotency for critical writes
- audit logging
- rate limiting

---

# 41. Mobile Architecture

Teacher mobile app should prioritize:

1. Today
2. Students
3. Tasmiʿ
4. Attendance
5. Revision
6. Notifications

Offline:

- cache assigned students
- cache today's schedule
- cache recent student profiles
- create tasmi sessions offline
- create attendance offline
- queue sync
- resolve conflicts

---

# 42. Security

Requirements:

- encrypted transport
- secure password hashing
- MFA for administrators
- session management
- RBAC
- tenant isolation
- least privilege
- secure file storage
- backups
- audit logs
- data deletion workflows
- privacy controls

Multi-tenancy must prevent cross-organization data access.

---

# 43. Non-Functional Requirements

Performance:

- dashboard initial load target < 2.5 seconds under normal conditions
- teacher save action should feel immediate
- pagination for large datasets

Availability:

- production target 99.9%+ when mature

Accessibility:

- WCAG-oriented
- keyboard support
- readable typography
- sufficient contrast
- touch-friendly controls

Localization:

- Arabic RTL
- English
- French

---

# 44. MVP

## Must have

- authentication
- organization setup
- users/roles
- students
- guardians
- teachers
- classes
- attendance
- Qur’an structure
- hifz assignments
- tasmiʿ
- revision
- teacher dashboard
- owner dashboard
- parent progress view
- notifications
- basic reports
- audit logs

## Phase 2

- finance
- exams
- certificates
- curriculum builder
- scheduling engine
- student portal
- advanced analytics
- offline mode
- multi-branch

## Phase 3

- donations
- inventory
- facilities
- advanced AI
- payment integrations
- advanced communication integrations
- public website
- marketing/CRM

---

# 45. Critical MVP Workflow

Teacher:

1. Login
2. See today's classes
3. Open class
4. Mark attendance
5. Open student
6. See today's assignment
7. Listen to tasmiʿ
8. Record result
9. Record mistakes
10. System updates progress
11. System generates revision recommendation
12. Teacher confirms next assignment
13. Parent receives notification

This workflow is the heart of the product.

---

# 46. Acceptance Criteria

## Student

A student can be created, assigned to a guardian, enrolled in a class, assigned a teacher, and viewed from all authorized interfaces.

## Hifz

Teacher can assign a Qur’an passage using structured Qur’an references.

## Tasmiʿ

Teacher can record a session, score it, record mistakes and save it without navigating through multiple unnecessary screens.

## Revision

A passed memorization passage can automatically become eligible for revision according to configured rules.

## Attendance

Teacher can mark a whole class quickly and modify individual attendance.

## Parent

Parent can see accurate progress after teacher submission.

## Permissions

A teacher cannot access students outside their authorized scope.

## Multi-tenancy

Organization A cannot access organization B data.

---

# 47. Product Success Metrics

North-star metric:

> Percentage of active students whose learning loop is consistently recorded.

Supporting metrics:

- weekly active teachers
- percentage of sessions recorded digitally
- attendance recording rate
- assignment completion
- revision completion
- parent weekly engagement
- student retention
- school retention
- onboarding time
- time required to record a tasmiʿ session

---

# 48. Key Product Risks

## Risk: Too many features

Mitigation:

Start with hifz + tasmiʿ + revision + attendance.

## Risk: Teachers reject the system

Mitigation:

Mobile-first, extremely fast workflows.

## Risk: Generic school software

Mitigation:

Qur’an-native data model.

## Risk: Incorrect Qur’an data

Mitigation:

Use a trusted canonical dataset and version it.

## Risk: AI overreach

Mitigation:

Human-in-the-loop.

## Risk: Privacy

Mitigation:

Strong permissions and tenant isolation.

---

# 49. Final Product Definition

The product is not primarily a database.

It is a daily operating system for Qur’an schools.

The core promise:

> "At any moment, the owner knows how the school is doing, the teacher knows what each student needs today, the student knows what to study, and the parent knows how their child is progressing."

