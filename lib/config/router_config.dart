import 'package:flutter/material.dart';
import '../screens/account/categories_screen.dart';
import '../screens/account/feedback_screen.dart';
import '../screens/account/payables_screen.dart';
import '../screens/account/receivables_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/main/main_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const MainScreen(),
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
      '/categories': (context) => const CategoriesScreen(),
      '/payables': (context) => const PayablesScreen(),
      '/receivables': (context) => const ReceivablesScreen(),
      '/feedback': (context) => const FeedbackScreen(),
    };
  }
}