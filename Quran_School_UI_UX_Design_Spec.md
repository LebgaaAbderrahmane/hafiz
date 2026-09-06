# UI/UX DESIGN SPECIFICATION — Qur’an School Management Platform

**Version:** 1.0  
**Date:** 2026-09-06  
**Purpose:** Implementation-ready UI/UX foundation for Figma and frontend development.

---

# 1. Design Goal

Create a modern, calm, trustworthy Qur’an education platform.

The interface should feel:

- Islamic without being ornamental
- modern without being corporate
- educational without looking childish
- professional enough for school administrators
- extremely fast for teachers
- simple enough for parents

The product must prioritize clarity over decoration.

---

# 2. Design Philosophy

## Primary rule

> Every screen should answer: "What do I need to do next?"

## UX priorities

1. clarity
2. speed
3. trust
4. hierarchy
5. accessibility
6. consistency

Avoid:

- excessive cards
- excessive gradients
- unnecessary animations
- decorative Arabic calligraphy everywhere
- complicated dashboards
- deep navigation
- huge forms

---

# 3. Platform Strategy

## Web

For:

- owners
- administrators
- supervisors
- finance
- teachers

## Mobile

Primary:

- teachers
- parents
- students

Responsive web should still work on mobile.

---

# 4. Global Navigation

## Admin navigation

Sidebar:

- Dashboard
- Students
- Classes
- Teachers
- Qur’an Progress
- Attendance
- Assessments
- Schedule
- Communication
- Finance
- Reports
- Certificates
- Documents
- Settings

## Teacher navigation

Bottom navigation on mobile:

- Today
- Students
- Attendance
- Revision
- More

## Parent navigation

- Home
- Progress
- Schedule
- Messages
- More

---

# 5. Global Layout

Desktop:

- sidebar: 248px
- top bar: 64px
- content max-width: 1440px
- page padding: 24–32px

Tablet:

- collapsible sidebar

Mobile:

- top bar
- bottom navigation
- full-width content
- 16px horizontal padding

---

# 6. Design Tokens

## Spacing

Use a 4px base system.

4
8
12
16
20
24
32
40
48
64

## Radius

- small: 8px
- medium: 12px
- large: 16px
- cards: 16px
- dialogs: 20px
- pill: 999px

## Typography

Recommended:

Arabic:

- IBM Plex Sans Arabic
- Noto Sans Arabic

Latin:

- Inter
- IBM Plex Sans

Qur’an text:

Use a dedicated verified Qur’anic font/rendering system rather than normal UI typography.

Typography scale:

- Display: 32–40
- H1: 28–32
- H2: 22–24
- H3: 18–20
- Body: 14–16
- Caption: 12–13

---

# 7. Color System

Use a restrained palette.

## Primary

Deep Qur’anic green.

Use for:

- primary actions
- active navigation
- progress
- positive states

## Neutral

Warm/neutral grayscale.

Use:

- page background
- surfaces
- borders
- text

## Semantic

Success
Warning
Error
Info

Do not rely on color alone.

Every semantic state should have:

- icon
- text
- optional color

---

# 8. Core Components

Build a component library before building all screens.

Components:

- Button
- IconButton
- Input
- Select
- Combobox
- Search
- DatePicker
- TimePicker
- Checkbox
- Radio
- Switch
- Tabs
- Badge
- Avatar
- Tooltip
- Card
- Table
- DataTable
- EmptyState
- Skeleton
- Modal
- Drawer
- Toast
- Alert
- Dropdown
- Pagination
- Breadcrumb
- ProgressBar
- ProgressRing
- Timeline
- Calendar
- Stepper
- FileUploader
- AudioPlayer
- Qur’anRangePicker

---

# 9. Special Qur’an Components

## Qur’an Range Picker

This is a critical component.

Allow selection by:

- surah + ayah
- page
- juz
- hizb
- rubʿ

Example:

From:
Al-Baqarah — 1

To:
Al-Baqarah — 20

Show:

- pages
- juz
- estimated size

## Memorization Map

Visual representation:

Surah list with progress.

Example:

Al-Fatihah 100%
Al-Baqarah 42%
Aal Imran 0%

## Revision Heatmap

Show:

- strong
- due
- overdue
- weak

## Tasmiʿ Evaluation Panel

Fast input:

Pass
Needs Revision
Fail

Then:

- accuracy
- tajwid
- fluency
- errors
- note

---

# 10. Authentication Screens

## Login

Fields:

- email/phone
- password

Actions:

- Login
- Forgot password

Optional:

- Google/Apple authentication

Design:

Minimal.

No dashboard-style marketing content.

## First-time organization setup

Wizard:

1. Organization
2. Branch
3. Academic setup
4. Qur’an methodology
5. Add teachers
6. Add first class
7. Import students

---

# 11. Owner Dashboard

## Header

"Good morning, [Name]"

Date.

Branch selector.

## KPI row

- Active students
- Attendance
- Memorization activity
- Outstanding fees

## Main area

### Student attention

List:

- student
- issue
- severity
- action

Example:

"Ahmed — Revision backlog: 8 passages"

Button:

"Review"

### Today's activity

Timeline:

09:00 — Class A
10:00 — Class B
11:30 — Assessment

### Progress overview

Chart:

Students by progress state.

### Teacher workload

Compact table.

### Finance

- collected
- outstanding
- overdue

---

# 12. Student List

Toolbar:

- Search
- Filter
- Add student
- Import

Filters:

- branch
- class
- teacher
- level
- status
- attendance
- progress

Table:

Avatar
Name
Class
Teacher
Progress
Attendance
Status
Actions

Mobile:

Use student cards.

---

# 13. Student Profile

## Header

Avatar
Name
Student ID
Class
Teacher
Status

Actions:

- Edit
- Message guardian
- Record tasmiʿ
- Attendance

## Tabs

Overview
Qur’an
Revision
Assessments
Attendance
Schedule
Finance
Notes

---

# 14. Student Overview

Top:

Progress ring.

"12.4 Juz memorized"

Secondary:

- strong
- needs revision
- in progress

Cards:

Attendance
Latest assessment
Current assignment
Revision backlog

Timeline:

Recent learning events.

---

# 15. Student Qur’an Page

Main visualization:

Qur’an progress map.

Controls:

- Surah
- Juz
- Page

Each range displays:

- memorization state
- last tasmiʿ
- score
- revision status

Clicking a range opens details.

---

# 16. Student Revision Page

Header:

"Revision"

Summary:

- Due today
- Overdue
- Weak
- Strong

List:

Surah
Range
Last reviewed
Score
Status

Action:

"Start revision"

---

# 17. Add Student Flow

Multi-step:

### Step 1 — Identity

Name
DOB
Gender
Contact

### Step 2 — Guardian

Guardian details.

### Step 3 — Qur’an background

- reading ability
- tajwid
- memorized amount
- previous school

### Step 4 — Enrollment

Branch
Program
Level
Class
Teacher

### Step 5 — Review

Summary + Create.

---

# 18. Teacher Dashboard

The teacher experience should be radically simpler than the owner dashboard.

Header:

"Today"

Show:

- classes
- students
- pending tasmiʿ

Primary CTA:

"Start today's class"

---

# 19. Teacher Today Screen

Example:

Today — Monday

09:00
Juz Amma — Group A
12 students

09:45
Hifz — Group B
8 students

Each class:

- attendance
- open class

---

# 20. Teacher Class Screen

Header:

Class name
Teacher
Time

Student list:

Avatar
Name
Today's lesson
Attendance
Tasmiʿ status

Actions:

- Mark all present
- Start tasmiʿ

---

# 21. Teacher Student Screen

Top:

Student name
Current level

Current lesson:

Al-Mulk 1–10

Revision:

Al-Mulk 11–20

Quick actions:

- Record tasmiʿ
- Change assignment
- Attendance
- Note

---

# 22. Tasmiʿ Flow

This is the most important interface in the product.

## Screen 1

Student

Passage

Session type

"Start"

## Screen 2

Evaluation

Large controls:

PASS
NEEDS REVISION
FAIL

Scores:

Accuracy
Tajwid
Fluency

## Screen 3

Errors

Quick chips:

Omission
Substitution
Hesitation
Tajwid
Pronunciation
Stopping
Starting

Optional:

Tap verse/range.

## Screen 4

Teacher note

Textarea.

## Screen 5

Result

"Passed"

Next revision date.

Next assignment suggestion.

Button:

"Save & Next Student"

This button should be prominent.

---

# 23. Attendance UX

Teacher opens class.

Top action:

"Mark all present"

Then individual rows.

Statuses:

Present
Late
Absent
Excused

Avoid opening a modal for every student.

Use inline interaction.

---

# 24. Assignment UX

Teacher:

"Assign New Lesson"

Qur’an range picker.

Fields:

- start
- end
- due date
- target
- note

System displays:

"Estimated size: 1/2 page"

Action:

Assign.

---

# 25. Revision UX

Teacher sees:

## Due today

Student
Passage
Last score

Action:

Start

After evaluation:

Strong
Needs repetition
Weak

System proposes next date.

Teacher can override.

---

# 26. Teacher Students Page

Search.

Filters:

- class
- level
- status

Each student card:

Name
Today's lesson
Revision status
Attendance
Last score

---

# 27. Classes Page

Table:

Class
Program
Teacher
Students
Schedule
Room
Status

Actions:

- View
- Edit
- Attendance
- Schedule

---

# 28. Class Detail

Header:

Class name
Teacher
Room
Schedule

Tabs:

Students
Attendance
Curriculum
Progress
Assessments
Schedule

---

# 29. Teacher Management

Teacher table:

Avatar
Name
Role
Classes
Students
Status

Teacher profile:

- information
- qualifications
- classes
- students
- schedule
- performance
- certifications

---

# 30. Schedule

Views:

- day
- week
- month

Filters:

- branch
- teacher
- room
- class

Drag-and-drop scheduling on desktop.

Conflict warning:

"Teacher is already scheduled at 17:00."

---

# 31. Assessment Interface

Assessment setup:

- type
- students
- Qur’an scope
- rubric
- date
- evaluator

Evaluation screen:

Student
Passage
Rubric
Score
Comments

Bulk assessment should be supported.

---

# 32. Parent Home

Header:

"Assalamu alaikum"

Child selector.

Main card:

Today's status:

Present

Current lesson:

Al-Baqarah 21–30

Progress:

4.2 Juz

Then:

- teacher feedback
- revision
- upcoming schedule

---

# 33. Parent Progress

Show:

Memorized
Strong
Needs revision

Graph:

Progress over time.

Timeline:

Date
Passage
Result
Teacher comment

Use plain language.

---

# 34. Parent Attendance

Calendar.

Statuses:

Present
Late
Absent
Excused

Monthly attendance percentage.

---

# 35. Parent Finance

Show:

Current balance
Next payment
Payment history

Actions:

Pay
Download receipt

---

# 36. Student Mobile App

Home:

Today's assignment

"Al-Mulk 1–10"

Revision:

"Al-Mulk 11–20"

Progress ring.

Upcoming exam.

Achievements.

---

# 37. Notifications Center

Grouped:

Today
Earlier

Each notification:

Icon
Title
Description
Time

Examples:

"New assignment"
"Ahmed was marked absent"
"Assessment result available"

---

# 38. Communication

Inbox:

- school
- teacher
- system

Conversation:

Header
Messages
Composer

Parents cannot directly message arbitrary teachers unless school policy allows it.

---

# 39. Finance UI

Dashboard:

Revenue
Collected
Outstanding
Overdue

Invoice table:

Student
Invoice
Amount
Due date
Status

Invoice detail:

Items
Discount
Paid
Balance

---

# 40. Reports UI

Report categories:

Students
Qur’an
Attendance
Teachers
Classes
Assessments
Finance

Report builder:

Select:

- report
- branch
- date range
- filters

Actions:

Generate
Export PDF
Export Excel/CSV

---

# 41. Settings

Sections:

Organization
Branches
Users
Roles
Programs
Curriculum
Qur’an
Attendance
Assessment
Notifications
Finance
Integrations
Security

---

# 42. Empty States

Every module needs useful empty states.

Example:

"No students yet."

Primary action:

"Add your first student"

Secondary:

"Import students"

Avoid blank screens.

---

# 43. Loading States

Use skeletons for:

- dashboards
- tables
- student profiles

For teacher actions, use optimistic UI where safe.

---

# 44. Error States

Errors must explain:

What happened
Why
What to do

Bad:

"Something went wrong."

Good:

"We couldn't save this tasmiʿ session because the connection was lost. Your session is saved locally and will sync automatically."

---

# 45. Confirmation Rules

Do not ask confirmation for harmless actions.

Ask confirmation for:

- deleting students
- deleting academic records
- changing financial records
- changing permissions
- irreversible actions

---

# 46. Responsive Rules

## Desktop

Sidebar + content.

## Tablet

Collapsed sidebar.

## Mobile

Bottom navigation.

Tables become:

- cards
- horizontal scroll
- simplified columns

Teacher workflows should never require desktop.

---

# 47. Accessibility

Requirements:

- keyboard navigation
- focus states
- screen-reader labels
- large touch targets
- semantic HTML
- proper form labels
- no color-only information
- reduced motion support

Arabic RTL must be tested independently.

---

# 48. Motion

Use subtle motion only.

Examples:

- page transitions
- toast entrance
- progress updates
- modal entrance

Avoid:

- excessive bouncing
- distracting animations
- decorative motion

---

# 49. Figma File Structure

Create pages:

01 — Foundations
02 — Components
03 — Authentication
04 — Owner
05 — Admin
06 — Supervisor
07 — Teacher
08 — Parent
09 — Student
10 — Finance
11 — Reports
12 — Settings
13 — Responsive
14 — Prototypes
15 — User Flows

---

# 50. Component Naming

Use:

Button/Primary
Button/Secondary
Button/Danger

Input/Text
Input/Search
Input/Select

Card/Student
Card/Assignment
Card/Attendance
Card/Progress

Table/Students
Table/Invoices

Modal/Delete
Modal/Assessment

Navigation/Sidebar
Navigation/Bottom

Quran/RangePicker
Quran/ProgressMap
Quran/PassageCard

Tasmi/Score
Tasmi/ErrorChip
Tasmi/Result

---

# 51. Prototype Flows

Prototype these first:

## Flow A — Owner

Login
→ Dashboard
→ Student
→ Qur’an
→ Progress

## Flow B — Teacher

Login
→ Today
→ Class
→ Student
→ Tasmiʿ
→ Result
→ Next student

## Flow C — Parent

Login
→ Child
→ Progress
→ Teacher feedback

## Flow D — Admin

Login
→ Students
→ Add student
→ Placement
→ Class assignment

---

# 52. Priority Screens

Build these first:

1. Login
2. Owner dashboard
3. Student list
4. Student profile
5. Student Qur’an progress
6. Teacher Today
7. Teacher Class
8. Teacher Student
9. Tasmiʿ
10. Attendance
11. Assignment
12. Revision
13. Parent Home
14. Parent Progress
15. Class management
16. Teacher management
17. Schedule
18. Reports
19. Settings

---

# 53. Critical UX Principle: Tasmiʿ Speed

Target:

A teacher should be able to complete a basic tasmiʿ record in approximately 10–20 seconds after the recitation ends.

Default interaction:

PASS → Save & Next

Advanced details should not block the primary flow.

The teacher can add:

- errors
- notes
- detailed scoring

when necessary.

---

# 54. Critical UX Principle: Qur’an Selection

Never make teachers type:

"Al Baqarah 1 to 10"

Instead:

Select Surah
→ Select start ayah
→ Select end ayah

Display human-readable text after selection.

---

# 55. Critical UX Principle: Progressive Disclosure

Show simple information first.

Example:

Student profile:

Progress
Today's lesson
Revision
Attendance

Detailed academic history lives behind tabs.

---

# 56. Critical UX Principle: One Primary Action

Every screen should have one dominant action.

Examples:

Student list:
"Add student"

Teacher Today:
"Start class"

Tasmiʿ:
"Save & Next"

Invoice:
"Record payment"

---

# 57. Design QA Checklist

Before approving any screen:

- Does the user know where they are?
- Is the primary action obvious?
- Can the user recover from mistakes?
- Is Arabic RTL correct?
- Does mobile work?
- Is the loading state designed?
- Is the empty state designed?
- Is the error state designed?
- Are permissions respected?
- Is the screen accessible?
- Is the Qur’an data represented structurally?

---

# 58. First Figma Sprint

Do not design 100 screens immediately.

Sprint 1 should create:

### Foundations

- colors
- typography
- spacing
- icons
- grid
- shadows
- radii

### Components

- buttons
- inputs
- cards
- tables
- badges
- navigation
- modal
- toast
- progress
- Qur’an range picker
- tasmiʿ controls

### Core screens

- owner dashboard
- student profile
- teacher today
- tasmiʿ
- parent home

These five screens will establish most of the design language.

---

# 59. Final UI/UX Direction

The platform should feel like:

> a calm, modern educational operating system designed specifically around Qur’an learning.

The interface should never make the Qur’an feel like ordinary database content.

At the same time, avoid turning every screen into a religious poster.

The product's Islamic identity should primarily come from:

- respectful typography
- calm visual hierarchy
- thoughtful terminology
- Qur’an-native interactions
- appropriate Arabic support
- meaningful learning workflows

rather than decorative elements.

