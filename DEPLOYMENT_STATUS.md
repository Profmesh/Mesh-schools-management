# Deployment and database status

- Responsive school-management prototype: included.
- Local database: configured with browser `localStorage` under the key `meshSchoolsDB`; school workspaces and app records are saved on the same browser/device.
- Record forms call the local save routine; save failures now display a warning instead of reporting a successful record save.
- JSON backup and restore: included. Password-encrypted JSON backup and restore: included (requires HTTPS or localhost).
- PWA manifest and service worker: included, with relative paths intended to support GitHub Pages project URLs. Offline shell must be tested on the published site after updated files are uploaded.
- Remote database, automated cloud backups and cross-device sync: not connected.
- Production authentication: not connected. Local demo registration stores the password in browser storage; this is not secure authentication.

## Important limits

The local database works only in the same browser profile on the same device and website origin. Opening the HTML file directly, using another browser, or using another device creates a separate storage area. Clearing browser/site data, losing the device, or storage corruption can destroy local records. Download and safely store backups regularly; test restore before relying on the system.

Do not enter real student, guardian or financial data until secure authentication, access controls, backups and restore procedures have been reviewed and tested. This is a prototype, not a production school records system.
