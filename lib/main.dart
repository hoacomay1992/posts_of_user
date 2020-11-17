import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:posts_of_user/network/api_service.dart';
import 'package:posts_of_user/ui/my_home.dart';
import 'package:provider/provider.dart';

void main() {
  _setupLogin();
  runApp(MyApp());
}
void _setupLogin() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print('${event.level.name} : ${event.message}');
  });
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => ApiService.create(),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home: MyHome(),
      ),
    );
  }
}
