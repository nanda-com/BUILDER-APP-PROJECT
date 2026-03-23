import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/job_card.dart';
import 'job_detail_screen.dart';

class ExploreGigsScreen extends StatefulWidget {
  const ExploreGigsScreen({super.key});

  @override
  State<ExploreGigsScreen> createState() => _ExploreGigsScreenState();
}

class _ExploreGigsScreenState extends State<ExploreGigsScreen> {
  // Simple state to force rebuild if data changes
  @override
  Widget build(BuildContext context) {
    final jobs = MockDataService.allJobs.where((j) => j.isOpen).toList();

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text('Available Gigs', style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: jobs.isEmpty
          ? const Center(child: Text('No gigs available right now.', style: TextStyle(color: AppColors.grey500)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return JobCard(
                  job: job,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailScreen(job: job),
                      ),
                    ).then((_) => setState(() {})); // Rebuild on return in case of booking
                  },
                );
              },
            ),
    );
  }
}
