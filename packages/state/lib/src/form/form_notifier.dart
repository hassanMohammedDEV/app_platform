import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'form_state_model.dart';
import 'field_state.dart';

class FormNotifier<K extends Enum>
    extends StateNotifier<FormStateModel<K>> {
  final Map<K, String? Function(Object?)> _validators;

  FormNotifier(
      FormStateModel<K> initial, {
        Map<K, String? Function(Object?)> validators = const {},
      })  : _validators = validators,
        super(initial);

  void update<T>(K key, T value) {
    final validator = _validators[key];

    final error =
    validator != null ? validator(value) : null;

    state = state.updateField(
      key,
      FieldState<T>(
        value: value,
        error: error,
        touched: true,
      ),
    );
  }

  void validateAll() {
    final updated = <K, FieldState<dynamic>>{};

    for (final entry in state.fields.entries) {
      final key = entry.key;
      final field = entry.value;

      final validator = _validators[key];
      final error =
      validator != null ? validator(field.value) : null;

      updated[key] = field.copyWith(
        error: error,
        touched: true,
      );
    }

    state = FormStateModel<K>(fields: updated);
  }

  bool validateStep(List<K> keys) {
    final updated = <K, FieldState<dynamic>>{};
    bool isValid = true;

    for (final entry in state.fields.entries) {
      final key = entry.key;
      final field = entry.value;

      if (!keys.contains(key)) {
        updated[key] = field;
        continue;
      }

      final validator = _validators[key];
      final error =
      validator != null ? validator(field.value) : null;

      if (error != null) {
        isValid = false;
      }

      updated[key] = field.copyWith(
        error: error,
        touched: true,
      );
    }

    state = FormStateModel<K>(fields: updated);

    return isValid;
  }
}
