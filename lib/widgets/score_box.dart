import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class ScoreBox extends StatelessWidget {
  final String score;
  final bool isTotal;
  final bool isPerfectScore;
  final bool isLessThanHalf;

  const ScoreBox({
    super.key,
    required this.score,
    this.isTotal = false,
    this.isPerfectScore = false,
    this.isLessThanHalf = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget scoreContent = Container(
      constraints: const BoxConstraints(
        minWidth: 45,
        minHeight: 26,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isTotal
            ? const Color(0xFFE0E0E0)
            : const Color.fromRGBO(9, 11, 17, 1),
        borderRadius: BorderRadius.circular(20),
        border: isPerfectScore && !isTotal
            ? Border.all(color: Colors.green, width: 1)
            : null,
      ),
      child: Text(
        score,
        style: TextStyle(
          color: _getTextColor(),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );

    if (isLessThanHalf && !isTotal) {
      return DottedBorder(
        color: Colors.red,
        strokeWidth: 1,
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        padding: EdgeInsets.zero,
        child: scoreContent,
      );
    }

    return scoreContent;
  }

  Color _getTextColor() {
    if (isTotal) return Colors.black;
    if (isPerfectScore) return Colors.green;
    if (score == 'Abs' || isLessThanHalf) return Colors.red;
    return Colors.white;
  }
}

class ScoreBoxPair extends StatelessWidget {
  final String scored;
  final String total;

  const ScoreBoxPair({
    super.key,
    required this.scored,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValidScore = scored != "Abs";
    final double? scoreValue = isValidScore ? double.tryParse(scored) : null;
    final double? totalValue = double.tryParse(total);

    final bool isPerfectScore = isValidScore &&
        scoreValue != null &&
        totalValue != null &&
        scoreValue >= totalValue;

    final bool isLessThanHalf = isValidScore &&
        scoreValue != null &&
        totalValue != null &&
        scoreValue < (totalValue / 2);

    return Row(
      children: [
        ScoreBox(
          score: scored,
          isPerfectScore: isPerfectScore,
          isLessThanHalf: isLessThanHalf,
        ),
        const SizedBox(width: 5),
        ScoreBox(
          score: total,
          isTotal: true,
        ),
      ],
    );
  }
}
