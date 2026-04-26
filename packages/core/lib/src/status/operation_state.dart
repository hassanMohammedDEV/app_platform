import '../../core.dart';

class OperationState {
  final LoadStatus status;
  final String? statusMessage;

  OperationState({required this.status, this.statusMessage});
}
