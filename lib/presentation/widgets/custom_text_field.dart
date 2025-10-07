import 'package:flutter/material.dart';

/// A custom text field widget that provides a consistent design across the app
/// Supports both regular text fields and password fields with visibility toggle
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool showPasswordToggle;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showPasswordToggle = false,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      textCapitalization: widget.textCapitalization,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).disabledColor,
            width: 1,
          ),
        ),
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
