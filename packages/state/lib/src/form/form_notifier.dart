import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field_state.dart';
import 'form_state_model.dart';

typedef Validator<T> = String? Function(T value);

class FormNotifier extends StateNotifier<FormStateModel> {
  final Map<String, Validator<dynamic>> _validators;

  FormNotifier(
      FormStateModel initial, {
        Map<String, Validator<dynamic>> validators = const {},
      })  : _validators = validators,
        super(initial);

  void update<T>({
    required String name,
    required T value,
  }) {
    final validator = _validators[name] as Validator<T>?;
    final error = validator?.call(value);

    state = state.updateField(
      name,
      FieldState<T>(
        value: value,
        error: error,
        touched: true,
      ),
    );
  }

  /// ✅ validate all fields
  void validateAll() {
    final updatedFields = <String, FieldState<dynamic>>{};

    for (final entry in state.fields.entries) {
      final name = entry.key;
      final field = entry.value;

      final validator = _validators[name];
      final error = validator?.call(field.value);

      updatedFields[name] = field.copyWith(
        error: error,
        touched: true,
      );
    }

    state = FormStateModel(fields: updatedFields);
  }
}
