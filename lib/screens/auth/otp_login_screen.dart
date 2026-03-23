import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_theme.dart';
import '../worker/worker_home_screen.dart';
import '../employer/employer_dashboard_screen.dart';

class OtpLoginScreen extends StatefulWidget {
  final String role;
  const OtpLoginScreen({super.key, required this.role});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _phoneFocus = FocusNode();
  final List<TextEditingController> _otpCtrl = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());

  bool _otpSent = false;
  bool _loading = false;
  bool _verified = false;
  int _countdown = 30;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _phoneFocus.dispose();
    for (final c in _otpCtrl) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneCtrl.text.length < 10) return;
    _phoneFocus.unfocus();
    setState(() { _loading = true; });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() { _otpSent = true; _loading = false; });
      // Auto-fill OTP after 2 seconds (mock)
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        final mockOtp = ['1', '2', '3', '4', '5', '6'];
        for (int i = 0; i < 6; i++) {
          _otpCtrl[i].text = mockOtp[i];
        }
        setState(() {});
        _startCountdown();
      });
    });
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _countdown <= 0) return;
      setState(() => _countdown--);
      _startCountdown();
    });
  }

  void _verifyOtp() {
    final otp = _otpCtrl.map((c) => c.text).join();
    if (otp.length < 6) return;
    setState(() { _loading = true; });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() { _loading = false; _verified = true; });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => widget.role == 'worker'
                ? const WorkerHomeScreen()
                : const EmployerDashboardScreen(),
          ),
          (_) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Role badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (widget.role == 'worker' ? AppColors.saffron : AppColors.emerald).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (widget.role == 'worker' ? AppColors.saffron : AppColors.emerald).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    widget.role == 'worker' ? '🧑‍💼 Student / Worker' : '🏢 Employer',
                    style: TextStyle(
                      color: widget.role == 'worker' ? AppColors.saffron : AppColors.emerald,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Enter your\nMobile Number',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll send a 6-digit OTP to verify',
                  style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
                ),
                const SizedBox(height: 36),

                // Phone input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '🇮🇳 +91',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(width: 1, height: 24, color: Colors.white.withOpacity(0.2)),
                      Expanded(
                        child: TextField(
                          controller: _phoneCtrl,
                          focusNode: _phoneFocus,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          style: const TextStyle(color: Colors.white, fontSize: 17, letterSpacing: 1),
                          decoration: InputDecoration(
                            hintText: '98765 43210',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                            border: InputBorder.none,
                            filled: false,
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_otpSent) ...[
                  const SizedBox(height: 32),
                  Text(
                    _verified ? '✅  Verified!' : 'Enter OTP',
                    style: TextStyle(
                      color: _verified ? AppColors.emerald : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) => _OtpBox(
                      controller: _otpCtrl[i],
                      focusNode: _otpFocus[i],
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 5) {
                          FocusScope.of(context).requestFocus(_otpFocus[i + 1]);
                        }
                        setState(() {});
                      },
                    )),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        _countdown > 0 ? 'Resend in ${_countdown}s' : '',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                      ),
                      if (_countdown == 0) ...[
                        TextButton(
                          onPressed: _sendOtp,
                          child: const Text('Resend OTP', style: TextStyle(color: AppColors.saffron)),
                        ),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 36),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: AnimatedOpacity(
                    opacity: (_otpSent || _phoneCtrl.text.length == 10) ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.saffronGrad,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.saffron.withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _loading ? null : (_otpSent ? _verifyOtp : (_phoneCtrl.text.length == 10 ? _sendOtp : null)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                _otpSent ? 'Verify & Continue' : 'Send OTP',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text(
                    '🔒 Your number is safe with us.',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  const _OtpBox({required this.controller, required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.text.isNotEmpty
              ? AppColors.saffron
              : Colors.white.withOpacity(0.2),
          width: controller.text.isNotEmpty ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          filled: false,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}
