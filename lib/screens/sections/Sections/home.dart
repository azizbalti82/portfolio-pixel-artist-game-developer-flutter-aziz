import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:portfolio/tools/tools.dart';
import 'package:portfolio/widgets/form.dart';

import '../../../provider.dart';
import '../../../settingsService.dart';
import '../../../theme/theme_data.dart';
import '../../../widgets/complex.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.t});
  final theme t;


  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  final Provider provider = Get.find<Provider>();
  late theme t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 50),
      child: isLandscape(context)?
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child:
          about(t)),
          SizedBox(width: 50,),
          profilePicPixel(screenWidth*0.7*0.3)
        ],
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          profilePicPixel(screenHeight*0.3),
          SizedBox(height: 50,),
          about(t)
        ],
      ),
    ));
  }

  Widget profilePicPixel(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(size),
        bottomRight: Radius.circular(size),
      ),
      child: SvgPicture.asset(
        "assets/images/profilePixel.svg",
        width: size,
      ),
    );
  }


  Widget about(theme t) {
    return  Obx(() {
      t = getTheme(provider);
      return Column(
      crossAxisAlignment: isLandscape(context)? CrossAxisAlignment.start:CrossAxisAlignment.center,
      children: [
        TypingText(text: 'Welcome to my portfolio',t: t,),

        const SizedBox(height: 12),
        AutoSizeText(
          "Hey, I'm Aziz an indie game developer passionate about pixel art. "
              "I love crafting creative experiences, and I’d be excited to work together!",
          style: TextStyle(
            fontSize: isLandscape(context)? 22:16,
            height: 1.5,
            color: t.textColor
          ),
          maxLines: 5,
          minFontSize: 12,
          overflow: TextOverflow.visible,
          textAlign: isLandscape(context)?TextAlign.start:TextAlign.center,

        ),
        const SizedBox(height: 20),
        FittedBox(
          child: Row(
            children: [
              CustomButton(
                text: "Let's work together",
                onPressed: () {
                  provider.setCurrentIndex(3);
                },
                isLoading: false,
                isFullRow: false,
                icon: "contact",
                iconSize: 17,
                t: t,
              ),
              const SizedBox(width: 4),
     if(!isLandscape(context))
    CustomButtonOutline(
                t: t,
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
          ) ,
        )
      ],
    );});
  }


}
