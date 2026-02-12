import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'field_state.dart';
import 'form_state_model.dart';
import 'validator_type.dart';

class FormNotifier<K extends Enum>
    extends StateNotifier<FormStateModel<K>> {
  // Sync validators
  final Map<K, Validator> _validators;

  // Async validators (server side validation)
  final Map<K, AsyncValidator> _asyncValidators;

  // Debounce timer
  Timer? _debounce;

  FormNotifier(
      FormStateModel<K> initial, {
        Map<K, Validator> validators = const {},
        Map<K, AsyncValidator> asyncValidators = const {},
      })  : _validators = validators,
        _asyncValidators = asyncValidators,
        super(initial);

  // Update field with sync validation only
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

  // Update field with sync + async validation (debounced)
  void updateAsync<T>(K key, T value) {
    // Run sync validation first
    update(key, value);

    final asyncValidator = _asyncValidators[key];
    if (asyncValidator == null) return;

    // Cancel previous debounce
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
          () async {
        final field = state.field<T>(key);

        // Mark field as validating
        state = state.updateField(
          key,
          field.copyWith(isValidating: true),
        );

        // Run async validation
        final error = await asyncValidator(value);

        final latestField =
        state.field<T>(key);

        // Update field with async result
        state = state.updateField(
          key,
          latestField.copyWith(
            error: error,
            isValidating: false,
          ),
        );
      },
    );
  }

  // Validate all fields (used on submit)
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

  // Validate only specific fields (used by stepper)
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

  // Reset form state
  void reset() {
    final resetFields = <K, FieldState<dynamic>>{};

    for (final entry in state.fields.entries) {
      resetFields[entry.key] =
          FieldState<dynamic>(
            value: entry.value.value,
          );
    }

    state = FormStateModel<K>(fields: resetFields);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
