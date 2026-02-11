import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Validator<T> = String? Function(T value);

class FormNotifier<K extends Enum>
    extends StateNotifier<FormStateModel<K>> {
  final Map<K, Validator<dynamic>> _validators;

  FormNotifier(
      FormStateModel<K> initial, {
        Map<K, Validator<dynamic>> validators = const {},
      })  : _validators = validators,
        super(initial);

  void update<T>(K key, T value) {
    final validator = _validators[key] as Validator<T>?;
    final error = validator?.call(value);

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
      final error = validator?.call(field.value);

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
        // لا نلمس الحقول خارج الخطوة الحالية
        updated[key] = field;
        continue;
      }

      final validator = _validators[key];
      final error = validator?.call(field.value);

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
