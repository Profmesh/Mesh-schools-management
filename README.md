# Mesh Schools Management — MVP starter

A responsive, installable web-app prototype for a multi-school management system, designed to work on desktop browsers and Android browsers/PWA. It includes an interactive local demo and a starter PostgreSQL/Supabase schema for the production backend.

## Included in this package

- `index.html` — responsive app UI and interactive local demo
- `manifest.json`, `sw.js` — PWA install/offline shell support
- `schema.sql` — initial multi-tenant database schema with school-membership RLS policies
- `remote_backup_schema.sql` — reviewed starter tables and RLS policies for encrypted school backup snapshots and backup audit events
- `BACKUP_AND_SYNC.md` — backup, restore, remote sync and zero-cost rollout guide
- `WORKBOOK_MAPPING.md` — mapping from the provided `mesh systems.xlsm` workbook to app modules

## Try the demo

1. Unzip this folder.
2. Open `index.html` in a modern browser, or serve the folder locally (recommended for PWA features):
   - Python: `python -m http.server 8000`
   - Then open `http://localhost:8000`.
3. Select **Explore demo workspace**.
4. Try Students, Teachers, Marks entry, Report cards, Attendance, Fees & payments, Timetables and School profile.
5. Add/edit/delete sample records; export CSVs; download a JSON backup, download a password-encrypted backup, and test restoring a backup from School profile.

The demo saves data in the browser's local storage. Standard and password-encrypted backup downloads can be restored on the device. Remote upload and automatic cross-device sync are not connected. School registration in this preview is local to the current browser and is NOT secure multi-user authentication.

## Production path (required before real schools use it)

1. Create a Supabase project and configure Auth with email verification and password reset.
2. Review and apply `schema.sql` in the project's SQL editor.
3. Implement school registration using a trusted server/Edge Function that creates a school in `pending` status and its initial `school_admin` membership.
4. Add server-enforced role permissions: platform administrator, school administrator and teacher. Teachers should only see assigned classes/subjects and must not manage fees or memberships unless explicitly allowed.
5. Replace local-storage operations with authenticated Supabase API calls; never place a service-role key in the browser/app.
6. Add production-grade validation, backups, audit logs, password recovery, consent/privacy notices, rate limiting and testing of cross-school isolation.
7. Deploy the website over HTTPS. The PWA can be installed from Chrome on Android. For a Play Store app, wrap the same responsive web app with Capacitor or build a native client against the same backend.
8. For fees, add a payment provider integration only after choosing the provider and implementing verified server-side payment callbacks/receipts. This prototype only records payment entries; it does not process money.

## Workbook notes

The workbook contains `Setup`, `Students`, `Marksentry`, `Reportcard`, and `Dashboard` sheets. Its setup includes a 2026 academic year, school profile fields, grade/points/remarks, classes and class teachers. Marks entry includes nine subject columns and totals. Some formulas use Excel `XLOOKUP` and array formulas; these should be reimplemented and verified in the app rather than copied as spreadsheet formulas. The prototype has illustrative grade bands only; configure each school's approved grading policy before use.

## Important

This is a working front-end prototype and backend starter, not a hosted production system. Do not enter real student, guardian, financial or other sensitive data until secure authentication, database policies, remote sync, backups, restore tests and privacy controls have been configured and independently tested. See `BACKUP_AND_SYNC.md`.
