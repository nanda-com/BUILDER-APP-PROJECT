import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'otp_login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_selectedRole == null) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, a, __) => OtpLoginScreen(role: _selectedRole!),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navy, Color(0xFF1A2F5E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(), // Match native feel
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Header
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.saffronGrad.createShader(bounds),
                    child: const Text(
                      'I am a...',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your role to get started',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Role Cards
                  _RoleCard(
                    emoji: '🧑‍💼',
                    title: 'Student / Worker',
                    subtitle: 'Find part-time jobs nearby\nGet paid the same day',
                    role: 'worker',
                    accentColor: AppColors.saffron,
                    isSelected: _selectedRole == 'worker',
                    onTap: () => setState(() => _selectedRole = 'worker'),
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    emoji: '🏢',
                    title: 'Employer',
                    subtitle: 'Post jobs & hire instantly\nManage your workforce',
                    role: 'employer',
                    accentColor: AppColors.emerald,
                    isSelected: _selectedRole == 'employer',
                    onTap: () => setState(() => _selectedRole = 'employer'),
                  ),
                  const Spacer(),

                  // Feature badges
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _badge('🔒', 'OTP Verified'),
                      _badge('⚡', 'Instant Jobs'),
                      _badge('💰', 'Same-Day Pay'),
                      _badge('⭐', 'Trusted Platform'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: _selectedRole != null ? 1.0 : 0.4,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.saffronGrad,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: _selectedRole != null
                              ? [BoxShadow(color: AppColors.saffron.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: _selectedRole != null ? _proceed : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: const Text(
                            'Continue with OTP Login',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String role;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;
  const _RoleCard({
    required this.emoji, required this.title, required this.subtitle,
    required this.role, required this.accentColor, required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.12) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white.withOpacity(0.12),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: accentColor.withOpacity(0.25), blurRadius: 20, spreadRadius: 2)]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: isSelected ? accentColor.withOpacity(0.2) : Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? accentColor : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accentColor : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
