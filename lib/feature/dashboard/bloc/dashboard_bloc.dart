import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/feature/dashboard/bloc/tab_item.dart';

part 'dashboard_state.dart';

part 'dashboard_event.dart';

class DashboardMobileBloc
    extends Bloc<DashBoarMobileEvent, DashboardMobileState> {
  DashboardMobileBloc()
      : super(
          DashboardInitial([
            ...Constant.dashboardItem.map((e) => TabItem(
                  screen: e['screen'],
                  route: e['tit'],
                  icon: e['icon'],
                  index: e['index'],
                ))
          ], 0, true),
        ) {
    on<ChangeTabEvent>(_onChangeTab);
    on<ChangeShowMenuEvent>(_onChangeShoeMenu);
  }

  FutureOr<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<DashboardMobileState> emit,
  ) {
    emit(ChangeTab(state.tabItems, event.index, state.isShowMenu));
  }

  FutureOr<void> _onChangeShoeMenu(
    ChangeShowMenuEvent event,
    Emitter<DashboardMobileState> emit,
  ) {
    emit(ChangeShowMenu(state.tabItems, state.index, !state.isShowMenu));
  }
}
