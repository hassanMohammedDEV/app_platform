class FieldState<T> {
  final T value;
  final String? error;
  final bool touched;

  const FieldState({
    required this.value,
    this.error,
    this.touched = false,
  });

  FieldState<T> copyWith({
    T? value,
    String? error,
    bool? touched,
  }) {
    return FieldState(
      value: value ?? this.value,
      error: error,
      touched: touched ?? this.touched,
    );
  }

  bool get isValid => error == null;
}
