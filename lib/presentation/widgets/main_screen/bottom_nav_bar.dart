import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBarRaisedInset extends StatefulWidget {
  BottomNavBarRaisedInset({
    Key? key,
    required this.onItemTapped,
    required this.buildIcon,
    this.currentIndex,
  }) : super(key: key);
  Function onItemTapped;
  Function buildIcon;
  int? currentIndex;

  @override
  _BottomNavBarRaisedInsetState createState() =>
      _BottomNavBarRaisedInsetState();
}

class _BottomNavBarRaisedInsetState extends State<BottomNavBarRaisedInset> {
  //- - - - - - - - - instructions - - - - - - - - - - - - - - - - - -
  // WARNING! MUST ADD extendBody: true; TO CONTAINING SCAFFOLD
  //
  // Instructions:
  //
  // add this widget to the bottomNavigationBar property of a Scaffold, along with
  // setting the extendBody parameter to true i.e:
  //
  // Scaffold(
  //  extendBody: true,
  //  bottomNavigationBar: BottomNavBarRaisedInset()
  // )
  //
  // Properties such as color and height can be set by changing the properties at the top of the build method
  //
  // For help implementing this in a real app, watch https://www.youtube.com/watch?v=C0_3w0kd0nc. The style is different, but connecting it to navigation is the same.
  //
  //- - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 65;

    final primaryColor = Colors.black;
    final secondaryColor = Colors.black;
    final backgroundColor = Colors.white;

    final shadowColor = Colors.grey; //color of Navbar shadow
    double elevation = 100; //Elevation of the bottom Navbar

    return BottomAppBar(
      color: Colors.white,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height),
            painter: BottomNavCurvePainter(
                backgroundColor: backgroundColor,
                shadowColor: shadowColor,
                elevation: 0),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              child: widget.buildIcon(
                FaIcon(
                  FontAwesomeIcons.plus,
                ).icon,
                2,
              ),
              elevation: 0.1,
              onPressed: () {
                widget.onItemTapped(2);
              },
              shape: CircleBorder(),
            ),
          ),
          Container(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarIcon(
                  text: 'Home',
                  icon: widget.buildIcon(
                    FontAwesomeIcons.house,
                    0,
                  ),
                  selected: widget.currentIndex == 0,
                  onPressed: () {
                    widget.onItemTapped(0);
                  },
                  defaultColor: secondaryColor,
                  selectedColor: primaryColor,
                ),
                NavBarIcon(
                  text: 'Messages',
                  icon: widget.buildIcon(
                    FontAwesomeIcons.solidCommentDots,
                    1,
                  ),
                  selected: widget.currentIndex == 1,
                  onPressed: () {
                    widget.onItemTapped(1);
                  },
                  defaultColor: secondaryColor,
                  selectedColor: primaryColor,
                ),
                SizedBox(width: 56),
                NavBarIcon(
                  text: 'Ads',
                  icon: widget.buildIcon(
                    FontAwesomeIcons.rectangleAd,
                    3,
                  ),
                  selected: widget.currentIndex == 3,
                  onPressed: () {
                    widget.onItemTapped(3);
                  },
                  defaultColor: secondaryColor,
                  selectedColor: primaryColor,
                ),
                NavBarIcon(
                  text: 'Account',
                  icon: widget.buildIcon(
                    FontAwesomeIcons.userGear,
                    4,
                  ),
                  selected: widget.currentIndex == 4,
                  onPressed: () {
                    widget.onItemTapped(4);
                  },
                  selectedColor: primaryColor,
                  defaultColor: secondaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter({
    this.backgroundColor = Colors.white,
    this.insetRadius = 38,
    this.shadowColor = Colors.grey,
    this.elevation = 100,
  });

  Color backgroundColor;
  Color shadowColor;
  double elevation;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;

    path.lineTo(insetCurveBeginnningX, 0);
    path.arcToPoint(
      Offset(insetCurveEndX, 0),
      radius: Radius.circular(41),
      clockwise: true,
    );

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height + 56);
    path.lineTo(
      0,
      size.height + 56,
    ); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawShadow(path, shadowColor, elevation, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.selectedColor = const Color(0xffFF8527),
    this.defaultColor = Colors.black54,
  }) : super(key: key);
  final String text;
  final Widget icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: icon,
        ),
        Text(
          text,
          style: TextStyle(
            color: selected ? selectedColor : defaultColor,
            fontSize: 12,
            height: 0.5,
          ),
        )
      ],
    );
  }
}
