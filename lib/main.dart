import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tody_app/app_router.dart';
import 'package:tody_app/bloc/auth/auth_notifier.dart';
import 'package:tody_app/bloc/settings/localization/localization_notifier.dart';
import 'package:tody_app/bloc/settings/theme/theme_scope.dart';
import 'package:tody_app/bloc/settings/theme/theme_scope_widget.dart';

import 'initialization.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await di.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    // DevicePreview(
    // enabled: true,
    // builder: (context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GetIt.instance<AuthNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetIt.instance<LocalizationNotifier>(),
        ),
      ],
      child: ThemeScopeWidget(
        preferences: GetIt.instance<SharedPreferences>(),
        child: const MyApp(),
      ),
    ),
    // ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final extensions = <ThemeExtension<dynamic>>[
      theme.colors,
      theme.typography,
    ];

    return MaterialApp.router(
      title: 'Tody App',
      routerConfig: GetIt.instance.get<AppRouter>().instance,
      debugShowCheckedModeBanner: false,
      locale: context.watch<LocalizationNotifier>().locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: theme.themeMode,
      themeAnimationCurve: Curves.fastOutSlowIn,
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: extensions,
        scaffoldBackgroundColor: theme.colors.surface,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: extensions,
        scaffoldBackgroundColor: theme.colors.surface,
      ),
      builder: (context, child) {
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 1.0,
          maxScaleFactor: 1.3,
          child: child!,
        );
      },
      // routes: {
      //   Routes.home.path: (context) => ChangeNotifierProvider(
      //         lazy: true,
      //         create: (context) => UserNotifier()..fetchUser(),
      //         child: const HomePage(),
      //       ),
      //   Routes.settings.path: (context) {
      //     final modalRoute = ModalRoute.of(context)!;
      //     final settings = modalRoute.settings;

      //     return ChangeNotifierProvider.value(
      //       value: settings.arguments as UserNotifier,
      //       child: const SettingsPage(),
      //     );
      //   },
      //   Routes.taskList.path: (context) {
      //     final arguments = ModalRoute.of(context)!.settings.arguments
      //         as Map<String, dynamic>;

      //     return MultiBlocProvider(
      //       providers: [
      //         BlocProvider(
      //           create: (context) => GetIt.instance<CategoryActionsBloc>()
      //             ..add(
      //               CategoryDetailsRequested(
      //                 arguments['categoryId'] as int,
      //               ),
      //             ),
      //         ),
      //         BlocProvider.value(
      //           value: arguments['categoriesBloc'] as CategoryListBloc,
      //         ),
      //       ],
      //       child: const TaskListPage(),
      //     );
      //   },
      // },
    );
  }
}
