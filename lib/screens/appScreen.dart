// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:portfolio/screens/sections/Sections/contact.dart';
import 'package:portfolio/screens/sections/Sections/home.dart';
import 'package:portfolio/screens/sections/Sections/portfolio.dart';
import 'package:portfolio/screens/sections/Sections/projects.dart';
import 'package:portfolio/widgets/messages.dart';

import '../main.dart';
import '../provider.dart';
import '../settingsService.dart';
import '../theme/theme_data.dart';
import '../tools/tools.dart';
import '../widgets/form.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.t});
  final theme t;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late int _currentIndex;
  late List<Widget> _screens;
  late String selectedSection;
  final Provider provider = Get.find<Provider>();
  late theme t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
    _screens = [HomeScreen(t:t), PortfolioScreen(t:t), ProjectsScreen(), ContactScreen(t:t)];
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("is the new theme light ? ${t.brightness == Brightness.light}");

    return Obx(() {
      _currentIndex = provider.currentIndex.value;
      t = getTheme(provider);

      return SystemUiStyleWrapper(
        t: t,
        child: Scaffold(
          body: Stack(
            children: [
              // Glass gradient background
              if(t.brightness==Brightness.light)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.15),
                      Colors.pink.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // glass effect
                  child: Container(
                    color: Colors.white.withOpacity(0.05), // subtle glass overlay
                  ),
                ),
              ),

              // Actual Scaffold content
              SafeArea(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _screens.map((screen) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: isLandscape(context)
                            ? (_currentIndex == 1)
                            ? MediaQuery.of(context).size.width * 0.95
                            : MediaQuery.of(context).size.width * 0.7
                            : MediaQuery.of(context).size.width * 0.95,
                        height: isLandscape(context)
                            ? MediaQuery.of(context).size.height - 80
                            : MediaQuery.of(context).size.height - 60,
                        child: screen,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // AppBar
          appBar: isLandscape(context)
              ? AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 80,
            title: Row(
              children: [
                const SizedBox(width: 5),
                SvgPicture.asset(
                  "assets/logo/logo.svg",
                  width: 40,
                ),
                const Spacer(),
                navBarItem('Home', 0, t),
                const SizedBox(width: 8),
                navBarItem('Portfolio', 1, t),
                const SizedBox(width: 8),
                navBarItem('Projects', 2, t),
                const SizedBox(width: 8),
                navBarItem('Contact', 3, t),
                const SizedBox(width: 30),
                CustomButtonOutline(
                  t: t,
                  height: 40,
                  borderSize: 2,
                  icon: "launch",
                  text: "My Game Studio",
                  onPressed: () {
                    showMsg("This feature is not ready yet.", context, t);
                  },
                  isLoading: false,
                  isFullRow: false,
                ),
                const SizedBox(width: 4),
                CustomButtonOutline(
                  t: t,
                  height: 40,
                  borderSize: 2,
                  icon: provider.isDark.value ? "sun" : "moon",
                  onPressed: () async {
                    await SettingsService.saveIsDark(!provider.isDark.value);
                    provider.setIsDark(!provider.isDark.value);
                  },
                  isLoading: false,
                  isFullRow: false,
                ),
              ],
            ),
          )
              : null,

          // Bottom Navigation
          bottomNavigationBar: isLandscape(context)
              ? null
              : SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavItem(
                  iconPath: "assets/icons/home.svg",
                  label: "Home",
                  isActive: _currentIndex == 0,
                  size: 20,
                  onTap: () => provider.setCurrentIndex(0),
                  t: t,
                ),
                BottomNavItem(
                  iconPath: "assets/icons/portfolio.svg",
                  label: "Portfolio",
                  isActive: _currentIndex == 1,
                  size: 20,
                  onTap: () => provider.setCurrentIndex(1),
                  t: t,
                ),
                BottomNavItem(
                  iconPath: "assets/icons/project.svg",
                  label: "Projects",
                  isActive: _currentIndex == 2,
                  size: 23,
                  onTap: () => provider.setCurrentIndex(2),
                  t: t,
                ),
                BottomNavItem(
                  iconPath: "assets/icons/contact.svg",
                  label: "Contact",
                  isActive: _currentIndex == 3,
                  size: 20,
                  onTap: () => provider.setCurrentIndex(3),
                  t: t,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget navBarItem(String s, int i, theme t) {
    return GestureDetector(
      onTap: () {
        provider.setCurrentIndex(i);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: _currentIndex == i
            ? BoxDecoration(
          color: t.accentColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(20),
        )
            : null,
        child: Text(
          s,
          style: TextStyle(
            color: _currentIndex == i ? t.accentColor : t.secondaryTextColor,
            fontSize: 20,
            fontWeight: _currentIndex == i ? FontWeight.w600 : FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double size;
  final theme t;

  const BottomNavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.size,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: size,
                height: size,
                color: isActive ? t.accentColor : t.border,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? t.accentColor : t.border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
