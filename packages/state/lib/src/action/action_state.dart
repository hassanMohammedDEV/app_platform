import 'package:app_platform_core/core.dart';

import 'action_status.dart';

class ActionState {
  final ActionStatus status;
  final AppError? error;

  const ActionState({
    this.status = ActionStatus.idle,
    this.error,
  });

  bool get isLoading => status == ActionStatus.loading;
  bool get isSuccess => status == ActionStatus.success;
  bool get isFailure => status == ActionStatus.failure;

  ActionState loading() {
    return const ActionState(status: ActionStatus.loading);
  }

  ActionState success() {
    return const ActionState(status: ActionStatus.success);
  }

  ActionState failure(AppError error) {
    return ActionState(
      status: ActionStatus.failure,
      error: error,
    );
  }

  ActionState clear() {
    return const ActionState();
  }
}

