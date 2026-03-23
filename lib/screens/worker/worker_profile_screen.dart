import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/trust_score_badge.dart';
import '../auth/role_selection_screen.dart';

class WorkerProfileScreen extends StatefulWidget {
  final bool standalone;
  const WorkerProfileScreen({super.key, this.standalone = true});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  void _showEditNameDialog(BuildContext context, UserModel me) {
    final TextEditingController nameCtrl = TextEditingController(text: me.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(hintText: 'Enter new name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameCtrl.text.trim();
              if (newName.isNotEmpty) {
                setState(() {
                  final index = MockDataService.allWorkers.indexWhere((w) => w.id == me.id);
                  if (index != -1) {
                    MockDataService.allWorkers[index] = me.copyWith(name: newName);
                  }
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel me = MockDataService.allWorkers.first;
    final bookings = MockDataService.myBookings;
    final completed = bookings.where((b) => b.status == 'completed').toList();

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.navy,
            automaticallyImplyLeading: widget.standalone,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.navy, Color(0xFF1A2F5E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              gradient: AppColors.saffronGrad,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [BoxShadow(color: AppColors.saffron.withOpacity(0.4), blurRadius: 20)],
                            ),
                            child: Center(
                              child: Text(me.initials, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                          ),
                          if (me.isVerified)
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                width: 24, height: 24,
                                decoration: BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                child: const Icon(Icons.check, color: Colors.white, size: 13),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(me.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showEditNameDialog(context, me),
                            child: const Icon(Icons.edit, color: Colors.white70, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(me.phone, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6))),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PillBadge('⭐ ${me.rating}', AppColors.golden),
                          const SizedBox(width: 10),
                          _PillBadge('✅ ${me.jobsCompleted} Jobs Done', AppColors.emerald),
                          const SizedBox(width: 10),
                          _PillBadge('📍 ${me.city}', AppColors.sky),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trust score + stats
                  Row(
                    children: [
                      TrustScoreBadge(score: me.trustScore, size: 80),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Trust Score', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                            SizedBox(height: 4),
                            Text(
                              'Your trust score affects how quickly employers accept you. Keep completing jobs to increase it!',
                              style: TextStyle(fontSize: 12, color: AppColors.grey500, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Skills
                  const Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: me.skills.map((s) {
                      final color = AppColors.categoryColors[s] ?? AppColors.saffron;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Text(s, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Work history
                  const Text('Work History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 12),
                  ...MockDataService.myBookings.map((b) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: (b.status == 'completed' ? AppColors.emerald : AppColors.saffron).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            b.status == 'completed' ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
                            color: b.status == 'completed' ? AppColors.emerald : AppColors.saffron,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.jobTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                              Text('${b.date} • ${b.employerName}', style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
                            ],
                          ),
                        ),
                        if (b.earnedAmount != null)
                          Text('₹${b.earnedAmount!.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.emerald))
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.saffron.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(b.statusLabel, style: const TextStyle(fontSize: 11, color: AppColors.saffron, fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Clear any state if necessary, then navigate to start
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PillBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
