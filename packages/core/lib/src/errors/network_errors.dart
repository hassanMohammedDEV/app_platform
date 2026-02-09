import 'app_error.dart';

class NoInternetError extends AppError {
  const NoInternetError() : super('No internet connection');
}

class TimeoutError extends AppError {
  const TimeoutError() : super('Request timeout');
}

class UnauthorizedError extends AppError {
  const UnauthorizedError() : super('Unauthorized');
}

class ForbiddenError extends AppError {
  const ForbiddenError() : super('Access denied');
}

class NotFoundError extends AppError {
  const NotFoundError() : super('Resource not found');
}

class ValidationError extends AppError {
  final Map<String, dynamic>? fields;

  const ValidationError(
      String message, {
        this.fields,
      }) : super(message);
}
