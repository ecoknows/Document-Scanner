import 'package:document_scanner/base/themes/base_theme_data.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/documents_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/image_preview_screen.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner/features/notifications/presentation/screens/notification_screen.dart';
import 'package:document_scanner/features/profile/presentation/screens/profile_screen.dart';
import 'package:document_scanner/features/settings/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    context.read<GetScannedDocumentsBloc>().add(GetScannedDocumentsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UploadScannedDocumentsBloc, UploadScannedDocumentsState>(
          listener: (_, uploadScannedDocumentsState) {
            if (uploadScannedDocumentsState is UploadScannedDocumentsSuccess) {
              context.read<GetScannedDocumentsBloc>().add(
                    AddScannedDocumentsStarted(
                      scannedDocuments:
                          uploadScannedDocumentsState.latestUploaded,
                    ),
                  );
            }
          },
        ),
      ],
      child: MaterialApp.router(
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
                  path: '/notifications',
                  name: NotificationScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const NoTransitionPage(child: NotificationScreen());
                  },
                ),
              ],
              builder: (context, state, child) {
                return BaseScaffoldDocumentScanner(child: child);
              },
            ),
            GoRoute(
              path: '/documents',
              name: DocumentsScreen.name,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(child: DocumentsScreen());
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
            GoRoute(
              path: '/image-preview/:index',
              name: ImagePreviewScreen.name,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                  child: ImagePreviewScreen(
                    index: state.pathParameters['index'] as String,
                  ),
                );
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
      ),
    );
  }
}
