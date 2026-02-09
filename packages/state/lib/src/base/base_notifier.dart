
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_state.dart';
import 'package:app_platform_core/core.dart';

abstract class BaseNotifier<T>
    extends StateNotifier<BaseState<T>> {
  BaseNotifier() : super(const BaseState());

  void setLoading() =>
      state = BaseState(status: LoadStatus.loading);

  void setSuccess(T data) =>
      state = BaseState(status: LoadStatus.success, data: data);

  void setError(AppError error) =>
      state = BaseState(status: LoadStatus.error, error: error);

  void notify() {
    state = state;
  }
}
