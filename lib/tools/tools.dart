import 'package:flutter/material.dart';

import '../provider.dart';
import '../theme/theme_data.dart';

void navigateTo(BuildContext context, Widget destination, isReplace) {
  PageRouteBuilder p = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      var tween = Tween<Offset>(
        begin: const Offset(0.0, 0.1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
  if (isReplace) {
    Navigator.pushReplacement(context, p);
  } else {
    Navigator.push(context, p);
  }
}

navigate(BuildContext c, Widget screen, {bool? isReplace}) {
  //remove focus on all selected inputs
  FocusManager.instance.primaryFocus?.unfocus();
  if (isReplace != null && isReplace) {
    Navigator.pushReplacement(
      c,
      MaterialPageRoute(builder: (context) => screen),
    );
  } else {
    Navigator.push(c, MaterialPageRoute(builder: (context) => screen));
  }
}

theme getTheme(Provider provider) {
  return provider.isDark.value ? darkTheme:lightTheme;
}

DateTime getCurrentDate() {
  return DateTime.now();
}


bool isLandscape(BuildContext context) {
  final bool landscapeMode = MediaQuery.of(context).orientation == Orientation.landscape;
  final double width = MediaQuery.of(context).size.width;
  return landscapeMode && width>800;
}