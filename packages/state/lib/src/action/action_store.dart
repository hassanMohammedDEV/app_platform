import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/src/action/action_status.dart';

import 'action_state.dart';

class ActionStore {
  final Map<String, ActionState> _actions;

  ActionStore([Map<String, ActionState>? actions])
      : _actions = actions ?? const {};

  /// 🔍 get state (idle إذا غير موجود)
  ActionState get(String key) {
    return _actions[key] ?? const ActionState.idle();
  }

  bool isLoading(String key) => get(key).isLoading;
  bool isSuccess(String key) => get(key).isSuccess;
  bool isFailure(String key) => get(key).isFailure;

  /// ⏳ start action
  ActionStore start(String key) {
    return ActionStore({
      ..._actions,
      key: const ActionState.loading(),
    });
  }

  /// ✅ success
  ActionStore success(String key) {
    return ActionStore({
      ..._actions,
      key: const ActionState.success(),
    });
  }

  /// ❌ failure
  ActionStore fail(String key, AppError error) {
    return ActionStore({
      ..._actions,
      key: ActionState.failure(error),
    });
  }

  /// 🧹 clear action (back to idle)
  ActionStore clear(String key) {
    final copy = Map<String, ActionState>.from(_actions);
    copy.remove(key);
    return ActionStore(copy);
  }
}


