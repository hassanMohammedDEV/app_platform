# App Platform

A reusable Flutter platform that provides a clean, scalable foundation for API calls, state management, CRUD actions, and pagination across projects.

App Platform is a personal Flutter platform built to eliminate repetitive boilerplate and architectural decisions across applications. Instead of rebuilding the same patterns in every project (API handling, loading states, CRUD logic, pagination, UI feedback), this platform centralizes them into reusable packages that can be shared across all future apps.

The platform is domain-agnostic, clean by design, and focused on real-world Flutter applications.

The repository is structured as a monorepo that contains multiple standalone Flutter packages. Each package lives inside the `packages/` directory and has its own `pubspec.yaml`. The core packages included are:

- app_platform_core: Contains shared core utilities such as the `Result<T>` pattern, unified error models, pagination models, and common helpers. All async operations return explicit results instead of throwing exceptions, making error handling predictable and clear.
- app_platform_state: Handles application state and temporary operations. It provides `BaseState<T>` for UI state (loading, success, error), `ActionStore` for managing CRUD operations, `ActionKey` and `ActionType`, and action-based listeners for handling side effects without coupling UI to navigation or loading states.
- app_platform_network: Standardizes HTTP communication through a unified API client. It provides consistent request handling, parser-based response mapping, and centralized network and server error handling.

A key design concept of the platform is the separation between data state and temporary actions. Data state is represented using `BaseState<T>` and is responsible for driving UI rendering. Temporary operations such as create, update, and delete are managed through `ActionStore`, where each action has its own isolated loading and error state without triggering unnecessary UI rebuilds.

Instead of relying on navigation results, loading state transitions, or global event buses, the platform uses an action-based listening approach. Screens can listen for the completion of specific actions and react accordingly (show a message, refresh data, close a dialog) without introducing domain knowledge or coupling between features.

Pagination is handled through a reusable `Paginated<T>` model that supports `hasNext`, `isLoadingMore `, and `paginationError`, enabling infinite scrolling implementations without duplicating logic across features.

To use the platform in a Flutter project, packages are added as Git dependencies directly from this repository. This allows full control over versions and avoids the overhead of publishing to pub.dev while the platform is still evolving.

The platform follows a set of strict architectural principles: separation of concerns, explicit error handling, no UI logic inside repositories, no business logic inside widgets, minimal boilerplate, and predictable data flow. It is designed for medium to large Flutter applications that require consistency, scalability, and long-term maintainability. It is not intended for very small prototypes or one-screen demo applications.

This platform is actively used and continuously improved. Future extensions may include UI helpers, form utilities, authentication modules, and caching layers. The goal is to remain simple but powerful, avoiding heavy frameworks while providing a solid architectural foundation for professional Flutter projects.
