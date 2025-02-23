import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:vary_recycle/screen/home_screen.dart';
import 'package:vary_recycle/screen/login_screen.dart';
import 'package:vary_recycle/src/controllers/otp_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(OTPController());
  await Firebase.initializeApp(
    name: "vary-recycle",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();

    await storage.deleteAll();

    prefs.setBool('first_run', false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext _, AsyncSnapshot<User?> user) {
          return const LoginScreen();

          // if (user.hasData) {
          //   return const HomeScreen();
          // } else {
          //   return const LoginScreen();
          // }
        });
  }

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: SplashScreen.navigate(
        name: 'assets/RiveAssets/vary_recycle_f.riv',
        next: (context) => handleAuth(),
        until: () => Future.delayed(const Duration(seconds: 0)),
        startAnimation: 'WAVE ANIMATION',
        backgroundColor: Colors.white,
      ),
      transitionDuration: Duration(milliseconds: 500),
      home: LoginScreen(),

    );
  }
}
