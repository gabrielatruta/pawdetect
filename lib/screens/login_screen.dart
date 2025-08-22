import 'package:flutter/material.dart';
import '/screens/forgot_password_screen.dart';
import 'signup_screen.dart';
import '../styles/app_colors.dart';
import '/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      try {
        await Firebase.initializeApp();
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _loading = false;
          if (e.code == 'user-not-found') {
            errorMessage = "No user with the provided email address.";
          } else if (e.code == 'wrong-password') {
            errorMessage = 'The password is invalid. Please try again.';
          } else if (e.code == 'invalid-credential') {
            errorMessage =
                'The email or password are invalid. Please check and try again.';
          } else {
            errorMessage =
                e.message ?? 'Something went wrong. Please try again.';
          }
        });
      } catch (e) {
        setState(() {
          _loading = false;
          errorMessage = 'Something went wrong. Please try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0; // <- tweak this to change the roundness

    return Scaffold(
      backgroundColor: AppColors.white,

      // Rounded orange header like your screenshot
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        centerTitle: true,
        toolbarHeight: 72,
        // The magic: round the bottom edge of the AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(headerRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias, // ensure the curve is actually clipped
        title: const Text(
          'Log In',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
        // Back arrow (uses foregroundColor for white icon)
        leading: const BackButton(color: AppColors.white),
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
                        // App logo
                        Center(
                          child: Image.asset(
                            'web/icons/welcomeScreenPaw.png',
                            width: w * 0.30,
                            height: w * 0.30,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // App name
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

                        //Login description
                        const Text(
                          'Welcome back! Please log in to continue.',
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
                          child: Column(
                            children: [
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
                                  final ok = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$',
                                  ).hasMatch(value);
                                  return ok
                                      ? null
                                      : 'Email address is not valid!';
                                },
                              ),
                              SizedBox(height: gapS),
                              TextFormField(
                                controller: _password,
                                textInputAction: TextInputAction.done,
                                obscureText: _obscure,
                                decoration: _decoration(
                                  'Password',
                                  suffix: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'Min 6 characters'
                                    : null,
                                // onFieldSubmitted: (_) => _onLogin(),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const ForgotPassword(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: gapS),

                        ///////////////////////////OLD BUTTON BY GARBEILA
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: _loading ? null : _onLogin,
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.orange,
                        //       foregroundColor: AppColors.white,
                        //       minimumSize: const Size.fromHeight(48),
                        //       shape: const StadiumBorder(),
                        //       elevation: 0,
                        //     ),
                        //     child: _loading
                        //         ? const SizedBox(
                        //             height: 20,
                        //             width: 20,
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 2.2,
                        //               valueColor: AlwaysStoppedAnimation<Color>(
                        //                   AppColors.white),
                        //             ),
                        //           )
                        //         : const Text('Log In'),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Center(
                            child: Text(
                              style: const TextStyle(color: Colors.red),
                              errorMessage,
                            ),
                          ),
                        ),
                        signInButton(context, _onLogin, _loading),
                        SizedBox(height: gapS),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: AppColors.orange),
                              ),
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

Widget signInButton(BuildContext context, Function onTap, bool isLoading) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: isLoading ? null : () => onTap(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Text(
              'Log In',
              // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
    ),
  );
}
