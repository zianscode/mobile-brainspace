import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_result.dart';

class HistoryDetailScreen extends StatefulWidget {
  final TestResult result;

  const HistoryDetailScreen({super.key, required this.result});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    final dateStr = DateFormat('EEE, dd MMM yyyy').format(widget.result.dateTime);
    final timeStr = DateFormat('HH:mm').format(widget.result.dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('detail_results')),
        actions: [
          IconButton(
            onPressed: _captureAndShare,
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintKey,
        child: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderInfo(dateStr, timeStr),
              const SizedBox(height: AppTheme.s32),
              _buildScoreGrid(loc),
              const SizedBox(height: AppTheme.s32),
              _buildChartCard(loc),
              const SizedBox(height: AppTheme.s32),
              _buildInsightsSection(loc),
              const SizedBox(height: AppTheme.s48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String date, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: Theme.of(context).textTheme.headlineMedium),
        Text('Started at $time', style: Theme.of(context).textTheme.bodyMedium),
        if (widget.result.playerName.isNotEmpty && widget.result.playerName != 'Anonymous') ...[
          const SizedBox(height: AppTheme.s16),
          _buildPlayerChip(),
        ],
      ],
    );
  }

  Widget _buildPlayerChip() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.secondary,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_rounded, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            widget.result.playerName,
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: isDark ? AppColors.primary : AppColors.textWhite, 
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreGrid(AppLocalizations loc) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppTheme.s16,
      crossAxisSpacing: AppTheme.s16,
      childAspectRatio: 1.6,
      children: [
        _scoreCard(loc.translate('solved'), '${widget.result.totalAnswered}'),
        _scoreCard(loc.translate('correct'), '${widget.result.totalCorrect}'),
        _scoreCard(loc.translate('accuracy'), '${widget.result.accuracy.toStringAsFixed(1)}%'),
        _scoreCard(loc.translate('consistency'), '${widget.result.consistency.toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget _scoreCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label.toUpperCase(), 
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            Text(
              value, 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
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
            Text(loc.translate('perf_per_column'), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppTheme.s24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Theme.of(context).dividerColor, strokeWidth: 1)),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: Theme.of(context).textTheme.labelSmall))),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          final idx = v.toInt();
                          if (idx >= 0 && idx < intervals.length) return Padding(padding: const EdgeInsets.only(top: 8), child: Text('C${idx + 1}', style: Theme.of(context).textTheme.labelSmall));
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(intervals.length, (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(toY: intervals[i].totalAnswered.toDouble(), gradient: AppColors.primaryGradient, width: 12, borderRadius: BorderRadius.circular(4)),
                    ],
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsSection(AppLocalizations loc) {
    final intervals = widget.result.intervals;
    if (intervals.isEmpty) return const SizedBox.shrink();
    
    final answered = intervals.map((i) => i.totalAnswered).toList();
    final avg = answered.reduce((a, b) => a + b) / answered.length;
    final max = answered.reduce((a, b) => a > b ? a : b);
    final min = answered.reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.translate('insights').toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
        const SizedBox(height: AppTheme.s16),
        _insightRow(Icons.trending_up_rounded, loc.translate('average_pace'), '${avg.toStringAsFixed(1)} ans'),
        _insightRow(Icons.speed_rounded, loc.translate('peak_performance'), '$max ans'),
        _insightRow(Icons.slow_motion_video_rounded, loc.translate('slowest_column'), '$min ans'),
      ],
    );
  }

  Widget _insightRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.s12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppTheme.s16),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }

  Future<void> _captureAndShare() async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/brainpace_result.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)], subject: 'BrainPace Result');
    } catch (_) {}
  }
}
