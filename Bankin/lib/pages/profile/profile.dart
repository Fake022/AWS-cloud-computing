import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'package:Bankin/models/user.dart';
import 'package:Bankin/utils/route_manager.dart';

class Profile extends StatefulWidget {
  Profile();
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final http.Client _client = http.Client();
  Map<String, String> _headers;
  Map<String, String> _attributes = {
    'name': '',
    'email': '',
    'picture': '',
  };

  @override
  void initState() {
    super.initState();
    var user = Provider.of<User>(context, listen: false);
    _headers = {
      'Authorization': user.token,
    };
    getAttributes();
    getPicture();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> getPicture() async {
    Map<String, String> tmp = _attributes;

    try {
      final response =
          await _client.get(DotEnv().env['URL_PICTURE'], headers: _headers);
      final jsonResponse = json.decode(response.body);
      tmp['picture'] = jsonResponse['url'];
      setState(() {
        _attributes = tmp;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAttributes() async {
    var user = Provider.of<User>(context, listen: false);

    List<CognitoUserAttribute> attributes;
    Map<String, String> tmp = _attributes;
    try {
      attributes = await user.cognitoUser.getUserAttributes();
      attributes.forEach((attribute) {
        if (attribute.getName() != 'picture' &&
            tmp.containsKey(attribute.getName())) {
          tmp[attribute.getName()] = attribute.getValue();
        }
      });
      setState(() {
        _attributes = tmp;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _profileInfos() {
    return ListView(
      children: [
        _attributes['picture'] == '' || _attributes == null
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage:
                      NetworkImage("https://via.placeholder.com/150"),
                  backgroundColor: Colors.transparent,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(_attributes['picture']),
                  backgroundColor: Colors.transparent,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Text(_attributes['name'],
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0)),
          ),
        ),
        ButtonTheme(
          minWidth: double.infinity,
          height: 40.0,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 150.0, bottom: 50.0, left: 20.0, right: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                Provider.of<RouteManager>(context, listen: false)
                    .showProfileEdit(context, _attributes);
              },
              color: Colors.orange,
              textColor: Colors.white,
              child: Text('EDIT', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getAttributes();

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            backgroundColor: Colors.orange,
            title:
                Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: _profileInfos(),
        ),
      ],
    );
  }
}
