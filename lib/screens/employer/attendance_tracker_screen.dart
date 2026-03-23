import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/mock_data_service.dart';

class AttendanceTrackerScreen extends StatefulWidget {
  final bool standalone;
  const AttendanceTrackerScreen({super.key, this.standalone = true});

  @override
  State<AttendanceTrackerScreen> createState() => _AttendanceTrackerScreenState();
}

class _AttendanceTrackerScreenState extends State<AttendanceTrackerScreen> {
  // workerId -> status: 'absent' | 'checked_in' | 'checked_out'
  final Map<String, String> _status = {};
  final Map<String, DateTime?> _checkInTime = {};
  final Map<String, DateTime?> _checkOutTime = {};

  @override
  void initState() {
    super.initState();
    for (final w in MockDataService.allWorkers) {
      _status[w.id] = 'absent';
    }
  }

  void _toggle(String workerId) {
    setState(() {
      final s = _status[workerId]!;
      if (s == 'absent') {
        _status[workerId] = 'checked_in';
        _checkInTime[workerId] = DateTime.now();
      } else if (s == 'checked_in') {
        _status[workerId] = 'checked_out';
        _checkOutTime[workerId] = DateTime.now();
      } else {
        _status[workerId] = 'absent';
        _checkInTime[workerId] = null;
        _checkOutTime[workerId] = null;
      }
    });
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final workers = MockDataService.allWorkers;
    final checkedIn = workers.where((w) => _status[w.id] == 'checked_in').length;
    final checkedOut = workers.where((w) => _status[w.id] == 'checked_out').length;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: widget.standalone
          ? AppBar(title: const Text('Attendance Tracker'), backgroundColor: AppColors.white)
          : PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                color: AppColors.white,
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Text('Attendance Tracker', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  ),
                ),
              ),
            ),
      body: Column(
        children: [
          // Summary strip
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                _SummaryChip('${workers.length}', 'Total', AppColors.navy),
                const SizedBox(width: 12),
                _SummaryChip('$checkedIn', 'Present', AppColors.emerald),
                const SizedBox(width: 12),
                _SummaryChip('$checkedOut', 'Done', AppColors.sky),
                const SizedBox(width: 12),
                _SummaryChip('${workers.length - checkedIn - checkedOut}', 'Absent', AppColors.grey300),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.grey100),

          // Date & Job chip
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.grey500),
                const SizedBox(width: 6),
                const Text('17 Mar 2026 – Today', style: TextStyle(fontSize: 13, color: AppColors.grey700, fontWeight: FontWeight.w500)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.saffron.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Coffee Shop Assistant', style: TextStyle(fontSize: 12, color: AppColors.saffron, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // Worker list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: workers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final w = workers[i];
                final s = _status[w.id]!;
                final inTime = _checkInTime[w.id];
                final outTime = _checkOutTime[w.id];

                Color statusColor;
                IconData statusIcon;
                String statusLabel;
                switch (s) {
                  case 'checked_in':
                    statusColor = AppColors.emerald;
                    statusIcon = Icons.login_rounded;
                    statusLabel = 'Present';
                    break;
                  case 'checked_out':
                    statusColor = AppColors.sky;
                    statusIcon = Icons.logout_rounded;
                    statusLabel = 'Completed';
                    break;
                  default:
                    statusColor = AppColors.grey300;
                    statusIcon = Icons.radio_button_unchecked_rounded;
                    statusLabel = 'Absent';
                }

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.25)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: statusColor.withOpacity(0.15),
                        radius: 22,
                        child: Text(w.initials, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: statusColor)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(w.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                            Row(
                              children: [
                                if (inTime != null)
                                  Text('In: ${_fmt(inTime)}', style: const TextStyle(fontSize: 11, color: AppColors.emerald)),
                                if (outTime != null) ...[
                                  const Text(' → ', style: TextStyle(fontSize: 11, color: AppColors.grey300)),
                                  Text('Out: ${_fmt(outTime)}', style: const TextStyle(fontSize: 11, color: AppColors.sky)),
                                ] else if (inTime == null)
                                  Text(
                                    '⭐ ${w.rating} • ${w.jobsCompleted} jobs done',
                                    style: const TextStyle(fontSize: 11, color: AppColors.grey500),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 20),
                          const SizedBox(height: 2),
                          Text(statusLabel, style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Toggle button
                      GestureDetector(
                        onTap: () => _toggle(w.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 56,
                          height: 30,
                          decoration: BoxDecoration(
                            color: s == 'absent' ? AppColors.grey100 : statusColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 200),
                                alignment: s == 'absent' ? Alignment.centerLeft : Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  width: 24, height: 24,
                                  decoration: BoxDecoration(
                                    color: s == 'absent' ? AppColors.grey300 : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String count, label;
  final Color color;
  const _SummaryChip(this.count, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }
}
