import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'post_job_screen.dart';
import '../../services/auth_service.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/job_card.dart';
import '../auth/role_selection_screen.dart';
import 'hiring_screen.dart';
import 'messages_screen.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _dashboardBody(),
      const HiringScreen(),
      const MessagesScreen(),
      _profileBody(context),
    ];

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: screens[_navIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF00C8C8),
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.mic_none_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 4)
                ],
              ),
              child: const Text('Tap to Post',
                  style: TextStyle(
                      color: Color(0xFF00C8C8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _dashboardBody() {
    final currentUser = AuthService.currentUser;
    final myJobs = MockDataService.allJobs
        .where((j) => j.employerId == (currentUser?.id ?? 'e001'))
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Curved Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: AppColors.royalBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello,',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16)),
                        Text('Employer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFF4CC9F0), size: 16),
                      const SizedBox(width: 8),
                      const Text('Remote / Hybrid',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                      const SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white.withOpacity(0.7), size: 18),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Average Hourly Wages
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader('Average Hourly Wages',
                actionText: 'View Trends'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: const [
                _WageCard(
                    title: 'SOCIAL MEDIA\nINTERN',
                    symbol: '\$',
                    hourly: '18',
                    trend: '+2.4%',
                    isPositive: true),
                SizedBox(width: 16),
                _WageCard(
                    title: 'ACADEMIC TUTOR',
                    symbol: '\$',
                    hourly: '25',
                    trend: 'Stable',
                    isPositive: false),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Project Teams
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Project Teams',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: Color(0xFFE0F7FA), shape: BoxShape.circle),
                          child: const Icon(Icons.people_alt_rounded,
                              color: Color(0xFF00838F)),
                        ),
                        const SizedBox(height: 16),
                        const Text('Manage\nEmployees',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                                height: 1.2)),
                        const SizedBox(height: 8),
                        const Text('8 Active Projects',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0097A7),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PostJobScreen())),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color(0xFFE0F2F1),
                            width: 1.5,
                            style: BorderStyle.none),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _DashedRectPainter(
                                  color: const Color(0xFFB2DFDB)),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFF9FBE7),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.person_add_rounded,
                                      color: Color(0xFF558B2F)),
                                ),
                                const SizedBox(height: 16),
                                const Text('Post Job',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                        height: 1.2)),
                                const SizedBox(height: 8),
                                const Text('Find new talent',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grey500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Active Roles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader('Active Roles', actionText: 'View All (${myJobs.length})'),
          ),
          const SizedBox(height: 16),
          if (myJobs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('You have no active roles.', style: TextStyle(color: AppColors.grey500)),
            )
          else
            ...myJobs.map((job) => Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  child: JobCard(
                    job: job,
                    onTap: () {}, // Future details screen for employer
                  ),
                )),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _profileBody(BuildContext context) {
    final currentUser = AuthService.currentUser;
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Employer Profile', style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C8C8).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currentUser?.name.isNotEmpty == true ? currentUser!.name[0].toUpperCase() : 'E',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0097A7)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentUser?.name ?? 'Employer', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.dark)),
                      const SizedBox(height: 4),
                      Text(currentUser?.phone ?? '', style: const TextStyle(fontSize: 14, color: AppColors.grey500)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: const Text('Verified Employer ✅', style: TextStyle(fontSize: 12, color: AppColors.emerald, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.saffron),
                label: const Text('Log Out', style: TextStyle(color: AppColors.saffron, fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.saffron.withOpacity(0.5), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  const _SectionHeader(this.title, {required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.dark)),
        Text(actionText,
            style: const TextStyle(
                color: Color(0xFF00838F),
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _WageCard extends StatelessWidget {
  final String title;
  final String symbol;
  final String hourly;
  final String trend;
  final bool isPositive;

  const _WageCard(
      {required this.title,
      required this.symbol,
      required this.hourly,
      required this.trend,
      required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0097A7),
                          height: 1.2))),
              isPositive
                  ? const Icon(Icons.campaign_outlined,
                      color: AppColors.grey300, size: 20)
                  : const Icon(Icons.school_outlined,
                      color: AppColors.grey300, size: 20),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(symbol,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark)),
              Text(hourly,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark)),
              const Padding(
                padding: EdgeInsets.only(bottom: 6, left: 2),
                child: Text('/hr',
                    style: TextStyle(fontSize: 12, color: AppColors.grey500)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive ? const Color(0xFFE0F7FA) : AppColors.grey100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPositive)
                  const Icon(Icons.trending_up_rounded,
                      color: Color(0xFF00ACC1), size: 12),
                if (!isPositive)
                  const Icon(Icons.remove_rounded,
                      color: AppColors.grey500, size: 12),
                const SizedBox(width: 4),
                Text(trend,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isPositive
                            ? const Color(0xFF00ACC1)
                            : AppColors.grey500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(24)));

    // Simplistic dash effect simulation via modulo length
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? 8.0 : 6.0;
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 20,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            _NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dash',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap),
            const SizedBox(width: 32),
            _NavItem(
                icon: Icons.work_outline_rounded,
                label: 'Hiring',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap),
            const SizedBox(width: 32),
            _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Messages',
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap),
            const SizedBox(width: 32),
            _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.index,
      required this.currentIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final color = isActive ? const Color(0xFF0097A7) : AppColors.grey500;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: color)),
        ],
      ),
    );
  }
}
