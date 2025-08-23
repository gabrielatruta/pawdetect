import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/signup_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/shared/app_logo.dart';
import 'package:pawdetect/views/shared/appname_title.dart';
import 'package:provider/provider.dart';
import 'widgets/signup_form.dart';
import '../../../styles/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  
  @override
  State<SignUpScreen> createState() => __SignUpScreenState();

}

class __SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupViewModel>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Sign Up"),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AppLogo(),
            SizedBox(height: 20),
            AppnNameTitle(),
            SizedBox(height: 20),
            Text(
              "Create your account to access all functionalities.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}
