import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/blocs/settings_bloc.dart';

class TestSetupDialog extends StatefulWidget {
  const TestSetupDialog({super.key});

  @override
  State<TestSetupDialog> createState() => _TestSetupDialogState();
}

class _TestSetupDialogState extends State<TestSetupDialog> {
  late AppSettings _settings;
  final _customMinController = TextEditingController();
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    _settings = context.read<SettingsBloc>().state;
    _isCustom = !AppSettings.timerPresets.contains(_settings.timerSeconds);
    if (_isCustom) {
      _customMinController.text = (_settings.timerSeconds ~/ 60).toString();
    }
  }

  @override
  void dispose() {
    _customMinController.dispose();
    super.dispose();
  }

  void _applyAndStart() {
    final bloc = context.read<SettingsBloc>();
    bloc.add(UpdateTimerEvent(_settings.timerSeconds));
    bloc.add(UpdateOperationTypeEvent(_settings.operationType));
    bloc.add(UpdatePatternTypeEvent(_settings.patternType));
    bloc.add(UpdateDisplayFormatEvent(_settings.displayFormat));
    bloc.add(UpdateKeyboardLayoutEvent(_settings.keyboardLayout));
    Navigator.pop(context, _settings);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(AppTheme.s24, 0, AppTheme.s24, AppTheme.s24),
              children: [
                _buildHeader(loc),
                const SizedBox(height: AppTheme.s32),
                _buildTimerSection(loc),
                const SizedBox(height: AppTheme.s24),
                _buildOperationSection(loc),
                const SizedBox(height: AppTheme.s24),
                _buildKeyboardSection(loc),
                const SizedBox(height: AppTheme.s32),
                _buildSummaryCard(loc),
                const SizedBox(height: AppTheme.s32),
                _buildActionButtons(loc),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textMuted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Row(
      children: [
        Text(
          'Test Configuration',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        IconButton.filledTonal(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, size: 20),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.s12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildTimerSection(AppLocalizations loc) {
    final presets = AppSettings.timerPresets;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(loc.translate('timer_duration')),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...presets.map((s) {
              final isSelected = _settings.timerSeconds == s && !_isCustom;
              return _ChoiceChip(
                label: '${s ~/ 60}m',
                isSelected: isSelected,
                onTap: () => setState(() {
                  _settings = _settings.copyWith(timerSeconds: s);
                  _isCustom = false;
                }),
              );
            }),
            _ChoiceChip(
              label: 'Custom',
              isSelected: _isCustom,
              onTap: () => setState(() => _isCustom = true),
            ),
          ],
        ),
        if (_isCustom) ...[
          const SizedBox(height: AppTheme.s16),
          TextField(
            controller: _customMinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Duration (minutes)',
              suffixText: 'min',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) {
              final mins = int.tryParse(v);
              if (mins != null && mins > 0) {
                setState(() => _settings = _settings.copyWith(timerSeconds: mins * 60));
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildOperationSection(AppLocalizations loc) {
    final ops = ['addition', 'subtraction', 'mixed'];
    final Map<String, IconData> opIcons = {
      'addition': Icons.add_rounded,
      'subtraction': Icons.remove_rounded,
      'mixed': Icons.shuffle_rounded,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(loc.translate('operation_type')),
        Row(
          children: ops.map((op) {
            final isSelected = _settings.operationType == op;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: op == ops.last ? 0 : 8),
                child: _ChoiceChip(
                  icon: opIcons[op],
                  isSelected: isSelected,
                  onTap: () => setState(() => _settings = _settings.copyWith(operationType: op)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeyboardSection(AppLocalizations loc) {
    final layouts = ['ascending', 'calculator'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(loc.translate('keyboard_layout')),
        Row(
          children: layouts.map((layout) {
            final isSelected = _settings.keyboardLayout == layout;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: layout == layouts.last ? 0 : 8),
                child: _ChoiceChip(
                  label: loc.translate(layout),
                  isSelected: isSelected,
                  onTap: () => setState(() => _settings = _settings.copyWith(keyboardLayout: layout)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDark 
          ? AppColors.zinc900 
          : AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        side: BorderSide(
          color: isDark 
              ? AppColors.zinc700.withValues(alpha: 0.5) 
              : AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s16),
        child: Column(
          children: [
            _summaryRow(Icons.timer_outlined, loc.translate('duration'), '${_settings.timerSeconds ~/ 60}m'),
            const Divider(height: 24, color: Colors.transparent),
            _summaryRow(Icons.calculate_outlined, loc.translate('operation'), loc.translate(_settings.operationType)),
            const Divider(height: 24, color: Colors.transparent),
            _summaryRow(Icons.keyboard_alt_outlined, loc.translate('keyboard'), loc.translate(_settings.keyboardLayout)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations loc) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _applyAndStart,
          child: Text(loc.translate('start_test')),
        ),
        const SizedBox(height: AppTheme.s12),
        TextButton(
          onPressed: () {
            setState(() => _settings = const AppSettings());
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textMuted,
          ),
          child: Text(loc.translate('reset')),
        ),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceChip({
    this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    final Color borderColor;

    if (isSelected) {
      bgColor = AppColors.primary;
      textColor = AppColors.textOnPrimary;
      borderColor = AppColors.primary;
    } else {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest;
      textColor = Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary;
      borderColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: icon != null
              ? Icon(
                  icon,
                  color: textColor,
                  size: 20,
                )
              : Text(
                  label ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
        ),
      ),
    );
  }
}
