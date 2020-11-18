import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';

import 'package:Bankin/widgets/nav_bar.dart';
import 'package:Bankin/pages/login/login.dart';
import 'package:Bankin/pages/profile/profile_edit.dart';
import 'package:Bankin/pages/profile/widgets/image_capture.dart';
import 'package:Bankin/pages/login/widgets/confirming_user.dart';

class RouteManager {
  showLogin(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ));
  }

  showNavBar(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(),
        ));
  }

  showProfileEdit(context, attributes) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEdit(attributes),
        ));
  }

  showImageEditor(context, {CropStyle cropStyle, callback, String path}) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ImageCapture(cropStyle: cropStyle, path: path)));
  }

  showConfirmingUser(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmingUser(),
        ));
  }
}
