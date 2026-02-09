import 'package:app_platform_core/core.dart';

class ActionState {
  final bool isLoading;
  final AppError? error;

  const ActionState({
    this.isLoading = false,
    this.error,
  });

  ActionState loading() {
    return const ActionState(isLoading: true);
  }

  ActionState success() {
    return const ActionState();
  }

  ActionState failure(AppError error) {
    return ActionState(error: error);
  }
}
