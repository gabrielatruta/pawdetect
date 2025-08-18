import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();

  bool _obscurePwd = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _phone.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {Widget? suffix}) {
    return InputDecoration(
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
      suffixIcon: suffix,
    );
  }

  Future<void> _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // TODO: Firebase Auth createUserWithEmailAndPassword + save profile
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      // Navigator.pop(context); // or pushReplacement to your Home screen
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
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(headerRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        leading: const BackButton(color: AppColors.white),
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            final gapS = (w * 0.02).clamp(8, 16).toDouble();
            final gapM = (w * 0.04).clamp(14, 24).toDouble();
            final maxFormWidth = w.clamp(320, 520).toDouble();

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
                    width: maxFormWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            'web/icons/welcomeScreenPaw.png',
                            width: w * 0.30,
                            height: w * 0.30,
                            fit: BoxFit.contain,
                          ),
                        ),

                        //App name
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Paw',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28,
                                ),
                              ),
                              TextSpan(
                                text: 'Detect',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: gapS),

                        //Description for sign-up
                        const Text(
                          'Create your account to start reporting and finding pets.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),

                        SizedBox(height: gapM),

                        //Sign-up fields
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //Full Name
                              TextFormField(
                                controller: _name,
                                textInputAction: TextInputAction.next,
                                decoration: _decoration('Full name'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Please enter your name!'
                                        : null,
                              ),
                              SizedBox(height: gapS),

                              //Phone number
                              TextFormField(
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: _decoration('Phone number'),
                                inputFormatters: [
                                  // allow digits, +, spaces, dashes, parentheses
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9+\-\s\(\)]')),
                                ],
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) {
                                    return 'Please enter your phone number!';
                                  }
                                  final digits = value.replaceAll(
                                      RegExp(r'\D'), ''); // strip non-digits
                                  if (digits.length < 7 || digits.length > 15) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: gapS),

                              //Email
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: _decoration('Email'),
                                validator: (v) {
                                  final value = v?.trim() ?? '';
                                  if (value.isEmpty) {
                                    return 'Please enter your email!';
                                  }
                                  final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                      .hasMatch(value);
                                  return ok
                                      ? null
                                      : 'Email address is not valid!';
                                },
                              ),
                              SizedBox(height: gapS),

                              //Password
                              TextFormField(
                                controller: _password,
                                textInputAction: TextInputAction.next,
                                obscureText: _obscurePwd,
                                decoration: _decoration(
                                  'Password',
                                  suffix: IconButton(
                                    onPressed: () => setState(
                                        () => _obscurePwd = !_obscurePwd),
                                    icon: Icon(
                                      _obscurePwd
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'Min 6 characters'
                                    : null,
                              ),
                              SizedBox(height: gapS),

                              //Reenter password
                              TextFormField(
                                controller: _confirm,
                                textInputAction: TextInputAction.done,
                                obscureText: _obscureConfirm,
                                decoration: _decoration(
                                  'Confirm password',
                                  suffix: IconButton(
                                    onPressed: () => setState(() =>
                                        _obscureConfirm = !_obscureConfirm),
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v != _password.text)
                                        ? 'Passwords do not match'
                                        : null,
                                onFieldSubmitted: (_) => _onCreateAccount(),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: gapS),

                        // Create account (primary)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _onCreateAccount,
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.white),
                                    ),
                                  )
                                : const Text('Create Account'),
                          ),
                        ),

                        SizedBox(height: gapS),

                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context), // back to Login
                              child: const Text('Log In',
                                  style: TextStyle(color: AppColors.orange)),
                            ),
                          ],
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
