import 'package:flutter/material.dart';

import '../app/home.dart';
import '../app/menu.dart';
import '../app/login.dart';
import '../app/plant_detail.dart';

final Widget homeRoute = HomeScreen();
final Widget loginRoute = LoginScreen();


final Map<String, WidgetBuilder> routes = {
  '/home': (context) => HomeScreen(),
  '/menu': (context) => MenuScreen(),
  '/plant': (context) => PlantDetailScreen(),
  '/login': (context)  => const LoginScreen(),
};
