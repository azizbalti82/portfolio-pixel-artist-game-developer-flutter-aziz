import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portfolio/tools/tools.dart';

import '../../../theme/theme_data.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _State();
}

class _State extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        SvgPicture.asset(
              "assets/images/empty.svg",
          height: isLandscape(context)? constraints.maxHeight*0.7:null,
          width: isLandscape(context)? null: constraints.maxWidth*0.9,
            ),
          ],
        );
      },
    );
  }

}
