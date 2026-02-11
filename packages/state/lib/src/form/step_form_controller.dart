import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'form_notifier.dart';

class StepFormState {
  final int currentStep;

  const StepFormState(this.currentStep);
}

class StepFormNotifier<K extends Enum>
    extends StateNotifier<StepFormState> {
  final FormNotifier<K> formNotifier;
  final Map<int, List<K>> stepFields;

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
