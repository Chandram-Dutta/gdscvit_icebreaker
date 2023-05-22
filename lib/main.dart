import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gdscvit_icebreaker/authentication/presentation/pages/landing_page.dart';
import 'package:gdscvit_icebreaker/home/presentation/pages/signedin_landing_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.blueWhale,
        useMaterial3: true,
        fontFamily: 'Rubik',
        lightIsWhite: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blueWhale,
        useMaterial3: true,
        fontFamily: 'Rubik',
        darkIsTrueBlack: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LandingPage()
          : const SignedInLandingPage(),
    );
  }
}

Route createRoute({
  required Widget page,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.ease),
      );
      final opacityAnimation = animation.drive(tween);
      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
  );
}
