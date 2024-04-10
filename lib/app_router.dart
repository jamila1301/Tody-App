import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tody_app/bloc/auth/auth_notifier.dart';
import 'package:tody_app/bloc/login/login_notifier.dart';
import 'package:tody_app/bloc/user/user_notifier.dart';
import 'package:tody_app/core/constants/routes.dart';
import 'package:tody_app/features/category/presentation/bloc/category_actions/category_actions_bloc.dart';
import 'package:tody_app/features/category/presentation/bloc/category_list/category_list_bloc.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_actions_bloc.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_list_bloc.dart';
import 'package:tody_app/pages/task_list_page.dart';
import 'package:tody_app/presentation/pages/home/home_page.dart';
import 'package:tody_app/presentation/pages/login/login_page.dart';
import 'package:tody_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:tody_app/presentation/pages/settings/settings_page.dart';
import 'package:tody_app/presentation/pages/splash/splash_page.dart';

final _appRouterKey = GlobalKey<NavigatorState>();
final _shellRouteKey = GlobalKey<NavigatorState>();

/// / - empty screen
/// /important-tasks - list of importants (undone)
/// /tasks - total list of undone todos
/// /categories/:id - category with id 5 will be visible within its items

final class AppRouter {
  AppRouter({
    required AuthNotifier authNotifier,
  }) {
    _appRouter = GoRouter(
      initialLocation: Routes.splash.path,
      navigatorKey: _appRouterKey,
      refreshListenable: authNotifier,
      redirect: (context, state) {
        final authState = authNotifier.authState;

        if (authState == AuthState.onboarding) {
          if (state.matchedLocation == Routes.onboarding.path) {
            return null;
          }

          return Routes.onboarding.path;
        } else if (authState == AuthState.unauthenticated) {
          if (state.matchedLocation == Routes.login.path) {
            return null;
          }

          return Routes.login.path;
        } else if (authState == AuthState.authenticated) {
          final isOnLoginPage = state.matchedLocation == Routes.login.path;
          final isOnSplashPage = state.matchedLocation == Routes.splash.path;

          if (isOnLoginPage || isOnSplashPage) {
            return Routes.home.path;
          }
        }

        return state.matchedLocation;
      },
      routes: [
        GoRoute(
          path: Routes.splash.path,
          builder: (context, state) {
            return const SplashPage();
          },
        ),
        GoRoute(
          path: Routes.onboarding.path,
          builder: (context, state) {
            return const OnBoardingPage();
          },
        ),
        GoRoute(
          path: Routes.settings.path,
          builder: (context, state) {
            final userNotifier = state.extra as UserNotifier?;

            if (userNotifier != null) {
              return ChangeNotifierProvider.value(
                value: state.extra as UserNotifier,
                child: const SettingsPage(),
              );
            }

            return ChangeNotifierProvider(
              create: (_) => UserNotifier()..fetchUser(),
              child: const SettingsPage(),
            );
          },
        ),
        GoRoute(
          path: Routes.login.path,
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (context) => GetIt.instance<LoginNotifier>(),
              child: const LoginPage(),
            );
          },
        ),
        if (kIsWeb)
          ShellRoute(
            navigatorKey: _shellRouteKey,
            builder: (context, shell, child) {
              return ChangeNotifierProvider(
                lazy: true,
                create: (context) => UserNotifier()..fetchUser(),
                child: HomePage(child: child),
              );
            },
            routes: [
              /// 0
              GoRoute(
                parentNavigatorKey: _shellRouteKey,
                path: Routes.home.path,
                builder: (context, state) {
                  return const Center(
                    child: SizedBox.shrink(),
                  );
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellRouteKey,
                path: Routes.importantTasks.path,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Text('Important Tasks'),
                      ),
                    ),
                  );
                },
              ),
              GoRoute(
                parentNavigatorKey: _shellRouteKey,
                path: Routes.categoriesById.path,
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id'];
                  final parsedId = int.parse(id!);
                  final actionsBloc = GetIt.instance.get<CategoryActionsBloc>();

                  print('routing to $id');

                  return NoTransitionPage(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<CategoryListBloc>(),
                        ),
                        BlocProvider(
                          create: (context) => actionsBloc
                            ..add(CategoryDetailsRequested(parsedId)),
                        ),
                      ],
                      child: TaskListPage(categoryId: parsedId),
                    ),
                  );
                },
              ),
            ],
          )
        else ...[
          GoRoute(
            path: Routes.home.path,
            builder: (context, state) {
              return ChangeNotifierProvider(
                lazy: true,
                create: (context) => UserNotifier()..fetchUser(),
                child: const HomePage(),
              );
            },
          ),
          GoRoute(
            path: Routes.importantTasks.path,
            builder: (context, state) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Text('Important Tasks'),
                ),
              );
            },
          ),
          GoRoute(
            path: Routes.categoriesById.path,
            builder: (context, state) {
              final id = state.pathParameters['id'];
              final parsedId = int.parse(id!);

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: state.extra as CategoryListBloc,
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetIt.instance.get<CategoryActionsBloc>()
                          ..add(CategoryDetailsRequested(parsedId)),
                  ),
                  BlocProvider(
                    create: (context) => GetIt.instance.get<TodoListBloc>()
                      ..add(TodoListRequested(parsedId)),
                  ),
                  BlocProvider(
                    create: (context) => GetIt.instance.get<TodoActionsBloc>(),
                  ),
                ],
                child: TaskListPage(categoryId: parsedId),
              );
            },
          ),
        ],
      ],
    );
  }

  GoRouter get instance => _appRouter;

  late final GoRouter _appRouter;
}
