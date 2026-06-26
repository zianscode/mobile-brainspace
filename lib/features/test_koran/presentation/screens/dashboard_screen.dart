import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_result.dart';
import '../blocs/history/history_bloc.dart';
import '../blocs/history/history_event.dart';
import '../blocs/history/history_state.dart';
import '../widgets/test_setup_dialog.dart';
import 'instruction_screen.dart';
import 'history_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoadedState) {
              final history = state.history;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(LoadHistoryEvent());
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: AppTheme.screenPadding,
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildHeader(loc),
                          const SizedBox(height: AppTheme.s32),
                          _buildStartCard(loc),
                          const SizedBox(height: AppTheme.s32),
                          if (history.isNotEmpty) ...[
                            _buildSectionHeader(loc.translate('overview')),
                            const SizedBox(height: AppTheme.s16),
                            _buildOverallStats(history, loc),
                            const SizedBox(height: AppTheme.s32),
                            _buildSectionHeader(loc.translate('latest_result')),
                            const SizedBox(height: AppTheme.s16),
                            _buildLatestResult(history.first, loc),
                            const SizedBox(height: AppTheme.s32),
                            _buildRecentHeader(loc),
                            const SizedBox(height: AppTheme.s16),
                            ...history.take(5).map((r) => _buildHistoryItem(r, loc)),
                          ] else
                            _buildEmptyState(loc),
                          const SizedBox(height: AppTheme.s24),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HistoryErrorState) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.translate('app_name').toUpperCase(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              loc.translate('app_subtitle'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildStartCard(AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cardBgColor = Theme.of(context).colorScheme.surface;
    final cardBorderColor = isDark 
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) 
        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.8);
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final playIconBg = AppColors.primary;
    final playIconColor = AppColors.textOnPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(color: cardBorderColor, width: 1.5),
        boxShadow: AppColors.dynamicShadowLg(isDark),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final nav = Navigator.of(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const TestSetupDialog(),
            ).then((result) {
              if (result != null) {
                nav.push(MaterialPageRoute(builder: (context) => const InstructionScreen()));
              }
            });
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.s24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate('start_test'),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppTheme.s4),
                      Text(
                        'Kraepelin / Pauli Test Simulation',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppTheme.s12),
                  decoration: BoxDecoration(
                    color: playIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow_rounded, color: playIconColor, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.5,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildOverallStats(List<TestResult> history, AppLocalizations loc) {
    final totalTests = history.length;
    final totalAnsweredAll = history.map((r) => r.totalAnswered).reduce((a, b) => a + b);
    final totalCorrectAll = history.map((r) => r.totalCorrect).reduce((a, b) => a + b);
    final overallAccuracy = totalAnsweredAll > 0 ? (totalCorrectAll / totalAnsweredAll) * 100 : 0.0;
    final avgConsistency = history.map((r) => r.consistency).reduce((a, b) => a + b) / totalTests;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('$totalTests', loc.translate('tests'), Icons.bar_chart_rounded),
            _buildStatItem('$totalAnsweredAll', loc.translate('solved'), Icons.bolt_rounded),
            _buildStatItem('${overallAccuracy.toStringAsFixed(0)}%', loc.translate('accuracy'), Icons.ads_click_rounded),
            _buildStatItem('${avgConsistency.toStringAsFixed(0)}%', loc.translate('consistency'), Icons.insights_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: AppTheme.s8),
        Text(
          value, 
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ),
        Text(
          label, 
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLatestResult(TestResult result, AppLocalizations loc) {
    final scoreDate = DateFormat('MMM dd, HH:mm').format(result.dateTime);
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryDetailScreen(result: result))),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.s20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.s8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: AppTheme.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scoreDate, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text(loc.translate('last_performance'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: AppTheme.s20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricBox('${result.totalAnswered}', loc.translate('pace')),
                  _buildMetricBox('${result.accuracy.toStringAsFixed(1)}%', loc.translate('accuracy')),
                  _buildMetricBox('${result.consistency.toStringAsFixed(1)}%', loc.translate('consistency')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox(String value, String label) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentHeader(AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(loc.translate('recent')),
        Text(
          loc.translate('view_all'),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(TestResult item, AppLocalizations loc) {
    final dateStr = DateFormat('dd MMM').format(item.dateTime);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.s12),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryDetailScreen(result: item))),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(AppTheme.s16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.6),
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: isDark ? 0.0 : 1.0), width: 1),
                ),
                child: Center(
                  child: Text(
                    dateStr.split(' ')[0],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, HH:mm').format(item.dateTime),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _miniLabel('${item.totalAnswered} pts'),
                        const SizedBox(width: AppTheme.s8),
                        _miniLabel('${item.accuracy.toStringAsFixed(0)}% acc'),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniLabel(String text) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Column(
      children: [
        const SizedBox(height: AppTheme.s40),
        Icon(Icons.auto_graph_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.2)),
        const SizedBox(height: AppTheme.s16),
        Text(
          loc.translate('no_history_yet'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppTheme.s8),
        Text(
          loc.translate('complete_test_to_see_stats'),
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
