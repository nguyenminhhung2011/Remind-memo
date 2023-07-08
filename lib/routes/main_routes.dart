import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/dependency_injection/di.dart';
import 'package:project/feature/add_pay/notifier/add_pay_notifier.dart';
import 'package:project/feature/add_pay/views/add_pay_screen.dart';
import 'package:project/feature/auth/notifier/login_notifier.dart';
import 'package:project/feature/auth/notifier/register_notifier.dart';
import 'package:project/feature/auth/views/login_screen.dart';
import 'package:project/feature/auth/views/register_screen.dart';
import 'package:project/feature/contact_detail/notifier/contact_detail_notifier.dart';
import 'package:project/feature/contact_detail/view/contact_detail_screen.dart';
import 'package:project/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:project/feature/dashboard/views/dashboard_screen.dart';
import 'package:project/feature/home/notifier/home_notifier.dart';
import 'package:project/feature/home/views/home_screen.dart';
import 'package:project/feature/splash/notifier/splash_notifier.dart';
import 'package:project/feature/splash/views/onboarding_screen.dart';
import 'package:project/routes/routes.dart';
import 'package:provider/provider.dart';
import '../feature/paid/views/paid_screen.dart';
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
          builder: (_) => ChangeNotifierProvider<HomeNotifier>.value(
            value: injector.get(),
            child: const HomeScreen(),
          ),
        );

      case Routes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<LoginNotifier>.value(
            value: injector.get(),
            child: const SignInScreen(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<RegisterNotifier>.value(
            value: injector.get(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.paid:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PaidScreen(),
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
            builder: (_) {
              if (settings.arguments is String) {
                return ChangeNotifierProvider<ContactDetailNotifier>.value(
                  value: injector.get(param1: settings.arguments),
                  child: const ContactDetailScreen(),
                );
              }
              return const SizedBox();
            });
      case Routes.payDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<PayDetailNotifier>.value(
            value: PayDetailNotifier(),
            child: const PayDetailScreen(),
          ),
        );
      case Routes.addPay:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) {
              if (settings.arguments is AddPayArguments) {
                return ChangeNotifierProvider<AddPayNotifier>.value(
                  value: AddPayNotifier(settings.arguments as AddPayArguments),
                  child: const AddPayScreen(),
                );
              }
              return const SizedBox();
            });

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
