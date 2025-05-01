import 'package:classpro/styles.dart';
import 'package:classpro/widgets/score_box.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class GradexWidget extends StatefulWidget {
  final String courseName;
  final String credit;
  final String scored;
  final String total;
  final String grade;
  final Function(String grade, int credits) onGradeSelected;
  const GradexWidget({
    super.key,
    required this.courseName,
    required this.credit,
    required this.scored,
    required this.total,
    required this.grade,
    required this.onGradeSelected,
  });

  @override
  State<GradexWidget> createState() => _GradexWidgetState();
}

class _GradexWidgetState extends State<GradexWidget> {
  bool isSelected = true;
  late TextEditingController _remainingController;
  late int remaining;
  late int maxRemaining;
  late double goalMarks;
  double internalMarks = 0;
  String currentGrade = 'A';

  final Map<String, double> gradeCutoffs = {
    "O": 91,
    "A+": 81,
    "A": 71,
    "B+": 61,
    "B": 56,
    "C": 50,
  };

  double calculateRequiredMarks(double internalMarks, String targetGrade) {
    if (internalMarks < 0 || internalMarks > 60) {
      return -1;
    }
    double totalRequired = gradeCutoffs[targetGrade]!;

    double requiredInSemesterOutOf40 = totalRequired - internalMarks;

    double requiredOutOf75 = (requiredInSemesterOutOf40 / 40) * 75;
    goalMarks = double.parse(requiredOutOf75.toStringAsFixed(2));

    setState(() {
      goalMarks = goalMarks;
    });
    return goalMarks;
  }

  @override
  void initState() {
    super.initState();
    final int totalScored = (double.tryParse(widget.total) ?? 0).toInt();
    final int scored = (double.tryParse(widget.scored) ?? 0).toInt();
    remaining = 60 - totalScored;
    maxRemaining = remaining;
    _remainingController = TextEditingController(text: remaining.toString());
    internalMarks = scored + remaining.toDouble();

    goalMarks = calculateRequiredMarks(internalMarks, 'A');

    _remainingController.addListener(() {
      final String text = _remainingController.text;
      if (text.isNotEmpty) {
        remaining = int.tryParse(text) ?? 0;
      } else {
        remaining = 0;
      }
      setState(() {
        goalMarks =
            calculateRequiredMarks(scored + remaining.toDouble(), currentGrade);
        widget.onGradeSelected(currentGrade, int.parse(widget.credit));
      });
    });
  }

  @override
  void dispose() {
    _remainingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String scored = widget.scored;
    final String total = widget.total;

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: 350,
        decoration: BoxDecoration(
          color: AppColors.backgroundNormal,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.courseName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ScoreBoxPair(scored: scored, total: total),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            size: 15,
                            color: AppColors.accentColor,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "Included",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Text("Credit: ${widget.credit}",
                style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            GradeSliderWidget(
              initialGrade: widget.grade,
              onChanged: (grade) {
                currentGrade = grade;
                goalMarks = calculateRequiredMarks(
                  (double.tryParse(widget.scored) ?? 0) + remaining.toDouble(),
                  currentGrade,
                );
                widget.onGradeSelected(currentGrade, int.parse(widget.credit));
              },
            ),
            const SizedBox(height: 10),
            Divider(
              color: AppColors.accentColor.withAlpha((255 * 0.5).round()),
              thickness: 1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Goal for sem exam",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D0D),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: Text(
                          goalMarks.toString(),
                          style: goalMarks > 75
                              ? TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.errorColor,
                                )
                              : goalMarks < 0
                                  ? TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentColor,
                                    )
                                  : TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.successColor,
                                    ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.successColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        margin: EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          "75",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                  child: Center(
                    child: Text(
                      "Expected remaining from $maxRemaining:",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  width: 54,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Center(
                    child: TextField(
                      controller: _remainingController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      maxLines: 1,
                      cursorColor: Colors.white,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          if (newValue.text.isEmpty) return newValue;

                          final int? value = int.tryParse(newValue.text);
                          if (value != null && value <= maxRemaining) {
                            return newValue;
                          }

                          return oldValue;
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GradeSliderWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final String? initialGrade;

  const GradeSliderWidget({
    super.key,
    this.onChanged,
    this.initialGrade,
  });

  @override
  State<GradeSliderWidget> createState() => _GradeSliderWidgetState();
}

class _GradeSliderWidgetState extends State<GradeSliderWidget> {
  final List<String> grades = ['C', 'B', 'B+', 'A', 'A+', 'O'];
  double _sliderValue = 5;

  @override
  void initState() {
    super.initState();
    if (widget.initialGrade != null && grades.contains(widget.initialGrade)) {
      _sliderValue = grades.indexOf(widget.initialGrade!).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: const FullWidthSliderTrackShape(),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withAlpha((255 * 0.3).round()),
            trackHeight: 8,
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.black,
            inactiveTickMarkColor: Colors.black,
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: Slider(
            min: 0,
            max: (grades.length - 1).toDouble(),
            divisions: grades.length - 1,
            value: _sliderValue,
            onChanged: (value) {
              setState(() {
                _sliderValue = value.roundToDouble();
                if (widget.onChanged != null) {
                  widget.onChanged!(grades[_sliderValue.toInt()]);
                }
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: grades
              .map(
                (grade) => Text(
                  grade,
                  style: TextStyle(
                      color: _sliderValue == grades.indexOf(grade)
                          ? AppColors.accentColor
                          : AppColors.accentColor
                              .withAlpha((255 * 0.4).round()),
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class FullWidthSliderTrackShape extends SliderTrackShape {
  const FullWidthSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(
      offset.dx,
      trackTop,
      parentBox.size.width,
      trackHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final double trackRadius = 10.0;

    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!;

    final bool isLTR = textDirection == TextDirection.ltr;

    final RRect leftTrackSegment = RRect.fromRectAndRadius(
      Rect.fromLTRB(
          trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom),
      Radius.circular(trackRadius),
    );

    final RRect rightTrackSegment = RRect.fromRectAndRadius(
      Rect.fromLTRB(
          thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom),
      Radius.circular(trackRadius),
    );

    context.canvas
        .drawRRect(isLTR ? leftTrackSegment : rightTrackSegment, activePaint);
    context.canvas
        .drawRRect(isLTR ? rightTrackSegment : leftTrackSegment, inactivePaint);
  }
}
