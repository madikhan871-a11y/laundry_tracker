import 'package:flutter/material.dart';

import 'constants/app_constants.dart';
import 'routes/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const FreshFoldApp());
}

class FreshFoldApp extends StatelessWidget {
  const FreshFoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}