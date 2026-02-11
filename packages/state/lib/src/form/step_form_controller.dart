import 'package:app_platform_state/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepFormState {
  final int currentStep;

  const StepFormState(this.currentStep);
}

class StepFormNotifier
    extends StateNotifier<StepFormState> {
  final FormNotifier formNotifier;
  final Map<int, List<String>> stepFields;

  StepFormNotifier({
    required this.formNotifier,
    required this.stepFields,
  }) : super(const StepFormState(0));

  void next() {
    final fields =
        stepFields[state.currentStep] ?? [];

    final isValid =
    formNotifier.validateStep(fields);

    if (isValid) {
      state =
          StepFormState(state.currentStep + 1);
    }
  }

  void back() {
    if (state.currentStep > 0) {
      state =
          StepFormState(state.currentStep - 1);
    }
  }
}
