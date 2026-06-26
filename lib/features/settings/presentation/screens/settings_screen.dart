import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../test_koran/presentation/blocs/history/history_bloc.dart';
import '../../../test_koran/presentation/blocs/history/history_event.dart';
import '../blocs/settings_bloc.dart';
import '../../domain/entities/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  final bool fromTab;

  const SettingsScreen({super.key, this.fromTab = false});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings')),
        automaticallyImplyLeading: !fromTab,
      ),
      body: BlocBuilder<SettingsBloc, AppSettings>(
        builder: (context, settings) {
          return ListView(
            padding: AppTheme.screenPadding,
            children: [
              _buildSectionHeader(loc.translate('appearance')),
              const SizedBox(height: AppTheme.s16),
              _buildThemeSelector(context, loc, settings),
              const SizedBox(height: AppTheme.s32),
              _buildSectionHeader(loc.translate('feedback')),
              const SizedBox(height: AppTheme.s16),
              _buildSwitchTile(
                icon: Icons.volume_up_rounded,
                title: loc.translate('sound_effects'),
                subtitle: loc.translate('sound_desc'),
                value: settings.soundEnabled,
                onChanged: (v) => context.read<SettingsBloc>().add(UpdateSoundEvent(v)),
              ),
              const SizedBox(height: AppTheme.s12),
              _buildSwitchTile(
                icon: Icons.vibration_rounded,
                title: loc.translate('vibration'),
                subtitle: loc.translate('vibration_desc'),
                value: settings.vibrationEnabled,
                onChanged: (v) => context.read<SettingsBloc>().add(UpdateVibrationEvent(v)),
              ),
              const SizedBox(height: AppTheme.s32),
              _buildSectionHeader(loc.translate('display')),
              const SizedBox(height: AppTheme.s16),
              _buildSwitchTile(
                icon: Icons.animation_rounded,
                title: loc.translate('animations'),
                subtitle: loc.translate('animations_desc'),
                value: settings.animationsEnabled,
                onChanged: (v) => context.read<SettingsBloc>().add(UpdateAnimationsEvent(v)),
              ),
              const SizedBox(height: AppTheme.s32),
              _buildSectionHeader(loc.translate('language')),
              const SizedBox(height: AppTheme.s16),
              _buildLanguageSelector(context, loc, settings),
              const SizedBox(height: AppTheme.s32),
              _buildSectionHeader(loc.translate('data')),
              const SizedBox(height: AppTheme.s16),
              _buildActionTile(
                context,
                icon: Icons.delete_forever_rounded,
                title: loc.translate('reset_data'),
                subtitle: loc.translate('reset_data_desc'),
                color: AppColors.error,
                onTap: () => _confirmReset(context, loc),
              ),
              const SizedBox(height: AppTheme.s48),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppLocalizations loc, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s8),
        child: Row(
          children: [
            _buildThemeOption(context, 'light', Icons.light_mode_rounded, loc.translate('light'), settings.themeMode == 'light'),
            _buildThemeOption(context, 'dark', Icons.dark_mode_rounded, loc.translate('dark'), settings.themeMode == 'dark'),
            _buildThemeOption(context, 'system', Icons.settings_brightness_rounded, loc.translate('system'), settings.themeMode == 'system'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String mode, IconData icon, String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<SettingsBloc>().add(UpdateThemeModeEvent(mode)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Column(
            children: [
              Icon(
                icon, 
                color: isSelected ? AppColors.textOnPrimary : AppColors.textMuted, 
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: AppTheme.s4),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(icon, color: AppColors.primary, size: 22),
          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.textOnPrimary,
          activeTrackColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations loc, AppSettings settings) {
    return Card(
      child: Column(
        children: List.generate(AppLocalizations.supportedLanguages.length, (i) {
          final lang = AppLocalizations.supportedLanguages[i];
          final name = AppLocalizations.languageNames[i];
          final isSelected = settings.languageCode == lang;
          return Column(
            children: [
              ListTile(
                title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: () {
                  context.read<SettingsBloc>().add(UpdateLanguageEvent(lang));
                  context.read<LocalizationBloc>().add(SetLanguageEvent(lang));
                },
              ),
              if (i < AppLocalizations.supportedLanguages.length - 1) const Divider(indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: isDark ? AppColors.textWhite : AppColors.textPrimary, size: 22),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 15, 
            fontWeight: FontWeight.w700, 
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        onTap: onTap,
      ),
    );
  }

  void _confirmReset(BuildContext context, AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          loc.translate('reset_confirm_title'),
          style: TextStyle(color: isDark ? AppColors.textWhite : AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(loc.translate('reset_confirm_desc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.textWhite,
              side: isDark ? const BorderSide(color: AppColors.zinc700) : BorderSide.none,
            ),
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistoryEvent());
              context.read<SettingsBloc>().add(ResetSettingsEvent());
              Navigator.pop(ctx);
            },
            child: Text(loc.translate('reset')),
          ),
        ],
      ),
    );
  }
}
