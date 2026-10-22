# Mesh Schools — backup and recovery guide

## Added to this prototype

- Standard JSON export of the active workspace.
- Password-encrypted backup export using Web Crypto AES-GCM with a random salt and IV and PBKDF2-SHA-256 key derivation.
- Backup restore for supported JSON or encrypted JSON files.
- School ID check to help prevent restoring a different school's backup into a registered local workspace.
- Last-download status shown on the school profile page.

These are **device-side backup tools**, not an automated remote backup service. The app does not upload student records to the internet. A download is only a copy; the user must move it to a safe place. Encrypted backup needs HTTPS or localhost in a modern browser. Never lose the backup password. Test restore using a spare/test workspace before relying on it.

## What is still needed for remote backups

1. A Supabase project with Auth, verified email, password recovery and HTTPS.
2. Apply `schema.sql`, then review and apply `remote_backup_schema.sql`.
3. Replace the prototype's local-only registration/login with real Supabase Auth. The current local demo stores credentials in browser storage and is **not safe for real accounts**.
4. Create a server-controlled school registration flow that creates school and school-admin membership rows. Never expose a Supabase service-role key in HTML, JavaScript, a PWA or an APK.
5. Add a reviewed sync client: queue local changes, retry when connectivity returns, use stable record IDs and revision/version metadata, handle conflicts, and display last successful sync plus pending/error counts.
6. Encrypt backup snapshots on the client before upload. Upload only encrypted payloads to `backup_snapshots`; the database table stores metadata and ciphertext. Do not use a password entered by a school as a server-side password or store it in the database.
7. Add a scheduled server-side backup policy, retention rules, storage monitoring, alerts, restore verification and periodic recovery drills. Database provider backups alone are not a substitute for tested school-level restore.
8. Add automated tests proving one school cannot read, update, restore or delete another school's records. Tighten teacher permissions before production; teachers should not automatically access fee records or school-wide backups.
9. Add privacy notices, consent/retention controls, audit logs, export/deletion processes and a security review before storing real student/guardian/financial information.

## Cost-conscious rollout

- **Free local pilot:** run the web app on one device and use downloaded backups; no cloud service is required. It does not provide automatic remote backup or cross-device synchronization.
- **Free-tier cloud pilot:** Supabase and a static host may be used within their free-tier limits. Free plans can change and may have quotas, inactivity limits, storage limits or no service-level guarantee. Keep a second independent backup.
- **Android distribution:** a PWA can be installed from a website without a Play Store listing. A signed APK can be shared directly, but producing/releasing it requires an Android build setup and signing key. Play Store distribution may require a one-time developer registration fee and verification.
- **Unavoidable in practice:** internet/data for remote backup, time to configure and test the backend, and eventual hosting/storage or maintenance cost as usage grows. No service can guarantee unlimited production hosting at $0.

## Safe restore procedure

1. Confirm the school name and current school account.
2. Download a fresh backup of the current data first.
3. Select **School profile → Restore backup** and choose the backup file.
4. Enter the encryption password if prompted.
5. Confirm the replacement warning.
6. Verify a sample of students, marks, attendance, fees and report cards before continuing.

Do not use this prototype for real student records until secure authentication and backend policies have been implemented and tested. The current local registration form is demonstrative only.
