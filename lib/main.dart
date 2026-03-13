import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alarm/alarm.dart';
import 'package:eduflow/config/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eduflow/config/theme/app_theme.dart';
import 'package:eduflow/config/theme/bloc/theme_cubit.dart';
import 'package:eduflow/core/alarm/alarm_service.dart';
import 'package:eduflow/di/service_locator.dart';

import 'package:eduflow/features/admin_panel/presentation/bloc/admin_users/admin_users_bloc.dart';
import 'package:eduflow/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:eduflow/features/planner/presentation/bloc/planner_bloc.dart';
import 'package:eduflow/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:eduflow/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:eduflow/features/subjects/presentation/bloc/subject_bloc.dart';
import 'package:eduflow/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:eduflow/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:eduflow/features/onboarding/presentation/bloc/onboarding_bloc.dart';

import 'dart:async';
import 'package:eduflow/core/utils/logger.dart';
import 'package:go_router/go_router.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 📱 Enable Edge-to-Edge (Full Screen)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      await AlarmService.instance.init();
      await setupServiceLocator();

      runApp(const MyApp());
    },
    (error, stack) {
      AppLogger.e('Unhandled Exception caught in main zone', error, stack);
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final UserBloc _userBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // 1️⃣ Initialize User Bloc
    _userBloc = getIt<UserBloc>()..add(const CheckAuthStatusEvent());

    // 2️⃣ Create Router with Auth Listener
    _router = createAppRouter(_userBloc);

    // 🎧 Listen to Alarm Ring Stream
    Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isNotEmpty) {
        final settings = alarmSet.alarms.last;
        debugPrint('🔔 Alarm ringing: ${settings.id}');
        _router.pushNamed(AppRouteNames.alarmRing, extra: settings);
      }
    });
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // ✅ BEST universal baseline
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MultiBlocProvider(
          providers: [
            // ✅ Use .value since we created it in initState
            BlocProvider.value(value: _userBloc),
            BlocProvider(create: (_) => getIt<AdminUsersBloc>()),
            BlocProvider(create: (_) => getIt<SubjectBloc>()),
            BlocProvider(create: (_) => getIt<TaskBloc>()),
            BlocProvider(create: (_) => getIt<PlannerBloc>()),
            BlocProvider(create: (_) => getIt<ResourceBloc>()),
            BlocProvider(create: (_) => getIt<ReminderBloc>()),
            BlocProvider(create: (_) => getIt<AnalyticsBloc>()),
            BlocProvider(create: (_) => getIt<ThemeCubit>()), // 🌓 Theme Cubit
            BlocProvider(
              create: (_) =>
                  getIt<OnboardingBloc>()..add(const CheckOnboardingStatus()),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Eduflow',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark, // 🌑 Dark Theme
                themeMode: themeMode,
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}
