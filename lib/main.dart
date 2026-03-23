import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/auth/splash_screen.dart';

import 'services/mock_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockDataService.init();
  runApp(const IndianDreamsApp());
}

class IndianDreamsApp extends StatelessWidget {
  const IndianDreamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Dreams',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
