import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/localization_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/audio/audio_service.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/blocs/settings_bloc.dart';
import '../widgets/custom_numpad.dart';
import '../widgets/matrix_column_widget.dart';
import 'gameplay_screen.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final AudioService _audioService = AudioService();

  final List<int> _tryoutNumbers = [4, 7, 2, 9, 3];
  late List<int?> _tryoutAnswers;
  late List<bool?> _tryoutCorrectness;
  int _tryoutActiveIndex = 0;
  bool _tryoutCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetTryout();
    _audioService.init();
  }

  void _resetTryout() {
    setState(() {
      _tryoutAnswers = List.filled(_tryoutNumbers.length - 1, null);
      _tryoutCorrectness = List.filled(_tryoutNumbers.length - 1, null);
      _tryoutActiveIndex = 0;
      _tryoutCompleted = false;
    });
  }

  void _handleTryoutInput(int number) {
    if (_tryoutCompleted) return;

    final settings = context.read<SettingsBloc>().state;
    final num1 = _tryoutNumbers[_tryoutActiveIndex];
    final num2 = _tryoutNumbers[_tryoutActiveIndex + 1];
    final isAddition = settings.operationType == 'addition' || settings.operationType == 'mixed';
    final correctDigit = isAddition
        ? (num1 + num2) % 10
        : ((num1 - num2) % 10 + 10) % 10;
    final isCorrect = number == correctDigit;

    if (isCorrect) {
      _audioService.playCorrect();
    } else {
      _audioService.playIncorrect();
    }

    setState(() {
      _tryoutAnswers[_tryoutActiveIndex] = number;
      _tryoutCorrectness[_tryoutActiveIndex] = isCorrect;

      if (_tryoutActiveIndex < _tryoutAnswers.length - 1) {
        _tryoutActiveIndex++;
      } else {
        _tryoutCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocalizationBloc>().state.loc;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('instructions_title'))),
      body: SingleChildScrollView(
        padding: AppTheme.screenPadding,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTutorialCard(loc),
            const SizedBox(height: AppTheme.s24),
            _buildAudioCheckCard(loc),
            const SizedBox(height: AppTheme.s24),
            _buildPracticeSection(loc),
            const SizedBox(height: AppTheme.s40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameplayScreen())),
              child: Text(loc.translate('start_real_test')),
            ),
            const SizedBox(height: AppTheme.s24),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialCard(AppLocalizations loc) {
    final settings = context.watch<SettingsBloc>().state;
    final isAddition = settings.operationType == 'addition' || settings.operationType == 'mixed';
    final isSubtraction = settings.operationType == 'subtraction' || settings.operationType == 'mixed';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                const SizedBox(width: AppTheme.s12),
                Text(loc.translate('how_to_test'), style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppTheme.s20),
            if (isAddition) ...[
              _TutorialStep(stepNumber: '1', text: loc.translate('tutorial_step1')),
              _TutorialStep(stepNumber: '2', text: loc.translate('tutorial_step2'), subText: loc.translate('tutorial_step2_example')),
            ],
            if (isSubtraction) ...[
              _TutorialStep(stepNumber: '1', text: loc.translate('tutorial_step_sub')),
              _TutorialStep(stepNumber: '2', text: loc.translate('tutorial_step2'), subText: loc.translate('tutorial_step_sub_example')),
            ],
            _TutorialStep(stepNumber: '3', text: loc.translate('tutorial_step3')),
            _TutorialStep(stepNumber: '4', text: loc.translate('tutorial_step4')),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioCheckCard(AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.s20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('audio_sfx'), style: Theme.of(context).textTheme.titleSmall),
                  Text(loc.translate('audio_desc'), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => _audioService.playCorrect(),
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeSection(AppLocalizations loc) {
    final settings = context.watch<SettingsBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PRACTICE CALIBRATION', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
            if (_tryoutCompleted)
              TextButton.icon(
                onPressed: _resetTryout,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(loc.translate('retry_practice'), style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: AppTheme.s16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.s20),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 260,
                      child: MatrixColumnWidget(
                        numbers: _tryoutNumbers,
                        userAnswers: _tryoutAnswers,
                        answerCorrectness: _tryoutCorrectness,
                        activeIndex: _tryoutActiveIndex,
                        isActiveColumn: true,
                        animationsEnabled: settings.animationsEnabled,
                      ),
                    ),
                    const SizedBox(width: AppTheme.s24),
                    Expanded(child: _buildPracticeGuide(loc, settings)),
                  ],
                ),
                const SizedBox(height: AppTheme.s24),
                CustomNumpad(onNumberPressed: _handleTryoutInput, layout: settings.keyboardLayout),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeGuide(AppLocalizations loc, AppSettings settings) {
    if (_tryoutCompleted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 32),
          const SizedBox(height: AppTheme.s8),
          Text(loc.translate('practice_complete'), style: Theme.of(context).textTheme.titleSmall),
          Text(loc.translate('practice_complete_desc'), style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }
    final isAddition = settings.operationType == 'addition' || settings.operationType == 'mixed';
    final guideKey = isAddition ? 'practice_guide_add' : 'practice_guide_sub';

    return Text(
      loc.translate(guideKey),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _TutorialStep extends StatelessWidget {
  final String stepNumber;
  final String text;
  final String? subText;

  const _TutorialStep({required this.stepNumber, required this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary, 
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              stepNumber, 
              style: const TextStyle(
                color: AppColors.textOnPrimary, // Charcoal black for legibility
                fontSize: 12, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text, 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subText != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? AppColors.zinc800 
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      subText!, 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface, 
                        fontSize: 12, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
