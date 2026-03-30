import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';
import 'package:kiponnect/presentation/widgets/common/kiponnect_button.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _isLoading = false;
  int _timerSeconds = 60;
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());
    _timerController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );
    _startTimer();
  }

  void _startTimer() {
    _timerController.forward();
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _timerSeconds--;
        });
      }
      return _timerSeconds > 0;
    });
  }

  void _handleOtpInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    }
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to home
          Navigator.of(context).pushReplacementNamed('/home');
        }
      });
    }
  }

  void _resendOtp() {
    setState(() {
      _timerSeconds = 60;
    });
    _timerController.reset();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP resent to ${widget.email}'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
                SizedBox(height: 40),
                // Header
                Text(
                  'Verify OTP',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'Enter the 4-digit code sent to ${widget.email}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                SizedBox(height: 40),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => _OtpInputField(
                      focusNode: _focusNodes[index],
                      controller: _controllers[index],
                      onChanged: (value) => _handleOtpInput(value, index),
                      onBackspace: index > 0
                          ? () {
                              _focusNodes[index - 1].requestFocus();
                            }
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                // Verify Button
                KiponnectButton(
                  label: _isLoading ? 'Verifying...' : 'Verify',
                  isLoading: _isLoading,
                  onPressed: _verifyOtp,
                ),
                SizedBox(height: 24),
                // Resend OTP
                Center(
                  child: Column(
                    children: [
                      if (_timerSeconds > 0)
                        Text(
                          'Resend code in $_timerSeconds seconds',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        )
                      else
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            'Didn\'t receive code? Resend',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryOrange,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                    ],
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

class _OtpInputField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onBackspace;

  const _OtpInputField({
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.isEmpty && controller.text.isEmpty) {
            onBackspace?.call();
          }
          onChanged(value);
        },
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryOrange,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: AppColors.darkSurface,
        ),
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.primaryOrange,
            ),
      ),
    );
  }
}
