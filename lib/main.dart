import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes/app_routes.dart';
import 'views/auth/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDH - Trámites de Grado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF0a9e9d),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(
          primary: Color(0xFF0a9e9d),
          secondary: Color(0xFFebcb79),
          surface: Colors.white,
          background: Color(0xFFF5F5F5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2f2e2e)),
        ),
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
