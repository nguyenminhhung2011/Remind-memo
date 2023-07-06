import 'package:flutter/material.dart';
import 'package:project/feature/chart/views/chart_screen.dart';
import 'package:project/feature/home/views/home_screen.dart';
import 'package:project/feature/list_contact/views/list_contact_screen.dart';
import 'package:project/feature/profile/view/profile_screen.dart';

import 'image_const.dart';

class Constant {
  static const double kHMarginCard = 15.0;

  static List<Map<String, dynamic>> dashboardItem = [
    {
      'icon': ImageConst.homeIcon,
      'tit': 'Home',
      'index': 0,
      'screen': const HomeScreen(),
    },
    {
      'icon': ImageConst.personIcon,
      'tit': 'Search',
      'index': 1,
      'screen': const ContactScreen()
    },
    {
      'icon': ImageConst.chartIcon,
      'tit': 'Search',
      'index': 2,
      'screen': const ChartScreen()
    },
    {
      'icon': ImageConst.settingIcon,
      'tit': 'Profile',
      'index': 3,
      'screen': const ProfileScreen()
    },
  ];

  static List<Map<String, dynamic>> icons = [
    {
      'icon': '🐼',
      'color': const Color.fromARGB(255, 29, 238, 186),
    },
    {
      'icon': '🐳',
      'color': const Color.fromARGB(255, 74, 157, 226),
    },
    {
      'icon': '🐸',
      'color': const Color.fromARGB(255, 108, 230, 112),
    },
    {
      'icon': '🤖',
      'color': const Color.fromARGB(255, 250, 102, 92),
    },
    {
      'icon': '🐯',
      'color': const Color.fromARGB(255, 236, 198, 49),
    },
    {
      'icon': '🐶',
      'color': const Color.fromARGB(255, 173, 92, 10),
    },
    {
      'icon': '🦊',
      'color': Colors.orange,
    },
    {
      'icon': '🐷',
      'color': const Color.fromARGB(255, 250, 92, 160),
    },
    {
      'icon': '🐮',
      'color': const Color.fromARGB(255, 176, 92, 250),
    },
    
  ];
}
