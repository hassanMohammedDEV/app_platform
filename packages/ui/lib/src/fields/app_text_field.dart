import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTextField<K extends Enum>
    extends ConsumerWidget {
  const AppTextField({
    super.key,
    required this.field,
    required this.formProvider,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.useAsync = false,
  });

  final K field;
  final StateNotifierProvider<dynamic, dynamic>
  formProvider;

  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool useAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldState = ref.watch(
      formProvider.select(
            (form) => form.field<String>(field),
      ),
    );

    final formNotifier =
    ref.read(formProvider.notifier);

    void onChanged(String value) {
      if (useAsync) {
        formNotifier.updateAsync(field, value);
      } else {
        formNotifier.update(field, value);
      }
    }

    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText:
        fieldState.touched ? fieldState.error : null,
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: _buildSuffix(fieldState),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget? _buildSuffix(fieldState) {
    if (fieldState.isValidating) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (suffixIcon != null) {
      return Icon(suffixIcon);
    }

    return null;
  }
}
