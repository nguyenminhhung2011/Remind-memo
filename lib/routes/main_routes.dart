import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/feature/auth/views/login_screen.dart';
import 'package:project/feature/contact_detail/notifier/contact_detail_notifier.dart';
import 'package:project/feature/contact_detail/view/contact_detail_screen.dart';
import 'package:project/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:project/feature/dashboard/views/dashboard_screen.dart';
import 'package:project/feature/splash/notifier/splash_notifier.dart';
import 'package:project/feature/splash/views/onboarding_screen.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';

import '../feature/pay_detail/notifier/pay_detail_notifier.dart';
import '../feature/pay_detail/views/pay_detail_screen.dart';
import '../feature/splash/views/splash_screen.dart';

class MainRoutes {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.dashboard:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider<DashboardMobileBloc>(
                  create: (_) => DashboardMobileBloc(),
                  child: const DashboardScreen(),
                ));

      case Routes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const SizedBox();
          },
        );
      case Routes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignInScreen(),
        );

      case Routes.onboard:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<SplashNotifier>.value(
                  value: SplashNotifier(),
                  child: const OnboardScreen(),
                ));
      case Routes.contactDetail:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<ContactDetailNotifier>.value(
                  value: ContactDetailNotifier(),
                  child: const ContactDetailScreen(),
                ));
      case Routes.payDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<PayDetailNotifier>.value(
            value: PayDetailNotifier(),
            child: const PayDetailScreen(),
          ),
        );

      default:
        return unDefinedRoute();
    }
  }

  static Route unDefinedRoute([String message = 'Page not founds']) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: Center(
            child: Text(message),
          ),
        );
      },
    );
  }
}