import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/mock_data_service.dart';

class ManageWorkersScreen extends StatelessWidget {
  final bool standalone;
  const ManageWorkersScreen({super.key, this.standalone = true});

  @override
  Widget build(BuildContext context) {
    final jobs = MockDataService.allJobs.take(3).toList();
    final workers = MockDataService.allWorkers;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: standalone
          ? AppBar(title: const Text('Manage Workers'), backgroundColor: AppColors.white, elevation: 0)
          : PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                color: AppColors.white,
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Text('Manage Workers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  ),
                ),
              ),
            ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: jobs.map((job) {
          final color = AppColors.categoryColors[job.category] ?? AppColors.saffron;
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                        child: Text(job.category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(job.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.dark)),
                      ),
                      Text('${job.date} • ${job.shiftTime.split('–')[0].trim()}',
                          style: const TextStyle(fontSize: 11, color: AppColors.grey500)),
                    ],
                  ),
                ),
                // Worker rows
                ...workers.take(job.workersBooked + 1).map((w) => Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.grey100)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.saffron.withOpacity(0.15),
                        radius: 20,
                        child: Text(w.initials, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.saffron)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(w.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                          Text('Trust ${w.trustScore.toInt()} • ⭐ ${w.rating}',
                              style: const TextStyle(fontSize: 11, color: AppColors.grey500)),
                        ]),
                      ),
                      Row(children: [
                        _SmallBtn(Icons.phone_rounded, AppColors.emerald, () {}),
                        const SizedBox(width: 8),
                        _SmallBtn(Icons.chat_bubble_rounded, AppColors.sky, () {}),
                        const SizedBox(width: 8),
                        _StatusChip(w.jobsCompleted > 20 ? 'Active' : 'Pending'),
                      ]),
                    ],
                  ),
                )),
                // Summary footer
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.people_rounded, size: 14, color: AppColors.grey500),
                      const SizedBox(width: 6),
                      Text('${(job.workersBooked + 1).clamp(0, job.workersNeeded)} of ${job.workersNeeded} confirmed',
                          style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
                      const Spacer(),
                      Text('₹${(job.wagePerHour * _parseDuration(job.duration) * (job.workersBooked + 1).clamp(0, job.workersNeeded)).toInt()} total payout',
                          style: const TextStyle(fontSize: 12, color: AppColors.saffron, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  double _parseDuration(String d) {
    final m = RegExp(r'(\d+(\.\d+)?)').firstMatch(d);
    return m != null ? double.tryParse(m.group(1)!) ?? 4.0 : 4.0;
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallBtn(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 15),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  const _StatusChip(this.label);

  @override
  Widget build(BuildContext context) {
    final isActive = label == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.emerald : AppColors.golden).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: isActive ? AppColors.emerald : AppColors.golden)),
    );
  }
}
