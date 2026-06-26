import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MatrixColumnWidget extends StatefulWidget {
  final List<int> numbers;
  final List<int?> userAnswers;
  final List<bool?> answerCorrectness;
  final int activeIndex;
  final bool isActiveColumn;
  final bool animationsEnabled;

  const MatrixColumnWidget({
    super.key,
    required this.numbers,
    required this.userAnswers,
    required this.answerCorrectness,
    required this.activeIndex,
    required this.isActiveColumn,
    this.animationsEnabled = true,
  });

  @override
  State<MatrixColumnWidget> createState() => _MatrixColumnWidgetState();
}

class _MatrixColumnWidgetState extends State<MatrixColumnWidget> {
  final ScrollController _scrollController = ScrollController();

  static const double digitHeight = 44.0;
  static const double answerHeight = 36.0;
  static const double itemHeight = digitHeight + answerHeight;

  @override
  void didUpdateWidget(covariant MatrixColumnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActiveColumn && widget.activeIndex != oldWidget.activeIndex) {
      _scrollToActiveIndex();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToActiveIndex() {
    if (!_scrollController.hasClients) return;

    final viewportHeight = _scrollController.position.viewportDimension;
    final targetOffset = (widget.activeIndex * itemHeight) + (itemHeight / 2) - (viewportHeight / 2.5);
    final clamped = targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent);

    if (widget.animationsEnabled) {
      _scrollController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.jumpTo(clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = widget.isActiveColumn ? 1.0 : 0.3;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerColor = widget.isActiveColumn
        ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.6 : 0.8)
        : Colors.transparent;
    final borderColor = widget.isActiveColumn
        ? Theme.of(context).colorScheme.outline
        : null;

    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.builder(
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.numbers.length + widget.numbers.length - 1,
          padding: const EdgeInsets.symmetric(vertical: 48),
          itemBuilder: (context, index) {
            final isDigit = index % 2 == 0;
            final itemIndex = index ~/ 2;

            if (isDigit) {
              final digit = widget.numbers[itemIndex];
              final isPartOfActiveSum = widget.isActiveColumn &&
                  (itemIndex == widget.activeIndex || itemIndex == widget.activeIndex + 1);

              final style = TextStyle(
                fontSize: isPartOfActiveSum ? 26 : 20,
                fontWeight: isPartOfActiveSum ? FontWeight.w700 : FontWeight.w500,
                color: isPartOfActiveSum
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textWhite.withValues(alpha: 0.25)
                        : AppColors.textPrimary.withValues(alpha: 0.25)),
              );

              if (widget.animationsEnabled) {
                return Container(
                  height: digitHeight,
                  alignment: Alignment.center,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: style,
                    child: Text(digit.toString()),
                  ),
                );
              }
              return Container(
                height: digitHeight,
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: style,
                  child: Text(digit.toString()),
                ),
              );
            } else {
              final answerIndex = itemIndex;
              final answer = widget.userAnswers[answerIndex];
              final correctness = widget.answerCorrectness[answerIndex];
              final isActiveAnswer = widget.isActiveColumn && answerIndex == widget.activeIndex;

              final isDark = Theme.of(context).brightness == Brightness.dark;
              Color containerBg = Colors.transparent;
              Color borderColor = Theme.of(context).colorScheme.outline;
              Color textColor = Theme.of(context).colorScheme.onSurface;
              TextDecoration textDecoration = TextDecoration.none;

              if (isActiveAnswer) {
                borderColor = AppColors.primary;
                containerBg = AppColors.primary.withValues(alpha: 0.08);
              } else if (answer != null) {
                if (correctness == true) {
                  textColor = AppColors.primary;
                  borderColor = AppColors.primary;
                  containerBg = AppColors.primary.withValues(alpha: 0.08);
                } else {
                  textColor = (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary).withValues(alpha: 0.4);
                  borderColor = Theme.of(context).colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.5);
                  containerBg = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
                  textDecoration = TextDecoration.lineThrough;
                }
              }

              return Center(
                child: Container(
                  height: answerHeight,
                  width: 44,
                  decoration: BoxDecoration(
                    color: containerBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: borderColor, 
                      width: isActiveAnswer ? 2 : 1,
                      style: correctness == false && answer != null ? BorderStyle.solid : BorderStyle.solid,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isActiveAnswer && answer == null
                      ? _buildCursor()
                      : Text(
                          answer?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            decoration: textDecoration,
                            decorationColor: textColor,
                          ),
                        ),
                ),
              );
            }
          },
        ),
      ),
    );

    if (widget.animationsEnabled) {
      return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: container,
      );
    }
    return Opacity(
      opacity: opacity,
      child: container,
    );
  }

  Widget _buildCursor() {
    return _BlinkingCursor(animationsEnabled: widget.animationsEnabled);
  }
}

class _BlinkingCursor extends StatefulWidget {
  final bool animationsEnabled;

  const _BlinkingCursor({this.animationsEnabled = true});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (widget.animationsEnabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursor = Container(
      height: 20,
      width: 3,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(1),
      ),
    );
    if (widget.animationsEnabled) {
      return FadeTransition(
        opacity: _controller,
        child: cursor,
      );
    }
    return cursor;
  }
}
