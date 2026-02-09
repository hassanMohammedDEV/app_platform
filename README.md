# App Platform

App Platform is a reusable Flutter platform that provides a clean and scalable foundation for handling API calls, state management, CRUD actions, pagination, and UI feedback across multiple projects.

This platform was created to solve a common problem in Flutter development: repeating the same architectural patterns and boilerplate code in every project. Almost every app needs loading states, error handling, HTTP communication, CRUD operations, pagination, and user feedback such as SnackBars or dialogs. App Platform centralizes these concerns into reusable packages so you can focus on building features instead of infrastructure.

The repository is structured as a monorepo containing multiple Flutter packages under the `packages/` directory. Each package has a clear responsibility and can be reused across all future projects.

The main packages included are:

- **app_platform_core**:  
  Contains shared core utilities such as the `Result<T>` pattern, unified error models, and pagination models. Instead of throwing exceptions, async operations return explicit success or failure results, making error handling predictable and easy to reason about.

  Example:
  ```dart
  final result = await repository.getUsers();

  switch (result) {
    case Success(:final data):
      print(data);
    case Failure(:final error):
      print(error.message);
  }
  ```

- **app_platform_network**:  
  Provides a standardized HTTP layer built on top of the `http` package. It centralizes API calls, request handling, response parsing, and error mapping. Responses are parsed using explicit parser functions, keeping networking logic out of widgets and UI code.

  Example:
  ```dart
  final apiClient = HttpApiClient(
    baseUrl: 'https://dummyjson.com',
    client: http.Client(),
    tokenProvider: AppTokenProvider(),
  );

  final result = await apiClient.get<List<User>>(
    '/users',
    parser: (json) =>
        (json['users'] as List).map(User.fromJson).toList(),
  );
  ```

- **app_platform_state**:  
  Handles application state in a clean and scalable way. It separates screen data state from temporary user actions. Screen state is represented using `BaseState`, which supports loading, success, and error states. Temporary operations such as create, update, delete, or check actions are handled using `ActionStore`, allowing per-action loading and error tracking without polluting screen state.

  Example screen state usage:
  ```dart
  switch (state.status) {
    case LoadStatus.loading:
      return const CircularProgressIndicator();
    case LoadStatus.success:
      return UsersList(state.data!);
    case LoadStatus.error:
      return Text(state.error!.message);
  }
  ```

  Example action handling:
  ```dart
  final key = ActionKey(ActionType.delete, id: user.id).value;
  state.start(key);
  state.success(key);
  ```

  UI feedback is handled through action listeners, allowing SnackBars, dialogs, or navigation to react to action completion without tightly coupling UI to business logic.

- **app_platform_ui**:  
  Contains reusable UI helpers and widgets such as loading indicators, empty states, dialogs, and async UI helpers. This package intentionally contains no business logic and focuses purely on presentation.

The platform also includes built-in pagination support through a reusable `Paginated<T>` model. It provides properties such as `items`, `hasNext`, `isLoadingMore`, and `paginationError`, making infinite scrolling and paginated lists easy to implement in a consistent way.

To use the platform in a Flutter project, add the packages as Git dependencies. All platform packages must use the same `ref` (commit hash) to ensure consistency:

```yaml
dependencies:
  app_platform_core:
    git:
      url: https://github.com/hassanMohammedDEV/app_platform.git
      ref: <commit-hash>
      path: packages/core

  app_platform_state:
    git:
      url: https://github.com/hassanMohammedDEV/app_platform.git
      ref: <commit-hash>
      path: packages/state

  app_platform_network:
    git:
      url: https://github.com/hassanMohammedDEV/app_platform.git
      ref: <commit-hash>
      path: packages/network

  app_platform_ui:
    git:
      url: https://github.com/hassanMohammedDEV/app_platform.git
      ref: <commit-hash>
      path: packages/ui
```

After that, run `flutter pub get` and start using the platform in your project.

The core design principles behind App Platform are separation of concerns, explicit async handling, predictable error management, minimal boilerplate, and long-term maintainability. The platform avoids global event systems and hidden side effects, favoring clear data flow and explicit state transitions.

This platform is best suited for medium to large Flutter projects, applications with multiple CRUD features, pagination requirements, and long-term maintenance needs. It may be overkill for very small prototypes or single-screen demo apps.

App Platform is intentionally simple, flexible, and explicit. It provides a strong architectural foundation without locking you into heavy frameworks, allowing it to grow naturally with real-world Flutter applications.
