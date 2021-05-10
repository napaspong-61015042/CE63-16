import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconModel {
  final String title;
  final IconData icon;

  IconModel({this.title, this.icon});
}

final List<IconModel> iconList = [
  IconModel(title: 'On - Off System', icon: Icons.add_to_home_screen),
  IconModel(title: 'Alert', icon: Icons.add_alert),
  IconModel(title: 'Check Status', icon: Icons.check),
  IconModel(title: 'Setting',icon: Icons.account_circle),
];