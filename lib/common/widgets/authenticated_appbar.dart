import 'package:document_scanner/base/widgets/base_appbar.dart';
import 'package:document_scanner/common/bloc/connectivity_bloc.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/images_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdfs_screen.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner/features/profile/presentation/screens/profile_screen.dart';
import 'package:document_scanner/features/settings/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthenticatedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final Widget? primaryWidget;

  final Widget? customizeAppBar;

  const AuthenticatedAppBar({
    super.key,
    required this.title,
    this.primaryWidget,
    this.customizeAppBar,
  });

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? photoUrl = currentUser?.photoURL;
    Widget? primary = primaryWidget;
    String? appTitle = title;

    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (_, connectivtyState) {
        if (connectivtyState is! ConnectivitySuccess) {
          return Container();
        }
        return BaseAppBar(
          title: customizeAppBar ??
              (appTitle != null && appTitle != HomeScreen.name
                  ? Text(appTitle)
                  : Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.jpg', // Path to your logo image
                          height: 40, // Adjust height as needed
                        ),
                        const SizedBox(
                          width: 8,
                        ), // Add spacing between the logo and title
                        Expanded(
                          child: Text(
                            "MOBILE DOCUMENT \nSCANNER APP FOR PSU",
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )),
          actions: [
            if (primary != null) primary,
            PopupMenuButton(
              position: PopupMenuPosition.under,
              constraints: BoxConstraints(
                minWidth: 132,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              tooltip: 'Menu',
              surfaceTintColor: Colors.white,
              color: Colors.white,
              icon: Row(
                children: [
                  if (connectivtyState.isConnectedToInternet == false)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[50], // Slight orange background
                          border: Border.all(
                            color: Colors.orange, // Orange stroke
                          ),
                          borderRadius:
                              BorderRadius.circular(20), // Oblong corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: const Text(
                          'Offline',
                          style: TextStyle(
                            color: Colors.orange, // Text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (connectivtyState.isConnectedToInternet == true &&
                      photoUrl != null)
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(photoUrl),
                        radius: 15.0,
                      ),
                    ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16.0,
                  ),
                ],
              ),
              onSelected: (value) {
                switch (value) {
                  case "settings":
                    context.goNamed(HomeScreen.name);
                    context.pushNamed(SettingsScreen.name);
                    break;
                  case "images":
                    context.goNamed(HomeScreen.name);
                    context.pushNamed(ImagesScreen.name);
                    break;
                  case "pdfs":
                    context.goNamed(HomeScreen.name);
                    context.pushNamed(PdfsScreen.name);
                    break;
                  case "my-profile":
                    context.goNamed(HomeScreen.name);
                    context.pushNamed(ProfileScreen.name);
                    break;
                  case "logout":
                    context.read<AuthBloc>().add(SignOutUserStarted());
                    context.goNamed(SignInScreen.name);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                if (currentUser != null) ...[
                  const PopupMenuItem(
                    value: "my-profile",
                    height: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text('My Profile',
                        style: TextStyle(
                            fontFamily: 'OpenSauceTwo',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14)),
                  ),
                  const PopupMenuDivider(),
                ],
                const PopupMenuItem(
                  value: "images",
                  height: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Images',
                    style: TextStyle(
                      fontFamily: 'OpenSauceTwo',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const PopupMenuItem(
                  value: "pdfs",
                  height: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    "PDF's",
                    style: TextStyle(
                      fontFamily: 'OpenSauceTwo',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: "settings",
                  height: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'OpenSauceTwo',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (currentUser != null) ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: "logout",
                    height: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'OpenSauceTwo',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
