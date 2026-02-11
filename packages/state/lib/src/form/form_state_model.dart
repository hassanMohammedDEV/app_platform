import 'package:app_platform_state/state.dart';

class FormStateModel<K extends Enum> {
  final Map<K, FieldState<dynamic>> fields;

  const FormStateModel({
    this.fields = const {},
  });

  FieldState<T> field<T>(K key) {
    return fields[key] as FieldState<T>;
  }

  FormStateModel<K> updateField<T>(
      K key,
      FieldState<T> field,
      ) {
    return FormStateModel<K>(
      fields: {
        ...fields,
        key: field,
      },
    );
  }

  bool get isValid =>
      fields.values.every((f) => f.isValid);
}
