import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../blocs/history/history_bloc.dart';
import '../blocs/history/history_event.dart';
import 'dashboard_screen.dart';
import 'history_list_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = <Widget>[
    const DashboardScreen(),
    const HistoryListScreen(),
    const SettingsScreen(fromTab: true),
  ];

  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(loc, isDark),
    );
  }

  Widget _buildBottomNav(AppLocalizations loc, bool isDark) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 64 + bottomPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.zinc900.withValues(alpha: 0.97) : AppColors.surface.withValues(alpha: 0.97),
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.zinc700.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_rounded, loc.translate('home'), isDark),
                _buildNavItem(1, Icons.history_rounded, Icons.history_rounded, loc.translate('history_logs'), isDark),
                _buildNavItem(2, Icons.settings_rounded, Icons.settings_rounded, loc.translate('settings'), isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, bool isDark) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (index == 1) context.read<HistoryBloc>().add(LoadHistoryEvent());
          setState(() => _currentIndex = index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive 
                    ? AppColors.primary 
                    : (isDark ? AppColors.textMuted : AppColors.textSecondary.withValues(alpha: 0.7)),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isActive ? 5 : 0,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
