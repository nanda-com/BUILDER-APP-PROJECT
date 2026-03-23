import 'dart:async';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'worker_earnings_screen.dart';
import 'explore_gigs_screen.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/job_card.dart';
import 'job_detail_screen.dart';
import 'worker_profile_screen.dart';
import '../auth/role_selection_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _navIndex = 0;
  bool _isClockedIn = false;
  bool _isLoadingClockIn = false;
  DateTime? _clockInTime;
  Timer? _timer;
  String _elapsedTime = "00:00:00";

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleClockIn() {
    if (_isClockedIn) {
      // Clock out
      setState(() => _isLoadingClockIn = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        _timer?.cancel();
        setState(() {
          _isClockedIn = false;
          _isLoadingClockIn = false;
          _clockInTime = null;
          _elapsedTime = "00:00:00";
        });
      });
    } else {
      // Clock in
      setState(() => _isLoadingClockIn = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isClockedIn = true;
          _isLoadingClockIn = false;
          _clockInTime = DateTime.now();
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) return;
          final duration = DateTime.now().difference(_clockInTime!);
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          setState(() {
            _elapsedTime = "$hours:$minutes:$seconds";
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeBody(context),
      const ExploreGigsScreen(), // Replace Gigs placeholder
      const WorkerEarningsScreen(standalone: false),
      const Scaffold(body: Center(child: Text('Learn Placeholder'))), // Learn
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: screens[_navIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 4,
        backgroundColor: AppColors.royalBlue,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner_rounded,
            color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _homeBody(BuildContext context) {
    final recentJobs =
        MockDataService.allJobs.where((j) => j.isOpen).take(3).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProfileScreen())),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hey, Aryan!',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark)),
                    Text('B.Tech Student • 3rd Year',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.grey500)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text('A',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.royalBlue,
                            fontSize: 13)),
                    Text(' / ',
                        style:
                            TextStyle(color: AppColors.grey300, fontSize: 13)),
                    Text('अ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                            fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                    (route) => false,
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.grey100,
                  padding: const EdgeInsets.all(10),
                ),
                icon: const Icon(Icons.logout_rounded, color: AppColors.saffron, size: 20),
                tooltip: 'Log Out',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Wallet Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.royalBlue,
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF286BF5), Color(0xFF1652E2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                    color: AppColors.royalBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('POCKET MONEY',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5)),
                        Text(' / कमाई',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history_rounded,
                          color: Colors.white, size: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text('+₹500 from tutoring',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('₹ 3,250',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('this month',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF23D5B9), Color(0xFF1EBBDB)]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {},
                            child: const Center(
                              child: Text('Withdraw  (पैसे निकालें)',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {},
                            child: const Center(
                              child: Text('Add Wallet',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Next Shift Header
          _SectionHeader('Next Shift', 'अगली शिफ्ट',
              actionWidget: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.royalBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Starts Soon',
                    style: TextStyle(
                        color: AppColors.royalBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              )),
          const SizedBox(height: 16),

          // Shift Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.grey100, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B8B77),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                          child: Icon(Icons.menu_book_rounded,
                              color: Colors.white, size: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Library Assistant',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.dark)),
                          const SizedBox(height: 4),
                          const Text('Central Library, Block C',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.grey500)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.royalBlue.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.schedule_rounded,
                                        size: 12, color: AppColors.royalBlue),
                                    SizedBox(width: 4),
                                    Text('4:00 PM',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.royalBlue,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Today',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColors.grey500)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _isLoadingClockIn ? null : _toggleClockIn,
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isClockedIn ? AppColors.emerald.withOpacity(0.1) : AppColors.offWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _isClockedIn ? AppColors.emerald : AppColors.grey100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _isClockedIn ? AppColors.emerald : AppColors.royalBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: _isLoadingClockIn
                              ? const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Icon(
                                  _isClockedIn ? Icons.stop_rounded : Icons.chevron_right_rounded,
                                  color: Colors.white),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                                _isClockedIn ? 'Clocked In - $_elapsedTime' : 'Clock-in Now',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: _isClockedIn ? AppColors.emerald : AppColors.dark)),
                          ),
                        ),
                        const SizedBox(width: 48), // balance
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Recent Gigs Header
          _SectionHeader('New Gigs Nearby', 'नये काम',
              actionWidget: GestureDetector(
                onTap: () => setState(() => _navIndex = 1),
                child: const Text('View All',
                    style: TextStyle(
                        color: AppColors.royalBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              )),
          const SizedBox(height: 16),

          // Recent Gigs List (Horizontal)
          if (recentJobs.isEmpty)
            const Text('No recent gigs available.',
                style: TextStyle(color: AppColors.grey500))
          else
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: recentJobs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final job = recentJobs[index];
                  return SizedBox(
                    width: 320,
                    child: JobCard(
                      job: job,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(job: job),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 32),

          // Internship Prep Header
          const _SectionHeader('Internship Prep', 'तैयारी',
              actionWidget: Text('View All',
                  style: TextStyle(
                      color: AppColors.royalBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13))),
          const SizedBox(height: 16),

          // Internship Scrolling List
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: const [
                _VideoCard(
                    title: 'Resume Hacks\nरेज्यूमे टिप्स',
                    duration: '5m 10s',
                    color: Color(0xFF2C3E50)),
                SizedBox(width: 16),
                _VideoCard(
                    title: 'Acing Interviews\nइंटरव्यू स्किल्स',
                    duration: '3m 45s',
                    color: Color(0xFF1E272E)),
                SizedBox(width: 16),
                _VideoCard(
                    title: 'Email Etiquette\nईमेल लिखना सीखें',
                    duration: '2m 30s',
                    color: Color(0xFF4B4B4B)),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Your Achievements Header
          const _SectionHeader('Your Achievements', 'बैज'),
          const SizedBox(height: 16),

          // Achievements Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey100, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: AppColors.royalBlue.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.verified_rounded,
                            color: AppColors.royalBlue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Certified',
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.grey500)),
                            Text('Python\nBasics',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                    height: 1.2)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey100, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: AppColors.emerald.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.emoji_events_rounded,
                            color: AppColors.emerald, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Top Rated',
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.grey500)),
                            Text('Campus\nStar',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                    height: 1.2)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String titleEn;
  final String titleHi;
  final Widget? actionWidget;

  const _SectionHeader(this.titleEn, this.titleHi, {this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(titleEn,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy)),
        const Text(' / ',
            style: TextStyle(fontSize: 14, color: AppColors.grey300)),
        Text(titleHi,
            style: const TextStyle(fontSize: 14, color: AppColors.grey500)),
        const Spacer(),
        if (actionWidget != null) actionWidget!,
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String duration;
  final Color color;

  const _VideoCard(
      {required this.title, required this.duration, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          // Play button center
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
          ),
          // Duration Chip
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Text(duration,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark)),
            ),
          ),
          // Title
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 1.3)),
            ),
          )
        ],
      ),
    );
  }
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
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap),
            _NavItem(
                icon: Icons.work_outline_rounded,
                label: 'Gigs',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap),
            const SizedBox(width: 48), // Space for FAB
            _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap),
            _NavItem(
                icon: Icons.school_outlined,
                label: 'Learn',
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
    final color = isActive ? AppColors.royalBlue : AppColors.grey500;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: color)),
        ],
      ),
    );
  }
}
