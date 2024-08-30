import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_scrapper/providers/internet_check_provider.dart';
import 'package:sky_scrapper/views/pages/home_page.dart';
import 'utils/themeToggle.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => InternetCheckProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeToggle().darkTheme,
      themeMode: ThemeMode.light,
      theme: ThemeToggle().lightTheme,
      home: const HomePage(),
    );
  }
}
