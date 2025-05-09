// lib/data/routes.dart
import 'package:flutter/material.dart';

import '../app/ai_chat.dart';
import '../app/home.dart';
import '../app/menu.dart';
import '../app/login.dart';
import '../app/plant_detail.dart';
import '../app/crop_addition.dart';
import '../app/signup.dart';

final Map<String, WidgetBuilder> routes = {
  '/home':  (context) => const HomeScreen(),
  '/menu':  (context) => const MenuScreen(),
// routes.dart
  '/plant': (ctx) {
    final args = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;

    return PlantDetailScreen(
      cropId:          args['cropId']        as int,
      nickName:        args['nickName']      as String,
      liveDay:         args['liveDay']       as int,
      cropName:        args['cropName']      as String,
      isEnd:           args['isEnd']         as int,
      evaluationRate:  (args['evaluationRate'] as num).toDouble(), // ★
      evaluation:      args['evaluation']    as String,            // ★
    );
  },

  '/login':    (context) => const LoginScreen(),
  '/crop_add': (context) => const CropAdditionPage(),
  '/chat': (context) => const AiChatPage(),
  '/signup': (ctx) => const SignUpScreen(),
};
