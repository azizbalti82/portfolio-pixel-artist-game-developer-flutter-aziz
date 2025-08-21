import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/provider.dart';
import 'package:portfolio/screens/appScreen.dart';
import 'package:portfolio/settingsService.dart';
import 'package:portfolio/theme/theme_data.dart';
import 'package:portfolio/tools/tools.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:web_splash/web_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Provider());
  await dotenv.load(fileName: "assets/.env");

  //update values
  bool isDark = await SettingsService.getIsDark();
  final Provider provider = Get.find<Provider>();
  provider.setIsDark(isDark);

  final supabaseUrl = dotenv.env['supabase_url'];
  final supabaseAnonKey = dotenv.env['supabase_anon_key'];

  try {
    await Supabase.initialize(
        url: supabaseUrl!,
        anonKey: supabaseAnonKey!
    );
  }catch(e){
    log("supabase .env keys are null i think: $e");
  }

  runApp(ToastificationWrapper( child: Main()));
}


// main screen -----------------------------------------------------------------
class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}
class _MainState extends State<Main>{
  final Provider provider = Get.find<Provider>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      theme t = getTheme(provider);
    return MaterialApp(
      title: 'Aziz | Pixel art & game developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: t.bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: t.accentColor,
          brightness: t.brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
          background: t.bgColor,
          surface: t.bgColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: t.bgColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          enableFeedback: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: t.bgColor,
        ),

        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: t.accentColor,
          selectionColor: t.accentColor.withOpacity(0.5),
          selectionHandleColor: t.accentColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: AppScreen(t: t,),
    );});
  }
}

class SystemUiStyleWrapper extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? navBarColor;
  final theme t;

  const SystemUiStyleWrapper({
    super.key,
    required this.child,
    this.statusBarColor,
    this.navBarColor, required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? t.bgColor,
        statusBarIconBrightness: t.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: navBarColor ?? t.bgColor,
        systemNavigationBarIconBrightness: t.brightness,
      ),
      child: child,
    );
  }
}
