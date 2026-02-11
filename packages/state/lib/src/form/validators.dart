import 'validator_type.dart';
class Validators {
  /// 🔹 Required
  static Validator<String> required({
    String message = 'Required',
  }) {
    return (value) =>
    value.trim().isEmpty ? message : null;
  }

  /// 🔹 Email (خفيف وعملي)
  static Validator<String> email({
    String message = 'Invalid email',
  }) {
    final regex =
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    return (value) =>
    regex.hasMatch(value.trim())
        ? null
        : message;
  }

  /// 🔹 Website URL (نسخة عملية)
  static Validator<String> website({
    String message = 'Invalid website',
  }) {
    final regex = RegExp(
      r'^(https?:\/\/)?([\w-]+\.)+[a-zA-Z]{2,}(\/\S*)?$',
      caseSensitive: false,
    );

    return (value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null; // optional
      return regex.hasMatch(trimmed)
          ? null
          : message;
    };
  }

  /// 🔹 Numeric (double)
  static Validator<String> numeric({
    String message = 'Must be a number',
  }) {
    return (value) =>
    double.tryParse(value.trim()) == null
        ? message
        : null;
  }

  /// 🔹 Integer
  static Validator<String> integer({
    String message = 'Must be an integer',
  }) {
    return (value) =>
    int.tryParse(value.trim()) == null
        ? message
        : null;
  }

  /// 🔹 Min Length
  static Validator<String> minLength(
      int length, {
        String? message,
      }) {
    return (value) =>
    value.length < length
        ? message ??
        'Minimum $length characters'
        : null;
  }

  /// 🔹 Max Length
  static Validator<String> maxLength(
      int length, {
        String? message,
      }) {
    return (value) =>
    value.length > length
        ? message ??
        'Maximum $length characters'
        : null;
  }

  /// 🔹 Range (للأرقام)
  static Validator<String> range({
    required num min,
    required num max,
    String? message,
  }) {
    return (value) {
      final number = num.tryParse(value);
      if (number == null) return null;
      if (number < min || number > max) {
        return message ??
            'Value must be between $min and $max';
      }
      return null;
    };
  }

  /// 🔹 Password Strength (بسيط)
  static Validator<String> strongPassword({
    String message =
    'Must contain letters and numbers',
  }) {
    final regex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');

    return (value) =>
    regex.hasMatch(value)
        ? null
        : message;
  }

  /// 🔹 Generic Pattern
  static Validator<String> pattern(
      RegExp regex, {
        String message = 'Invalid format',
      }) {
    return (value) =>
    regex.hasMatch(value)
        ? null
        : message;
  }

  /// 🔥 Combine (أهم دالة)
  static Validator<T> combine<T>(
      List<Validator<T>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
