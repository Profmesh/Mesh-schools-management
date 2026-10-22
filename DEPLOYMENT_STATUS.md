# Deployment and backup status

- Responsive website prototype: included.
- PWA manifest, icons, and service worker: included.
- Local JSON backup and restore: included.
- Password-encrypted local backup and restore (AES-GCM via Web Crypto): included.
- Remote backup schema starter: included in `remote_backup_schema.sql`; it is not connected to the UI yet.
- Remote automated backups / cross-device synchronization: not connected.
- Live public website: not deployed; requires a hosting account and deployment.
- Compiled Android APK: not included; requires an Android build environment and signing.
- Production authentication: not connected. The local demo registration stores credentials in browser storage and must not be used for real accounts.

Do not enter real student, guardian or financial data until secure authentication, remote sync, access controls, retention, backups and restore procedures are configured and independently tested.
