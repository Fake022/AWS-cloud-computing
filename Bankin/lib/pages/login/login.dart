import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'style/theme.dart' as Theme;

import 'widgets/menu_bar.dart';
import 'widgets/sign_in.dart';
import 'widgets/sign_up.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 140),
      child: SizedBox(
        width: 160.0,
        child: ColorizeAnimatedTextKit(
            text: ["Bankin"],
            textStyle: TextStyle(
                fontSize: 50.0, fontFamily: "Signatra", color: Colors.white),
            colors: [
              Colors.white,
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            alignment: AlignmentDirectional.center),
      ),
    );
  }

  buildPageView() {
    return Expanded(
      flex: 2,
      child: PageView(
        controller: _pageController,
        onPageChanged: (i) {
          if (i == 0) {
            setState(() {
              right = Colors.white;
              left = Colors.black;
            });
          } else if (i == 1) {
            setState(() {
              right = Colors.black;
              left = Colors.white;
            });
          }
        },
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: SignIn(),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: SignUp(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Theme.Colors.loginGradientStart,
                    Theme.Colors.loginGradientEnd
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildTitle(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: MenuBar(_pageController, right, left),
                ),
                buildPageView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
