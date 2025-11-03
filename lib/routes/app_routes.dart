import 'package:flutter/material.dart';
import '../views/auth/login_view.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => HomeView(),
    '/login': (context) => LoginView(),
    '/home': (context) => HomeView(),


  };
}
