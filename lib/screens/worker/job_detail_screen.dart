import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/job_model.dart';
import '../../widgets/trust_score_badge.dart';
import 'booking_confirmation_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;
  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _booking = false;

  void _book() async {
    setState(() => _booking = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _booking = false);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, a, __) => BookingConfirmationScreen(job: widget.job),
        transitionsBuilder: (_, a, __, child) =>
            SlideTransition(position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)), child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.job;
    final color = AppColors.categoryColors[j.category] ?? AppColors.saffron;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30, top: -30,
                      child: Container(
                        width: 180, height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24, left: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(j.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            j.title,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(j.address, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wage, earnings, distance row
                  Row(
                    children: [
                      _BigStat('₹${j.wagePerHour.toInt()}', 'per hour', AppColors.saffron),
                      const SizedBox(width: 12),
                      _BigStat('₹${j.totalEarnings.toInt()}', 'total earning', AppColors.emerald),
                      const SizedBox(width: 12),
                      if (j.distanceKm != null) _BigStat(j.distanceLabel, 'from you', AppColors.sky),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Shift info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _ShiftRow(Icons.calendar_today_rounded, 'Date', j.date),
                        const Divider(height: 16, color: AppColors.grey100),
                        _ShiftRow(Icons.schedule_rounded, 'Shift Time', j.shiftTime),
                        const Divider(height: 16, color: AppColors.grey100),
                        _ShiftRow(Icons.timer_outlined, 'Duration', j.duration),
                        const Divider(height: 16, color: AppColors.grey100),
                        _ShiftRow(Icons.people_rounded, 'Slots Available', '${j.slotsLeft} of ${j.workersNeeded}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Employer section
                  const Text('Employer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.15),
                          radius: 26,
                          child: Text(
                            j.employerName.substring(0, 1).toUpperCase(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(j.employerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.dark)),
                                  if (j.employerVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, color: AppColors.emerald, size: 16),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(5, (i) => Icon(
                                  i < j.employerRating.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                                  size: 15, color: AppColors.golden,
                                ))..add(const SizedBox(width: 4))..add(
                                  Text('${j.employerRating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.grey700)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TrustScoreBadge(score: j.employerRating * 20, size: 52, showLabel: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text('About this Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 8),
                  Text(j.description, style: const TextStyle(fontSize: 14, color: AppColors.grey700, height: 1.6)),
                  const SizedBox(height: 20),

                  // Requirements
                  const Text('Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 12),
                  ...j.requirements.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.12), shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, size: 13, color: AppColors.emerald),
                        ),
                        const SizedBox(width: 10),
                        Text(r, style: const TextStyle(fontSize: 14, color: AppColors.grey700)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: ElevatedButton(
                  onPressed: _booking ? null : _book,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _booking
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Book Now ⚡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.grey700),
                onPressed: () {},
                padding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _BigStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.grey500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ShiftRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.saffron),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.grey500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark)),
      ],
    );
  }
}
