
import 'package:app_platform_core/core.dart';

class BaseState<T> {
  final LoadStatus status;
  final T? data;
  final AppError? error;

  const BaseState({
    this.status = LoadStatus.idle,
    this.data,
    this.error,
  });
}
