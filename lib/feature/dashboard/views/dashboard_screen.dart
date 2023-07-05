import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/feature/dashboard/bloc/dashboard_bloc.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/tabbar_custom.dart';
import '../bloc/tab_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardMobileBloc get _bloc => BlocProvider.of<DashboardMobileBloc>(context);
  List<TabItem> _tabs = <TabItem>[];
   void _onTabChange(int index) {
    if (_bloc.state.index != index) {
      _bloc.add(ChangeTabEvent(
        index,
      ));
    }
  }
  @override

  void initState(){
    _tabs = _bloc.state.tabItems.map((e) => e).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardMobileBloc, DashboardMobileState>(
      builder: (context, state){
        return Scaffold(
          
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBody: true,
          bottomNavigationBar: TabBarCustom(
            elevation:0.9,
            tabBarColor: Theme.of(context).scaffoldBackgroundColor,
            tabBarType: TabBarType.dotTabBar,
            items: <TabBarItemStyle>[
              ...Constant.dashboardItem.map(
                (e) => TabBarItemStyle(
                  title: e['tit'],
                  assetIcon: e['icon'],
                  screen: e['screen'],
                ),
              ),
            ],
            onChangeTab: _onTabChange,
          ),
          body: IndexedStack(
            index: state.index,
            sizing: StackFit.expand,
            children: _tabs.map((e) => e.screen).toList(),
          ),
        );
      },
    );
  }
} 