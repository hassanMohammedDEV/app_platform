import 'package:app_platform_state/state.dart';

import 'action_store.dart';

mixin ActionMixin<T> on BaseNotifier<T> {
  final ActionStore actions = ActionStore();

  void notifyActions() {
    notify();
  }
}
