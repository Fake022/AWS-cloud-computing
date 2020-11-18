import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization_provider.dart';

import 'package:Bankin/utils/route_manager.dart';
import 'package:Bankin/pages/login/widgets/user_storage.dart';

import 'models/user.dart';
import 'pages/login/login.dart';

Future<void> main() async {
  await DotEnv().load('.env');
  Provider(create: (_) => new RouteManager());
  runApp(EasyLocalization(
    child: MultiProvider(providers: [
      Provider(create: (_) => new RouteManager()),
      ListenableProvider(create: (_) => new UserData()),
      ListenableProvider(create: (_) => new Storage()),
      ChangeNotifierProvider<User>(
        create: (_) => User(null, null, null),
      ),
    ], child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bankin',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
