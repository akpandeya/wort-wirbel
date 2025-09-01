# RFC-001: Wort-Wirbel - Final Design Specification
* Author: Avanindra Kumar Pandeya
* Status: Writing
* Date: September 1, 2025

## 1. Summary
Wort-Wirbel is an offline-first, privacy-focused web application for learning German vocabulary through spaced repetition. This document outlines the final architecture, which uses a hybrid model: a client-server architecture for managing the global word list and a client-only architecture for all user-specific data. This design provides a centrally managed vocabulary while ensuring complete user privacy and data ownership.

## 2. Core Principles
The application's design is guided by three core principles:
- **Privacy First**: User data belongs to the user. All learning progress and any personal information are stored exclusively on the client's device in the browser's IndexedDB. This data is never transmitted to or stored on the server.
- **Offline Capability**: The application is designed to be fully functional without an internet connection after the initial setup. The user can review cards and track their progress at any time. An internet connection is only required to sync updates to the global word list.
- **Data Portability**: Users have complete control over their data. The application provides clear, simple tools for users to manually export and import their entire learning progress, ensuring they are never locked into the platform.

## 3. System Architecture
The system consists of three main components: a frontend client, a backend API, and a database.

### 3.1 Client Application (Flutter Web)
The client is a web application built with Flutter. It is responsible for all user-facing functionality, including rendering the UI, managing the spaced repetition logic, and storing all user progress in the browser's IndexedDB. It also caches the global word list for offline access.

### 3.2 Backend Service (API)
The backend is a lightweight, read-only REST API. Its sole purpose is to serve the master vocabulary list to the client. It has no knowledge of users or their progress. This service will be deployed on Render as a Web Service.

### 3.3 Database (PostgreSQL)
The database is a PostgreSQL instance (hosted on Supbase) that contains the master words table. It is the single source of truth for all vocabulary content.

### 3.4 Data Flow
- On first use, the client app calls the backend API to download the entire word list and populates its local IndexedDB cache.
- For daily use, the client reads and writes all user progress directly to IndexedDB.
- Periodically, or when manually triggered, the client calls the API with a timestamp of its last sync to download only new or updated words.

## 4. Core User Experience

### 4.1 Onboarding & Initial Sync
A new user is greeted with a simple welcome screen. Upon proceeding, the app performs a one-time initial sync to download the global word list from the backend API into its local cache. This process is fast and gets the user to their first learning session immediately.

### 4.2 The Daily Learning Loop
The user's main interaction is the daily review session. The app calculates which cards are due based on the spaced repetition data stored in IndexedDB. As the user rates their recall of each card, the progress is saved instantly and locally. This entire loop is fully functional offline.

### 4.3 Data Management
The Settings screen provides two distinct data management functions:
- **Check for Word Updates**: This button connects to the backend API to sync the local vocabulary cache with the master list. This requires an internet connection.
- **Backup & Restore Progress**: These functions allow the user to export their entire learning history to a local JSON file and import it back into the app. This process is entirely local and does not involve the server.

## 5. Technical Implementation Details

### 5.1 Client-Side (Flutter App) Architecture
The Flutter application will be structured using Domain-Driven Design principles with a layered architecture. Data access will be handled by two distinct repository implementations:
- **ApiWordRepository**: Implements the `IWordRepository` interface and is responsible for all HTTP calls to the backend API to sync the word list.
- **IndexedDbUserProgressRepository**: Implements the `IUserProgressRepository` interface and handles all create, read, and update operations for user progress in the browser's IndexedDB.

### 5.2 Backend API Specification
The backend will expose one primary endpoint:
- `GET /words`: Returns a list of word objects.
  - Query Parameter: `updated_since={timestamp}`. If provided, the API will only return words that have been created or modified after the given ISO 8601 timestamp.

### 5.3 Database Schema
The PostgreSQL database will contain a single main table (Final structure TBD):
- `words`
  - `id` (Primary Key)
  - `german` (text)
  - `english` (text)
  - `level` (text, e.g., "A1")
  - `example_sentence` (text)
  - `created_at` (timestamp)
  - `updated_at` (timestamp)

The database will contain no tables for users, user progress, or any other personal data.

## 6. Future & Operational Considerations (Informational)
(This section summarizes optional clarifications and extensions considered during review.)

### 6.1 Sync & Versioning
- Use UTC ISO 8601 timestamps with `Z` suffix.
- Consider future support for deletions via `deleted_at` or a separate deletions feed.
- Potential addition of a monotonic `version` integer for simpler conflict-free incremental sync.

### 6.2 Pagination & Scale
- Current design returns full dataset for initial sync; incremental sync uses `updated_since` filter.
- May introduce `limit` + cursor pagination if dataset size substantially grows.

### 6.3 Export / Import Format (Planned)
Proposed initial progress export structure (subject to a dedicated spec file):
```json
{
  "format": "wort-wirbel-progress",
  "version": 1,
  "exported_at": "2025-09-01T19:05:36Z",
  "spaced_repetition": [
    {
      "word_id": "123",
      "interval_days": 8,
      "ease": 2.5,
      "repetitions": 4,
      "lapses": 1,
      "next_review": "2025-09-05T00:00:00Z",
      "last_reviewed": "2025-08-28T10:11:12Z"
    }
  ],
  "app_meta": { "app_version": "1.0.0" }
}
```

### 6.4 Spaced Repetition Algorithm
- Final algorithm variant (e.g., SM-2, FSRS, or custom) to be documented in a separate RFC; placeholder interfaces assumed.

### 6.5 API Error Model (Future)
Standard error response shape (planned):
```json
{
  "error": { "code": "bad_request", "message": "updated_since is invalid ISO 8601 timestamp" }
}
```

### 6.6 Indexing & Performance
- Index on `updated_at` recommended.
- Potential future indexes for search (e.g., trigram on `german`).

### 6.7 Security & Ops
- Basic rate limiting.
- ETag / If-None-Match for full list caching (optional future enhancement).
- Daily Postgres backups with a 7–30 day retention window.

## 7. Decision Log
- Centralized word list with read-only distribution API: ACCEPTED.
- All user progress local only (IndexedDB), no server persistence: ACCEPTED.
- Single-table backend schema (no user tables): ACCEPTED.
- Incremental sync via `updated_since` timestamp param: ACCEPTED.
- Export/import for full user progress: ACCEPTED (format to be finalized separately).

## 8. Out of Scope
- User authentication.
- Multi-user collaboration features.
- Real-time updates / push sync.
- Additional languages beyond German (potential future extension).

## 9. Status
This RFC is marked Final. Subsequent changes require a new RFC (e.g., RFC-00X) referencing this document.
