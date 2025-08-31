import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.pawDetectLogoPath,
      width: MediaQuery.of(context).size.width * 0.30,
      height: MediaQuery.of(context).size.width * 0.30,
      fit: BoxFit.contain,
    );
  }
}
