# Money Manager Privacy Policy

Last updated: November 5, 2026

Money Manager ("the app") is an open-source personal finance tracker for iOS and Android. This policy explains what data the app handles and where it goes.

**In short:** your financial data never leaves your device. The app has no account and no server of its own. It does send usage statistics to Google Firebase Analytics and crash reports to Sentry, as described below.

## Data that stays on your device

Everything you enter in the app is stored only on your device:

- wallets, transactions, categories, amounts and notes
- settings and preferences
- your passcode, which is kept in the device's secure storage (Keychain on iOS, Keystore on Android)

We can't see this data. It is deleted when you uninstall the app.

If you unlock the app with Face ID, Touch ID or a fingerprint, your device's operating system does the check. The app only learns whether it succeeded and never receives your biometric data.

### Backups

When you export a backup, the app creates a JSON file with all your data and opens the system share sheet. You choose where the file goes, for example the Files app, a cloud drive or a message. Once you save or send it, that app or service handles it, not Money Manager. Importing a backup reads a file you pick and doesn't send it anywhere.

## Data sent to third parties

Apart from the two services below, the app doesn't connect to the internet.

### Usage statistics (Google Firebase Analytics)

The app uses Firebase Analytics, a Google service, to learn which screens people use. It sends:

- the name of each screen you open and the screen you came from
- events that Firebase records automatically, such as the first time you open the app, the start of a session, how long you use the app, and app and operating system updates
- device and app information: device model, operating system version, app version and language
- an identifier for your installation of the app and, on iOS, the identifier for vendors
- on Android, your device's advertising ID, if your device makes it available
- your approximate location (country, region and city), which Google estimates from your IP address

It doesn't include your transactions, amounts, notes, or wallet and category names.

Google keeps this data linked to your installation for 2 months. After that, it remains only in aggregated reports. See [Google's Privacy Policy](https://policies.google.com/privacy) and [Privacy and Security in Firebase](https://firebase.google.com/support/privacy).

### Crash reports and feedback (Sentry)

The app uses [Sentry](https://sentry.io) to find and fix bugs. When the app crashes or hits an error, it sends a report with:

- the error and where in the app's code it happened
- your recent activity before the error: the screens you opened and the labels of buttons you tapped
- device and app information: device model and name, operating system, language, time zone, memory and storage, and app version
- your IP address

Sentry also records when app sessions start and end, so we can see how often the app crashes.

Crash reports aren't meant to contain your financial data. In rare cases, an error message or a button label can include text from your data, such as a wallet or category name.

If you use **Send Feedback**, the app sends your message to Sentry, along with a name and email address if you enter them. Both are optional.

Sentry deletes crash reports and feedback automatically after at most 90 days. See [Sentry's Privacy Policy](https://sentry.io/privacy/).

## What we don't do

- We don't sell your data.
- We don't use your data for advertising, and the app has no ads.
- We don't share your data with anyone except the two services above.

## Your choices

- The app doesn't currently have a setting to turn off usage statistics or crash reports.
- On Android, you can reset or delete your advertising ID in your device settings.
- Because the app has no account, we can't tell which data in Firebase or Sentry is yours. If you sent feedback and want it deleted, email us from the address you used, or tell us roughly when you sent it.
- Uninstalling the app deletes all the data it stored on your device.

## Children

The app isn't directed at children under 13, and we don't knowingly collect data from them.

## Changes to this policy

If this policy changes, we'll update this page and the date at the top.

## Contact

If you have questions about this policy, email [sikv.dev@gmail.com](mailto:sikv.dev@gmail.com).

The app's source code is available at [github.com/SIKV/MoneyManager](https://github.com/SIKV/MoneyManager).
