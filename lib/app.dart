import 'package:document_scanner/base/themes/base_theme_data.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:document_scanner/features/camera/presentation/screens/camera_screen.dart';
import 'package:document_scanner/features/files/presentation/screens/files_screen.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner/features/profile/presentation/screens/profile_screen.dart';
import 'package:document_scanner/features/settings/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: BaseThemeData.primaryLightTheme,
      darkTheme: BaseThemeData.primaryDarkTheme,
      themeMode: ThemeMode.light,
      routerConfig: GoRouter(
        initialLocation: '/home',
        routes: [
          ShellRoute(
            routes: [
              GoRoute(
                path: '/home',
                name: HomeScreen.name,
                redirect: (context, state) {
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser == null) {
                    return '/sign-in';
                  }

                  return null;
                },
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage(child: HomeScreen());
                },
              ),
              GoRoute(
                path: '/files',
                name: FilesScreen.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage(child: FilesScreen());
                },
              ),
              GoRoute(
                path: '/profile',
                name: ProfileScreen.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage(child: ProfileScreen());
                },
              ),
              GoRoute(
                path: '/settings',
                name: SettingsScreen.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage(child: SettingsScreen());
                },
              ),
            ],
            builder: (context, state, child) {
              return BaseScaffoldDocumentScanner(child: child);
            },
          ),
          GoRoute(
            path: '/camera',
            name: CameraScreen.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: CameraScreen());
            },
          ),
          GoRoute(
            path: '/sign-in',
            name: SignInScreen.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: SignInScreen());
            },
          ),
          GoRoute(
            path: '/sign-up',
            name: SignUpScreen.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: SignUpScreen());
            },
          ),
        ],
      ),
    );
  }
}
