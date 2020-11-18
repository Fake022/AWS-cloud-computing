import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:Bankin/pages/login/widgets/user_storage.dart';

import 'package:provider/provider.dart';
import 'package:Bankin/utils/route_manager.dart';

import '../style/theme.dart' as Theme;

class ConfirmingUser extends StatefulWidget {
  ConfirmingUser();

  @override
  _ConfirmingUser createState() => _ConfirmingUser();
}

class _ConfirmingUser extends State<ConfirmingUser> {
  TextEditingController confirmingCode = TextEditingController();
  final FocusNode myFocusConfirmingCode = FocusNode();
  final userPool =
      new CognitoUserPool('eu-west-2_kT5EeqP0M', '5loolat0v6rftppvpasmg89b5a');

  @override
  void dispose() {
    myFocusConfirmingCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 100.0
                ? MediaQuery.of(context).size.height
                : 100.0,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: SizedBox(
                    width: 160.0,
                    child: ColorizeAnimatedTextKit(
                        text: ["Bankin"],
                        textStyle: TextStyle(
                            fontSize: 50.0,
                            fontFamily: "Signatra",
                            color: Colors.white),
                        colors: [
                          Colors.white,
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ],
                        alignment: AlignmentDirectional.center),
                  ),
                ),
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 50.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            focusNode: myFocusConfirmingCode,
                            controller: confirmingCode,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                              hintText: "Confirmation Code",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.Colors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Theme.Colors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          "Send Code",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () async {
                        bool registrationConfirmed = false;
                        String username =
                            Provider.of<UserData>(context, listen: false)
                                .username;
                        print(username);
                        final cognitoUser = new CognitoUser(username, userPool);
                        try {
                          registrationConfirmed = await cognitoUser
                              .confirmRegistration(confirmingCode.text);
                        } catch (e) {
                          print("Error" + e.message);
                          return;
                        }
                        print(registrationConfirmed);
                        Provider.of<RouteManager>(context, listen: false)
                            .showNavBar(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
