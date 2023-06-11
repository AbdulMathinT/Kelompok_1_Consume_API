import 'package:flutter/material.dart';
import 'package:kel_1_api/utils/app_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ITG Consume API Kelompok 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Approutes.goRouter.routeInformationParser,
      routeInformationProvider: Approutes.goRouter.routeInformationProvider,
      routerDelegate: Approutes.goRouter.routerDelegate,
    );
  }
}
