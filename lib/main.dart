import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qjumpa/injection.dart' as di;
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/routes.dart';
import 'package:qjumpa/src/presentation/splash_screen/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  // await loadEnv();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Qjumpa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        primarySwatch: Colors.blue,
      ),
      routes: routes,
      home: FutureBuilder(
        future: sl.allReady(),
        // a future that checks if getIt has initialised all its future variables
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return const SplashScreeen();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
