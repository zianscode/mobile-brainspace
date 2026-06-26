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
import 'history_detail_screen.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) _selectedIds.clear();
    });
  }

  void _toggleItemSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<TestResult> items) {
    setState(() {
      _selectedIds.addAll(items.map((e) => e.id).where((id) => id != null).cast<int>());
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('history_logs')),
        actions: [
          if (!_isSelectionMode) ...[
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.checklist_rounded),
            ),
            IconButton(
              onPressed: () => _confirmClearHistory(context),
              icon: const Icon(Icons.delete_sweep_rounded),
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_isSelectionMode) _buildSelectionToolbar(loc),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoadedState) {
                  final history = state.history;
                  if (history.isEmpty) return _buildEmptyState(loc);
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HistoryBloc>().add(LoadHistoryEvent());
                    },
                    child: ListView.builder(
                      padding: AppTheme.screenPadding,
                      physics: const BouncingScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return _buildHistoryItem(history[index], loc);
                      },
                    ),
                  );
                } else if (state is HistoryErrorState) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionToolbar(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: AppTheme.s8),
      color: AppColors.secondary, // Charcoal Black in both modes
      child: Row(
        children: [
          Text(
            '${_selectedIds.length} selected',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              final state = context.read<HistoryBloc>().state;
              if (state is HistoryLoadedState) _selectAll(state.history);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.textWhite),
            child: const Text('Select All'),
          ),
          IconButton(
            onPressed: _selectedIds.isEmpty ? null : _confirmDeleteSelected,
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.primary), // Highlighted in Lime Green
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(TestResult item, AppLocalizations loc) {
    final id = item.id;
    final isSelected = id != null && _selectedIds.contains(id);
    final dateStr = DateFormat('EEE, dd MMM').format(item.dateTime);
    final timeStr = DateFormat('HH:mm').format(item.dateTime);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.s12),
      child: InkWell(
        onTap: _isSelectionMode ? (id != null ? () => _toggleItemSelection(id) : null)
                               : () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryDetailScreen(result: item))),
        onLongPress: () {
          if (!_isSelectionMode && id != null) {
            setState(() {
              _isSelectionMode = true;
              _selectedIds.add(id);
            });
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(AppTheme.s16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withValues(alpha: 0.08) 
                : (isDark ? AppColors.zinc900 : AppColors.surface),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : (isDark ? AppColors.zinc700.withValues(alpha: 0.3) : AppColors.border.withValues(alpha: 0.6)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              if (_isSelectionMode) ...[
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(width: AppTheme.s16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr, 
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeStr, 
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _miniStat('${item.totalAnswered}', 'Pace'),
              const SizedBox(width: AppTheme.s16),
              _miniStat('${item.accuracy.toStringAsFixed(0)}%', 'Acc'),
              const SizedBox(width: AppTheme.s16),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      children: [
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.w800, 
            color: Theme.of(context).colorScheme.onSurface, 
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label, 
          style: const TextStyle(
            fontSize: 9, 
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.2)),
          const SizedBox(height: AppTheme.s16),
          Text(loc.translate('no_history'), style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  void _confirmDeleteSelected() {
    final loc = context.read<LocalizationBloc>().state.loc;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.translate('delete_selected_title')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<HistoryBloc>().add(DeleteSelectedHistoryEvent(_selectedIds.toList()));
              setState(() { _isSelectionMode = false; _selectedIds.clear(); });
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    final loc = context.read<LocalizationBloc>().state.loc;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.translate('clear_history')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistoryEvent());
              Navigator.pop(ctx);
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
