import 'field_state.dart';

class FormStateModel {
  final Map<String, FieldState<dynamic>> fields;

  const FormStateModel({
    this.fields = const {},
  });

  FieldState<T> field<T>(String name) {
    return fields[name] as FieldState<T>;
  }

  FormStateModel updateField<T>(
      String name,
      FieldState<T> field,
      ) {
    return FormStateModel(
      fields: {
        ...fields,
        name: field,
      },
    );
  }

  bool get isValid =>
      fields.values.every((f) => f.isValid);
}
