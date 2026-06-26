import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/presentation/blocs/settings_bloc.dart';
import '../blocs/test/test_bloc.dart';
import '../blocs/test/test_event.dart';
import '../blocs/test/test_state.dart';
import '../widgets/custom_numpad.dart';
import '../widgets/matrix_column_widget.dart';
import 'result_screen.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  @override
  void initState() {
    super.initState();
    _startTest();
  }

  void _startTest() {
    final settings = context.read<SettingsBloc>().state;
    context.read<TestBloc>().add(StartTestEvent(
      timerSeconds: settings.timerSeconds,
      operationType: settings.operationType,
      patternType: settings.patternType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldPop = await _confirmExitTest(context);
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: BlocConsumer<TestBloc, TestState>(
          listener: (context, state) {
            if (state is TestFinishedState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ResultScreen(result: state.result)),
              );
            }
          },
          builder: (context, state) {
            if (state is TestRunningState) {
              return _buildGameLayout(context, state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          if (state is TestRunningState) {
            final colNum = state.activeColumnIndex + 1;
            final totalCols = state.totalColumns;

            int totalCorrect = 0;
            int totalIncorrect = 0;
            for (final col in state.columnsAnswersCorrectness) {
              for (final correctness in col) {
                if (correctness == true) {
                  totalCorrect++;
                } else if (correctness == false) {
                  totalIncorrect++;
                }
              }
            }

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'COL $colNum/$totalCols',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.s8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '$totalCorrect',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel_rounded, size: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                      const SizedBox(width: 4),
                      Text(
                        '$totalIncorrect',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDuration(state.totalSecondsElapsed),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.read<TestBloc>().add(const ToggleMuteEvent()),
                  icon: Icon(
                    state.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: state.isMuted ? AppColors.textMuted : AppColors.primary,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGameLayout(BuildContext context, TestRunningState state) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    final settings = context.watch<SettingsBloc>().state;
    final activeColIdx = state.activeColumnIndex;
    final numbers = state.columnsNumbers[activeColIdx];
    final activeIdx = state.activeIndex;
    final num1 = activeIdx < numbers.length ? numbers[activeIdx] : 0;
    final num2 = activeIdx + 1 < numbers.length ? numbers[activeIdx + 1] : 0;

    return Column(
      children: [
        _buildTimeProgressBar(state, loc),
        const SizedBox(height: AppTheme.s8),
        Expanded(
          child: _buildMatrixPreview(state, settings.animationsEnabled),
        ),
        _buildCalculationCard(num1, num2, state, loc),
        const SizedBox(height: AppTheme.s16),
        _buildNumpadSection(context),
        const SizedBox(height: AppTheme.s16),
      ],
    );
  }

  Widget _buildCalculationCard(int num1, int num2, TestRunningState state, AppLocalizations loc) {
    final activeColIdx = state.activeColumnIndex;
    final activeIdx = state.activeIndex;
    final hasAnswer = activeIdx < state.columnsUserAnswers[activeColIdx].length &&
        state.columnsUserAnswers[activeColIdx][activeIdx] != null;
    final userAnswer = hasAnswer ? state.columnsUserAnswers[activeColIdx][activeIdx] : null;
    final isCorrect = hasAnswer ? state.columnsAnswersCorrectness[activeColIdx][activeIdx] : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.s16),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: AppTheme.s20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppColors.shadowMd,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Text(
            loc.translate('sum_these_numbers').toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 2.0,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppTheme.s20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberBox(num1),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.s8),
                child: Icon(Icons.add_rounded, color: AppColors.textMuted, size: 20),
              ),
              _buildNumberBox(num2),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.s8),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.textMuted, size: 20),
              ),
              _buildAnswerBox(userAnswer, isCorrect),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBox(int num) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      alignment: Alignment.center,
      child: Text(
        '$num',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAnswerBox(int? answer, bool? isCorrect) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final String displayText;
    final TextDecoration decoration;

    if (answer == null) {
      bgColor = AppColors.primary.withValues(alpha: 0.05);
      borderColor = AppColors.primary.withValues(alpha: 0.3);
      textColor = AppColors.primary;
      displayText = '?';
      decoration = TextDecoration.none;
    } else if (isCorrect == true) {
      bgColor = AppColors.primary.withValues(alpha: 0.08);
      borderColor = AppColors.primary;
      textColor = AppColors.primary;
      displayText = '$answer';
      decoration = TextDecoration.none;
    } else {
      bgColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
      borderColor = Theme.of(context).colorScheme.outline.withValues(alpha: isDark ? 0.4 : 0.6);
      textColor = (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary).withValues(alpha: 0.4);
      displayText = '$answer';
      decoration = TextDecoration.lineThrough;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: textColor,
          decoration: decoration,
          decorationColor: textColor,
        ),
      ),
    );
  }

  Widget _buildMatrixPreview(TestRunningState state, bool animationsEnabled) {
    final activeColIdx = state.activeColumnIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16, vertical: AppTheme.s20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column (flex: 1)
          Expanded(
            flex: 1,
            child: activeColIdx > 0
                ? Opacity(
                    opacity: 0.4,
                    child: MatrixColumnWidget(
                      numbers: state.columnsNumbers[activeColIdx - 1],
                      userAnswers: state.columnsUserAnswers[activeColIdx - 1],
                      answerCorrectness: state.columnsAnswersCorrectness[activeColIdx - 1],
                      activeIndex: 0,
                      isActiveColumn: false,
                      animationsEnabled: animationsEnabled,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: AppTheme.s16),
          // Center Column (flex: 2)
          Expanded(
            flex: 2,
            child: MatrixColumnWidget(
              numbers: state.columnsNumbers[activeColIdx],
              userAnswers: state.columnsUserAnswers[activeColIdx],
              answerCorrectness: state.columnsAnswersCorrectness[activeColIdx],
              activeIndex: state.activeIndex,
              isActiveColumn: true,
              animationsEnabled: animationsEnabled,
            ),
          ),
          const SizedBox(width: AppTheme.s16),
          // Right Column (flex: 1)
          Expanded(
            flex: 1,
            child: activeColIdx < state.totalColumns - 1
                ? Opacity(
                    opacity: 0.4,
                    child: MatrixColumnWidget(
                      numbers: state.columnsNumbers[activeColIdx + 1],
                      userAnswers: state.columnsUserAnswers[activeColIdx + 1],
                      answerCorrectness: state.columnsAnswersCorrectness[activeColIdx + 1],
                      activeIndex: 0,
                      isActiveColumn: false,
                      animationsEnabled: animationsEnabled,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadSection(BuildContext context) {
    final settings = context.watch<SettingsBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16),
      child: CustomNumpad(
        onNumberPressed: (number) {
          context.read<TestBloc>().add(SubmitAnswerEvent(number));
        },
        layout: settings.keyboardLayout,
      ),
    );
  }

  Widget _buildTimeProgressBar(TestRunningState state, AppLocalizations loc) {
    final double percent = state.columnSecondsRemaining / 30.0;
    final isLowTime = state.columnSecondsRemaining <= 5;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final warningColor = isDark ? AppColors.textMuted : AppColors.secondary;
    final activeColor = AppColors.primary;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.translate('next_shift'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '${state.columnSecondsRemaining}s',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isLowTime ? warningColor : activeColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.s16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: isDark ? AppColors.zinc800 : AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLowTime ? warningColor : activeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<bool> _confirmExitTest(BuildContext context) async {
    final loc = context.read<LocalizationBloc>().state.loc;
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: AlertDialog(
            title: Text(loc.translate('quit_test')),
            content: Text(loc.translate('quit_test_desc')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  loc.translate('cancel'),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textWhite.withValues(alpha: 0.7)
                        : AppColors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  minimumSize: const Size(100, 40),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  loc.translate('quit'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
    return result ?? false;
  }
}
