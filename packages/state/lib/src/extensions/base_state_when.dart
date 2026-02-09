import 'package:app_platform_core/core.dart';
import 'package:app_platform_state/state.dart';
import 'package:flutter/material.dart';

extension BaseStateWhen<T> on BaseState<T> {
  Widget when({
    required Widget Function() loading,
    required Widget Function(AppError error) error,
    required Widget Function(T data) success,
  }) {
    return switch (status) {
      LoadStatus.loading => loading(),
      LoadStatus.error => error(this.error!),
      LoadStatus.success => success(data as T),
      _ => const SizedBox.shrink(),
    };
  }
}
