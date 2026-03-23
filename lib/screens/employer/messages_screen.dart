import 'package:flutter/material.dart';
import '../../app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square, color: Color(0xFF0097A7)),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search_rounded, color: AppColors.grey500),
                  hintText: 'Search conversations',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 4,
              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.grey100, indent: 80, endIndent: 20),
              itemBuilder: (context, index) {
                final names = ['Rahul Sharma', 'Priya Nair', 'Sneha Reddy', 'Aditya Kumar'];
                final messages = [
                  'Yes, I can start tomorrow at 9 AM.',
                  'Are there any specific tools I need to bring?',
                  'Thank you for the opportunity!',
                  'I have reached the location.'
                ];
                final times = ['10:42 AM', 'Yesterday', 'Monday', 'Mar 15'];
                final unread = [true, false, false, false];

                return _ChatTile(
                  name: names[index],
                  lastMsg: messages[index],
                  time: times[index],
                  isUnread: unread[index],
                  color: AppColors.categoryColors.values.toList()[index % AppColors.categoryColors.length],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final String name;
  final String lastMsg;
  final String time;
  final bool isUnread;
  final Color color;

  const _ChatTile({
    required this.name,
    required this.lastMsg,
    required this.time,
    required this.isUnread,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: AppColors.dark),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                            fontSize: 12,
                            color: isUnread ? const Color(0xFF0097A7) : AppColors.grey500,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: isUnread ? AppColors.dark : AppColors.grey500,
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400),
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0097A7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
