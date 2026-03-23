import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/job_model.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final JobModel job;
  const BookingConfirmationScreen({super.key, required this.job});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 1.0));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.job;
    final color = AppColors.categoryColors[j.category] ?? AppColors.saffron;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),

              // Success animation
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Transform.scale(
                  scale: _scaleAnim.value,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.emerald, Color(0xFF00A878)]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.emerald.withOpacity(0.4), blurRadius: 40, spreadRadius: 10)],
                    ),
                    child: const Center(child: Icon(Icons.check_rounded, color: Colors.white, size: 64)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    const Text(
                      'Booking Confirmed! 🎉',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.dark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'re all set. Show up on time and get paid same day!',
                      style: TextStyle(fontSize: 14, color: AppColors.grey500, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Booking card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16)],
                      ),
                      child: Column(
                        children: [
                          _Row('📋', 'Job', j.title),
                          const Divider(height: 20, color: AppColors.grey100),
                          _Row('🏢', 'Employer', j.employerName),
                          const Divider(height: 20, color: AppColors.grey100),
                          _Row('📅', 'Date', j.date),
                          const Divider(height: 20, color: AppColors.grey100),
                          _Row('⏰', 'Shift', j.shiftTime),
                          const Divider(height: 20, color: AppColors.grey100),
                          _Row('💰', 'You Earn', '₹${j.totalEarnings.toInt()} (same day!)'),
                          const Divider(height: 20, color: AppColors.grey100),
                          _Row('📍', 'Location', j.address),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Booking ID
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.emerald.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_number_rounded, size: 16, color: AppColors.emerald),
                          const SizedBox(width: 8),
                          Text(
                            'Booking ID: IND-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            style: const TextStyle(fontSize: 13, color: AppColors.emerald, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // CTA Buttons
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_rounded, size: 18),
                        label: const Text('Contact Employer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.grey300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Find More Jobs', style: TextStyle(color: AppColors.grey700)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}

class _Row extends StatelessWidget {
  final String icon, label, value;
  const _Row(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.grey500)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
