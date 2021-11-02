import 'package:flutter/material.dart';
import 'package:mylocation/showmylocation.dart';

void main() {
  // TimeZone

  runApp(MaterialApp(
      initialRoute: '/ShowMyLocation',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/ShowMyLocation':
            return MaterialPageRoute(builder: (_) => const ShowMyLocation());

          default:
            return MaterialPageRoute(
                builder: (_) => Scaffold(
                      body: Center(
                          child: Text('No route defined for ${settings.name}')),
                    ));
        }
      }));
}
