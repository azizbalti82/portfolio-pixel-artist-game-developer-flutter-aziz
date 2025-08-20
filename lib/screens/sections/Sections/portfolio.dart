import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

import '../../../backend/models/pixelArtPortfolioItem.dart';
import '../../../data/pixelArtPortfolioData.dart';
import '../../../theme/theme_data.dart';


class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key, required this.t});
  final theme t;

  @override
  State<PortfolioScreen> createState() => _State();
}

class _State extends State<PortfolioScreen> {
  late theme t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return pixelArtPortfolioItems.isEmpty? LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/empty.svg",
              height: constraints.maxHeight*0.7,
              fit: BoxFit.contain,
            ),
          ],
        );
      },
    ): getAllItems(t,context);
  }

  Widget getAllItems(theme t, BuildContext context) {
    final children = pixelArtPortfolioItems
        .map((item) => getItemCard(t, item))
        .toList();

    double screenWidth = MediaQuery.of(context).size.width;

    return MasonryGridView.count(
      crossAxisCount: getColumns(screenWidth),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
  int getColumns(double screenWidth) {
    /// second columns number filter :
    if(pixelArtPortfolioItems.length<=5){
      return 2;
    }else if(pixelArtPortfolioItems.length<=10 && screenWidth >= 1200){
      return 3;
    }
    if (screenWidth < 600) return 2;   // phones
    if (screenWidth < 1200) return 3;   // tablets
    if (screenWidth < 1900) return 4;  // small laptops
    return 5;                          // desktops / wide screens
  }




  Widget getItemCard(theme t, PixelArtPortfolioItem item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // card border radius
      ),
      clipBehavior: Clip.antiAlias, // ensures child respects radius
      child: Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }


}
