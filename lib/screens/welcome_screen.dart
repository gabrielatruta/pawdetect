import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../styles/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // scale spacing & image size with screen
            final gapS = w * 0.02; // small gap
            final gapM = w * 0.04; // medium gap
            final gapL = w * 0.08; // large gap
            final imageSize = w.clamp(220, 320); // keep within 220–320

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: gapL),

                      // 1) Name of the app: PawDetects
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Paw',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'Detect',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: gapM),

                      // 2) Image
                      Center(
                        child: Image.asset(
                          'web/icons/welcomeScreenPaw.png',
                          width: imageSize.toDouble(),
                          height: imageSize.toDouble(),
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: gapL),

                      // 3) Welcome text
                      const Text(
                        'Welcome to PawDetect!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),

                      SizedBox(height: gapS),

                      // 4) Short description
                      const Text(
                        'Your real-time investigator searching for your lost pet!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: gapM),

                      // 5) Log In button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text('Log In'),
                        ),
                      ),
                      SizedBox(height: gapS),

                      // 6) Sign Up button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: const StadiumBorder(),
                            side: const BorderSide(
                                color: AppColors.orange, width: 1.5),
                            foregroundColor: AppColors.orange,
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),

                      SizedBox(height: gapS),

                      // 7) Continue without an account
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: AppColors.grey),
                        child: const Text(
                          'Continue without an account',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),

                      SizedBox(
                          height: gapS + MediaQuery.of(context).padding.bottom),
                    ],
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
