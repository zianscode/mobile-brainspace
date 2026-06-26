import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class CustomNumpad extends StatelessWidget {
  final Function(int) onNumberPressed;
  final VoidCallback? onBackPressed;
  final bool showBackspace;
  final String layout;

  const CustomNumpad({
    super.key,
    required this.onNumberPressed,
    this.onBackPressed,
    this.showBackspace = false,
    this.layout = 'ascending',
  });

  @override
  Widget build(BuildContext context) {
    final rows = layout == 'calculator'
        ? [
            _buildRow([7, 8, 9]),
            const SizedBox(height: AppTheme.s8),
            _buildRow([4, 5, 6]),
            const SizedBox(height: AppTheme.s8),
            _buildRow([1, 2, 3]),
            const SizedBox(height: AppTheme.s8),
            _buildBottomRow(),
          ]
        : [
            _buildRow([1, 2, 3]),
            const SizedBox(height: AppTheme.s8),
            _buildRow([4, 5, 6]),
            const SizedBox(height: AppTheme.s8),
            _buildRow([7, 8, 9]),
            const SizedBox(height: AppTheme.s8),
            _buildBottomRow(),
          ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(AppTheme.s12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900 : AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: isDark 
              ? AppColors.zinc700.withValues(alpha: 0.3) 
              : AppColors.border.withValues(alpha: 0.6),
        ),
        boxShadow: AppColors.dynamicShadowMd(isDark),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }

  Widget _buildRow(List<int> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.s4),
            child: _NumpadButton(
              label: number.toString(),
              onPressed: () => onNumberPressed(number),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        const Expanded(child: SizedBox.shrink()),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.s4),
            child: _NumpadButton(
              label: '0',
              onPressed: () => onNumberPressed(0),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.s4),
            child: showBackspace && onBackPressed != null
                ? _NumpadButton(
                    icon: Icons.backspace_outlined,
                    onPressed: onBackPressed!,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    iconColor: AppColors.primary,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? iconColor;

  const _NumpadButton({
    this.label,
    this.icon,
    required this.onPressed,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    final defaultText = Theme.of(context).colorScheme.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color ?? defaultBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, color: iconColor ?? defaultText, size: 22)
                : Text(
                    label!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: defaultText,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
