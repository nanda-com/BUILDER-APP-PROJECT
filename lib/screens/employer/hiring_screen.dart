import 'package:flutter/material.dart';
import '../../app_theme.dart';

class HiringScreen extends StatelessWidget {
  const HiringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Hiring Pipeline', style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Color(0xFF0097A7),
            unselectedLabelColor: AppColors.grey500,
            indicatorColor: Color(0xFF0097A7),
            tabs: [
              Tab(text: 'Applicants (12)'),
              Tab(text: 'Shortlisted (4)'),
              Tab(text: 'Hired (2)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ApplicantList(),
            _ApplicantList(isShortlisted: true),
            Center(child: Text('No recently hired workers.', style: TextStyle(color: AppColors.grey500))),
          ],
        ),
      ),
    );
  }
}

class _ApplicantList extends StatelessWidget {
  final bool isShortlisted;
  const _ApplicantList({this.isShortlisted = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: isShortlisted ? 4 : 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.grey100, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.royalBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('W${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.royalBlue))),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rahul Sharma', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        SizedBox(height: 4),
                        Text('Applied for: Warehouse Helper', style: TextStyle(fontSize: 12, color: AppColors.grey500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.star_rounded, color: AppColors.emerald, size: 14),
                        SizedBox(width: 4),
                        Text('91 Trust', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.emerald)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.grey500,
                        side: BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0097A7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(isShortlisted ? 'Hire Now' : 'Shortlist', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
