class ValidationFieldState {
  final String? error;
  final bool touched;
  final bool validating;

  const ValidationFieldState({
    this.error,
    this.touched = false,
    this.validating = false,
  });

  bool get isValid => error == null;

  ValidationFieldState copyWith({
    String? error,
    bool? touched,
    bool? validating,
    bool clearError = false,
  }) {
    return ValidationFieldState(
      error: clearError ? null : error ?? this.error,
      touched: touched ?? this.touched,
      validating: validating ?? this.validating,
    );
  }
}
