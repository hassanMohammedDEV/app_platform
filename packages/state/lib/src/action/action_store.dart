import 'action_state.dart';

class ActionStore {
  final Map<String, ActionState> _actions;

  ActionStore([Map<String, ActionState>? actions])
      : _actions = actions ?? {};

  ActionState get(String key) {
    return _actions[key] ?? const ActionState();
  }

  bool isLoading(String key) {
    return get(key).isLoading;
  }

  /// 🔹 ترجع نسخة جديدة
  ActionStore start(String key) {
    return ActionStore({
      ..._actions,
      key: const ActionState(isLoading: true),
    });
  }

  ActionStore success(String key) {
    return ActionStore({
      ..._actions,
      key: const ActionState(),
    });
  }

  ActionStore fail(String key, error) {
    return ActionStore({
      ..._actions,
      key: ActionState(error: error),
    });
  }

  ActionStore clear(String key) {
    final copy = Map<String, ActionState>.from(_actions);
    copy.remove(key);
    return ActionStore(copy);
  }
}
