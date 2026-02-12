class FieldState<T> {
  final T value;
  final String? error;
  final bool touched;
  final bool isValidating;

  const FieldState({
    required this.value,
    this.error,
    this.touched = false,
    this.isValidating = false,
  });

  bool get isValid =>
      error == null && !isValidating;

  FieldState<T> copyWith({
    T? value,
    String? error,
    bool? touched,
    bool? isValidating,
  }) {
    return FieldState<T>(
      value: value ?? this.value,
      error: error,
      touched: touched ?? this.touched,
      isValidating:
      isValidating ?? this.isValidating,
    );
  }
}
