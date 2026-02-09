
import 'app_error.dart';

class NetworkError extends AppError {
  const NetworkError(super.message);
}

class ServerError extends AppError {
  final int statusCode;
  const ServerError(this.statusCode, String message) : super(message);
}

class UnknownError extends AppError {
  const UnknownError(super.message);
}
