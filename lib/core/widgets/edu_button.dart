import 'package:flutter/material.dart';

enum EduButtonVariant { primary, secondary, outline, ghost, destructive }

enum EduButtonSize { small, medium, large }

class EduButton extends StatelessWidget {
  const EduButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = EduButtonVariant.primary,
    this.size = EduButtonSize.medium,
    this.leading,
    this.loading = false,
    this.iconOnly = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final EduButtonVariant variant;
  final EduButtonSize size;
  final Widget? leading;
  final bool loading;
  final bool iconOnly;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minHeight = switch (size) {
      EduButtonSize.small => 40.0,
      EduButtonSize.medium => 48.0,
      EduButtonSize.large => 54.0,
    };

    final button = switch (variant) {
      EduButtonVariant.primary => FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(minHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildContent(theme),
      ),
      EduButtonVariant.secondary => ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(minHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildContent(theme),
      ),
      EduButtonVariant.outline => OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(minHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildContent(theme),
      ),
      EduButtonVariant.ghost => TextButton(
        onPressed: loading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size.fromHeight(minHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildContent(theme),
      ),
      EduButtonVariant.destructive => FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(minHeight),
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _buildContent(theme),
      ),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(ThemeData theme) {
    if (loading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          ),
          if (!iconOnly) const SizedBox(width: 8),
          if (!iconOnly) Text(label),
        ],
      );
    }

    if (iconOnly) {
      return leading ?? const Icon(Icons.chevron_right_rounded);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 8)],
        Text(label),
      ],
    );
  }
}
