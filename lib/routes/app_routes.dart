import 'package:flutter/material.dart';

import '../screens/add_order_screen.dart';
import '../screens/home_screen.dart';
import '../screens/order_details_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String orders = '/orders';
  static const String addOrder = '/add-order';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case orders:
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
        );

      case addOrder:
        return MaterialPageRoute(
          builder: (_) => const AddOrderScreen(),
        );

      case orderDetails:
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}