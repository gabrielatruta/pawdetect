import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.lightGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.orange, width: 1.6),
        ),
      );

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // TODO: FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text.trim());
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('If that email exists, a reset link was sent.')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        centerTitle: true,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(headerRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        leading: const BackButton(color: AppColors.white),
        title: const Text(
          'Reset Password',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            final gapS = (w * 0.02).clamp(8, 16).toDouble();
            final gapM = (w * 0.04).clamp(14, 24).toDouble();
            final maxWidth = w.clamp(320, 520).toDouble();
            final imageSize = (w * 0.28).clamp(110, 160).toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: gapM,
                bottom: MediaQuery.of(context).viewInsets.bottom + gapS,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - 24),
                child: Center(
                  child: SizedBox(
                    width: maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Small illustration (same as other screens)
                        Center(
                          child: Image.asset(
                            'web/icons/ForgotPassword.jpg',
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: gapM),

                        const Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: gapS),
                        const Text(
                          'Please enter your email address to reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: gapM),

                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: _decoration('Email'),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'Please enter your email';
                              final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                              return ok ? null : 'Enter a valid email';
                            },
                            onFieldSubmitted: (_) => _sendReset(),
                          ),
                        ),
                        SizedBox(height: gapM),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _sendReset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              foregroundColor: AppColors.white,
                              minimumSize: const Size.fromHeight(48),
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(AppColors.white),
                                    ),
                                  )
                                : const Text('Reset password'),
                          ),
                        ),
                        SizedBox(height: gapS),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
