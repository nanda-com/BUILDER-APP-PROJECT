import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/trust_score_badge.dart';

class WorkerEarningsScreen extends StatelessWidget {
  final bool standalone;
  const WorkerEarningsScreen({super.key, this.standalone = true});

  @override
  Widget build(BuildContext context) {
    final completed = MockDataService.myBookings.where((b) => b.status == 'completed').toList();
    final totalEarned = completed.fold<double>(0, (sum, b) => sum + (b.earnedAmount ?? 0));
    const weekly = MockDataService.weeklyEarnings;
    const days = MockDataService.weekDays;

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.navy,
            automaticallyImplyLeading: standalone,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.navy, Color(0xFF1A2F5E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'My Wallet 💰',
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShaderMask(
                              shaderCallback: (b) => AppColors.saffronGrad.createShader(b),
                              child: Text(
                                '₹${(3450 + totalEarned).toInt()}',
                                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.emerald.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.emerald.withOpacity(0.3)),
                                ),
                                child: const Text('Available', style: TextStyle(color: AppColors.emerald, fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                  // Stat row
                  Row(
                    children: [
                      Expanded(child: StatCard(
                        label: 'This Week',
                        value: '₹${weekly.fold(0.0, (a, b) => a + b).toInt()}',
                        icon: Icons.trending_up_rounded,
                        color: AppColors.saffron,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(
                        label: 'Jobs Done',
                        value: '${completed.length}',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.emerald,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(
                        label: 'Avg/Job',
                        value: completed.isEmpty ? '₹0' : '₹${(totalEarned / completed.length).toInt()}',
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.sky,
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Withdraw button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.saffronGrad,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: AppColors.saffron.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _showWithdraw(context),
                        icon: const Icon(Icons.account_balance_rounded, size: 18),
                        label: const Text('Withdraw to Bank / UPI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weekly chart
                  const Text('Weekly Earnings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
                    ),
                    child: BarChart(
                      BarChartData(
                        maxY: 1200,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) => Text(
                                days[val.toInt()],
                                style: const TextStyle(fontSize: 11, color: AppColors.grey500),
                              ),
                            ),
                          ),
                        ),
                        barGroups: List.generate(7, (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: weekly[i],
                              width: 22,
                              borderRadius: BorderRadius.circular(6),
                              gradient: weekly[i] > 0
                                  ? const LinearGradient(colors: [AppColors.saffron, AppColors.saffronDark], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                                  : null,
                              color: weekly[i] == 0 ? AppColors.grey100 : null,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Transaction history
                  const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark)),
                  const SizedBox(height: 12),
                  ...completed.map((b) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_downward_rounded, color: AppColors.emerald, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.jobTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark)),
                              Text(b.date, style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('+ ₹${b.earnedAmount!.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.emerald)),
                            const Text('Same day pay', style: TextStyle(fontSize: 10, color: AppColors.grey500)),
                          ],
                        ),
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
    );
  }

  void _showWithdraw(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('Withdraw Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.dark)),
            const SizedBox(height: 20),
            const _WithdrawOption(Icons.account_balance_rounded, 'Bank Transfer', '1–2 hours', AppColors.navy),
            const SizedBox(height: 12),
            const _WithdrawOption(Icons.qr_code_rounded, 'UPI / GPay / PhonePe', 'Instant', AppColors.saffron),
            const SizedBox(height: 12),
            const _WithdrawOption(Icons.phone_android_rounded, 'Paytm Wallet', 'Instant', AppColors.sky),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WithdrawOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  const _WithdrawOption(this.icon, this.title, this.subtitle, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.dark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.grey500)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.grey300),
        ],
      ),
    );
  }
}
