import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_result.dart';
import '../blocs/history/history_bloc.dart';
import '../blocs/history/history_event.dart';
import '../blocs/test/test_bloc.dart';
import 'gameplay_screen.dart';

class ResultScreen extends StatefulWidget {
  final TestResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _promptPlayerName());
  }

  Future<void> _promptPlayerName() async {
    final loc = context.read<LocalizationBloc>().state.loc;
    final nameController = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.s16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: AppTheme.s20),
                Text(
                  loc.translate('player_name_title'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.s8),
                Text(
                  loc.translate('player_name_desc'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.s24),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: loc.translate('player_name_hint'),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  onSubmitted: (v) => Navigator.pop(ctx, v.trim().isEmpty ? 'Player' : v.trim()),
                ),
                const SizedBox(height: AppTheme.s24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final text = nameController.text.trim();
                        Navigator.pop(ctx, text.isEmpty ? 'Player' : text);
                      },
                      child: Text(loc.translate('confirm')),
                    ),
                    const SizedBox(height: AppTheme.s12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, 'Player'),
                      child: Text(loc.translate('skip')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (name != null && mounted) {
      final resultWithName = widget.result.copyWith(playerName: name);
      try {
        await context.read<TestBloc>().saveTestResult(resultWithName);
      } catch (e) {
        debugPrint("Error saving test result: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppTheme.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(loc),
              const SizedBox(height: AppTheme.s32),
              _buildOverviewMetrics(loc),
              const SizedBox(height: AppTheme.s24),
              _buildChartCard(loc),
              const SizedBox(height: AppTheme.s40),
              _buildActionButtons(context, loc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('test_results'),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppTheme.s4),
        Text(
          loc.translate('analysis_desc'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (widget.result.playerName.isNotEmpty && widget.result.playerName != 'Anonymous') ...[
          const SizedBox(height: AppTheme.s16),
          _buildPlayerNameChip(),
        ],
      ],
    );
  }

  Widget _buildPlayerNameChip() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.secondary,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_rounded, size: 14, color: isDark ? AppColors.primary : AppColors.primary),
          const SizedBox(width: 6),
          Text(
            widget.result.playerName,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isDark ? AppColors.primary : AppColors.textWhite, 
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetrics(AppLocalizations loc) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppTheme.s16,
      crossAxisSpacing: AppTheme.s16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          loc.translate('pace'),
          '${widget.result.totalAnswered}',
          Icons.bolt_rounded,
        ),
        _buildMetricCard(
          loc.translate('accuracy'),
          '${widget.result.accuracy.toStringAsFixed(1)}%',
          Icons.ads_click_rounded,
        ),
        _buildMetricCard(
          loc.translate('consistency'),
          '${widget.result.consistency.toStringAsFixed(1)}%',
          Icons.insights_rounded,
        ),
        _buildMetricCard(
          'Score',
          '${(widget.result.totalCorrect * 10).toInt()}',
          Icons.emoji_events_rounded,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const Spacer(),
            Text(
              value, 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              title, 
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(AppLocalizations loc) {
    final intervals = widget.result.intervals;
    if (intervals.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.translate('consistency_over_time'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppTheme.s24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (v) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: Theme.of(context).textTheme.labelSmall),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          final idx = v.toInt();
                          if (idx >= 0 && idx < intervals.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('C${idx + 1}', style: Theme.of(context).textTheme.labelSmall),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(intervals.length, (i) => FlSpot(i.toDouble(), intervals[i].totalAnswered.toDouble())),
                      isCurved: true,
                      gradient: AppColors.primaryGradient,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameplayScreen()));
          },
          child: Text(loc.translate('test_again')),
        ),
        const SizedBox(height: AppTheme.s12),
        OutlinedButton(
          onPressed: () {
            context.read<HistoryBloc>().add(LoadHistoryEvent());
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Text(loc.translate('home')),
        ),
      ],
    );
  }
}
