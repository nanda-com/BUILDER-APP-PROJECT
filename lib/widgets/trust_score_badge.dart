import 'package:flutter/material.dart';
import '../app_theme.dart';

class TrustScoreBadge extends StatelessWidget {
  final double score; // 0-100
  final double size;
  final bool showLabel;
  const TrustScoreBadge({
    super.key,
    required this.score,
    this.size = 56,
    this.showLabel = true,
  });

  Color get _color {
    if (score >= 80) return AppColors.emerald;
    if (score >= 60) return AppColors.golden;
    return AppColors.ruby;
  }

  String get _label {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    return 'New';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: size * 0.1,
                backgroundColor: _color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(_color),
                strokeCap: StrokeCap.round,
              ),
              Text(
                score.toInt().toString(),
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w800,
                  color: _color,
                ),
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            _label,
            style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey500),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
          ],
        ],
      ),
    );
  }
}
