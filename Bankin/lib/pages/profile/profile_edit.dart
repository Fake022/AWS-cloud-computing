import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'package:Bankin/models/user.dart';

import 'widgets/avatar.dart';

class ProfileEdit extends StatefulWidget {
  final Map<String, String> attributes;

  ProfileEdit(this.attributes);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File _image;
  final http.Client _client = http.Client();
  Map<String, String> _headers;

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.attributes['name'];
      _emailController.text = widget.attributes['email'];
    });
  }

  @override
  void dispose() {
    _client.close();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> postPicture(String picture) async {
    var user = Provider.of<User>(context, listen: false);
    _headers = {
      'Content-Type': 'image/jpeg',
      'Content-Length': picture.length.toString(),
      'Authorization': user.token,
      'x-source': 'flutter'
    };
    var response = await _client.post(
      DotEnv().env['URL_PICTURE'],
      headers: _headers,
      body: picture,
    );
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  Future<void> _save() async {
    var user = Provider.of<User>(context, listen: false);

    final List<CognitoUserAttribute> attributes = [];
    attributes
        .add(CognitoUserAttribute(name: 'name', value: _nameController.text));
    if (_image != null) {
      List<int> imageBytes = _image.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      await postPicture(base64Image);
    }
    try {
      await user.cognitoUser.updateAttributes(attributes);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 30.0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Edit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      centerTitle: true,
    );
  }

  Widget buildTextFields() {
    print(_nameController);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                child: Avatar(_image, widget.attributes['picture']),
                onTap: () => _showPicker(context),
              ),
            ),
            buildTextFields(),
            ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () => _save(),
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('SAVE', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
