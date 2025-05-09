import 'package:flutter/material.dart';

import '../app/home.dart';
import '../app/menu.dart';
import '../app/plant_detail.dart';

final Widget homeRoute = HomeScreen();


final Map<String, WidgetBuilder> routes = {
  '/home': (context) => HomeScreen(),
  '/menu': (context) => MenuScreen(),
  '/plant': (context) => PlantDetailScreen(), // 추가
};
