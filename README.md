# FarrierLog

**FarrierLog** is an offline-first business management app for farriers and field-service professionals, built with Flutter for Android.

Developed by **Rogue Business Apps**.

---

## What It Does

FarrierLog helps a working farrier run their business from their phone:

- **Client management** — full client list with contact info, address, and visit history
- **Horse/animal records** — breed, color, age, shoeing notes, linked to their owner
- **Visit scheduling** — calendar view, recurring appointments, auto-generated future visits
- **Service lines** — itemized services per visit with pricing, group services, headcount billing
- **Travel and charges** — mileage, tolls, reimbursements tracked per visit
- **Invoicing** — PDF invoice generation, printing, and sharing
- **Photo history** — photos tagged to individual animals, displayed as a chronological progression with elapsed time between shoeings and visit notes in context
- **Export and backup** — full CSV export and zip backup/restore of all data and media files

---

## Platform

- **Primary target:** Android (Google Play)
- **Application ID:** `com.seitzelectric.farrierlog`
- Flutter desktop/iOS scaffolding present but not the primary target

---

## Architecture

- **Offline-first.** SQLite via `sqflite` is the only persistence layer. No backend, no cloud sync, no accounts required.
- **No state management library.** Each screen loads its own data from `DatabaseService` in `initState`/`_loadData`. Screens reload after returning from pushed routes.
- **Static service pattern.** `DatabaseService`, `BackupService`, `ExportService`, and `InvoiceService` are all static-method classes.
- **Current DB version:** 8 (see `database_service.dart` → `_dbVersion`)

---

## Development Commands

```bash
flutter pub get         # install dependencies
flutter analyze         # static analysis
flutter test            # run all tests
flutter run             # run on connected device
flutter build apk       # build Android release APK
```

---

## Privacy Policy

See `PRIVACY_POLICY.md` or `docs/index.md`.
