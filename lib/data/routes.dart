// lib/data/routes.dart
import 'package:flutter/material.dart';

import '../app/home.dart';
import '../app/menu.dart';
import '../app/login.dart';
import '../app/plant_detail.dart';
import '../app/crop_addition.dart';

final Map<String, WidgetBuilder> routes = {
  '/home':  (context) => const HomeScreen(),
  '/menu':  (context) => const MenuScreen(),
  '/plant': (context) => const PlantDetailScreen(),
  '/login': (context) => const LoginScreen(),
  '/crop_add': (context) => const CropAdditionPage(),
};
