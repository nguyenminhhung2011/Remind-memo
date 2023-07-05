import 'package:flutter/material.dart';

import '../../../core/constant/image_const.dart';

class SplashNotifier extends ChangeNotifier {
 int? index;
 
  SplashNotifier(){
    index =0;
  }

  List<Map<String, dynamic>> pages = [
    {
      'image': const ContainerImage(image: ImageConst.onboard1),
      'topic': ' Welcome to Remind Memo',
      'description':
          'Manage your debts and credits easily and efficiently.',
    },
    {
      'image': const ContainerImage(image: ImageConst.onboard2),
      'topic': 'Get Started with Remind Memo',
      'description':
          'Track, record, and organize your debts and credits smartly and conveniently.',
    },
    {
      'image': const ContainerImage(image: ImageConst.onboard3),
      'topic': 'Optimize Personal Financial Management',
      'description':
          'Build an automated debt tracker and manage your finances smartly and effectively with Debt Tracker. ',
    },
  ];
  Map<String, dynamic> get page => pages[index!];

  void changePage(int newIndex) {
    index = newIndex;

    notifyListeners();
  }
}

class ContainerImage extends StatelessWidget {
  final String image;
  const ContainerImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(image),
        ),
      ),
    );
  }
}
