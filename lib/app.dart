import 'package:document_scanner/base/themes/base_theme_data.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_document_to_cloud_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_pdf_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/folder_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/images_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/image_preview_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdf_preview_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdfs_screen.dart';
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
    context.read<ConnectivityBloc>().add(ConnectivityStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UploadPdfBloc, UploadPdfState>(
          listener: (_, uploadPdfState) {
            if (uploadPdfState is UploadPdfSuccess) {
              context.read<GetScannedDocumentsBloc>().add(
                    GetScannedDocumentsStarted(
                      showLoadingIndicator: false,
                    ),
                  );
            }
          },
        ),
        BlocListener<UploadScannedDocumentsBloc, UploadScannedDocumentsState>(
          listener: (_, uploadScannedDocumentsState) {
            if (uploadScannedDocumentsState is UploadScannedDocumentsSuccess) {
              context.read<GetScannedDocumentsBloc>().add(
                    AddScannedDocumentsStarted(
                      images: uploadScannedDocumentsState.images,
                      imagesFilename:
                          uploadScannedDocumentsState.imagesFilename,
                    ),
                  );
            }
            if (uploadScannedDocumentsState
                is UploadScannedDocumentsOfflineSuccess) {
              context.read<GetScannedDocumentsBloc>().add(
                    AddScannedDocumentsOfflineStarted(
                      document: uploadScannedDocumentsState.document,
                    ),
                  );
            }
          },
        ),
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (_, connectivityState) {
            if (connectivityState is ConnectivitySuccess) {
              if (connectivityState.isConnectedToInternet) {
                context
                    .read<UploadDocumentToCloudBloc>()
                    .add(UploadDocumentToCloudStarted());
                context.read<GetScannedDocumentsBloc>().add(
                    GetScannedDocumentsStarted(showLoadingIndicator: false));
              } else {
                context.read<GetScannedDocumentsBloc>().add(
                      GetScannedDocumentsOfflineStarted(
                        showLoadingIndicator: false,
                      ),
                    );
              }
            }
          },
        ),
        BlocListener<UploadDocumentToCloudBloc, UploadDocumentToCloudState>(
          listener: (_, uploadToCloudState) {
            if (uploadToCloudState is UploadDocumentToCloudSuccess) {
              context
                  .read<GetScannedDocumentsBloc>()
                  .add(GetScannedDocumentsStarted(showLoadingIndicator: true));
            }
          },
        ),
      ],
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (_, connectivityState) {
          if (connectivityState is! ConnectivitySuccess) {
            return Container();
          }

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

                        if (currentUser == null &&
                            connectivityState.isConnectedToInternet) {
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
                        return const NoTransitionPage(
                            child: NotificationScreen());
                      },
                    ),
                  ],
                  builder: (context, state, child) {
                    return BaseScaffoldDocumentScanner(child: child);
                  },
                ),
                GoRoute(
                  path: '/images',
                  name: ImagesScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const NoTransitionPage(child: ImagesScreen());
                  },
                ),
                GoRoute(
                  path: '/pdfs',
                  name: PdfsScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const NoTransitionPage(child: PdfsScreen());
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
                  path: '/pdf-preview',
                  name: PdfPreviewScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const NoTransitionPage(
                      child: PdfPreviewScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: '/folder/:folderId/:folderName',
                  name: FolderScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoTransitionPage(
                      child: FolderScreen(
                        folderId: state.pathParameters['folderId'] as String,
                        folderName:
                            state.pathParameters['folderName'] as String,
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
                GoRoute(
                  path: '/forgot-password',
                  name: ForgotPasswordScreen.name,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const NoTransitionPage(
                        child: ForgotPasswordScreen());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
