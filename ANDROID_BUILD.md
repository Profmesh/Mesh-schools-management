# Android app build path

This package includes a Progressive Web App (PWA) and a Capacitor configuration starter. It does **not** contain a compiled APK. A signed APK/AAB must be built using Android Studio/Android SDK, then tested on devices.

## Install the website as an app (after HTTPS hosting)
1. Deploy this folder to an HTTPS host. Netlify can deploy it by importing the folder/repository; `netlify.toml` publishes the current folder.
2. On Android, open the deployed site in Chrome.
3. Open Chrome's menu and choose **Install app** or **Add to Home screen**.

## Native Android package
For a native Android wrapper, use a machine with Node.js and Android Studio/SDK:
1. Create a Capacitor project or integrate this frontend into a Capacitor project.
2. Put the web assets in the configured `www/` folder.
3. Install `@capacitor/core`, `@capacitor/cli`, and `@capacitor/android`, then run `npx cap add android` and `npx cap open android`.
4. Build and sign an APK/AAB in Android Studio.

The included `capacitor.config.json` is a configuration starter; it does not itself create an APK.

## Before real schools use it
The current UI is a local demo. School registrations and records remain in that browser and are not shared or securely authenticated. Do not enter real student or payment data. Configure the Supabase backend, enforce authentication and row-level access, connect the frontend to it, and test tenant isolation before launch.
