import 'package:project/feature/chart/views/chart_screen.dart';
import 'package:project/feature/home/views/home_screen.dart';
import 'package:project/feature/profile/view/profile_screen.dart';

import 'image_const.dart';

class Constant{
  static const double kHMarginCard = 15.0;


  static  List<Map<String, dynamic>> dashboardItem = [
    {
      'icon': ImageConst.homeIcon,
      'tit': 'Home',
      'index': 0,
      'screen': const HomeScreen(),
    },
    {
      'icon': ImageConst.chartIcon,
      'tit': 'Search',
      'index': 1,
      'screen': const ChartScreen()
    },
    {
      'icon': ImageConst.personIcon,
      'tit': 'Profile',
      'index': 2,
      'screen': const ProfileScreen()
    },
  ];
}