import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:document_scanner/base/widgets/base_appbar.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/camera/presentation/screens/camera_screen.dart';
import 'package:document_scanner/features/files/presentation/screens/files_screen.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner/features/profile/presentation/screens/profile_screen.dart';
import 'package:document_scanner/features/settings/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final Text? appBarTitle;
  final List<Widget>? appBarActions;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.appBarTitle,
    this.appBarActions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: appBarTitle,
        actions: appBarActions,
      ),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BaseScaffoldDocumentScanner extends StatefulWidget {
  final Widget child;

  const BaseScaffoldDocumentScanner({
    super.key,
    required this.child,
  });

  @override
  State<BaseScaffoldDocumentScanner> createState() =>
      _BaseScaffoldDocumentScannerState();
}

class _BaseScaffoldDocumentScannerState
    extends State<BaseScaffoldDocumentScanner> {
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.file_copy_sharp,
    Icons.settings,
    Icons.person,
  ];
  String appBarTitle = HomeScreen.name;

  @override
  void initState() {
    // context.read<AuthBloc>().add(SignOutUserStarted());
    // context.goNamed(SignInScreen.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? photoUrl = currentUser?.photoURL;

    return BaseScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(CameraScreen.name);
        },
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.document_scanner_rounded,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          String name = HomeScreen.name;
          switch (index) {
            case 0:
              context.goNamed(HomeScreen.name);
              name = HomeScreen.name;
              break;
            case 1:
              context.goNamed(FilesScreen.name);
              name = FilesScreen.name;
              break;
            case 2:
              context.goNamed(SettingsScreen.name);
              name = SettingsScreen.name;
              break;
            case 3:
              context.goNamed(ProfileScreen.name);
              name = ProfileScreen.name;
              break;
          }
          setState(() {
            _bottomNavIndex = index;
            appBarTitle = name;
          });
        },
        backgroundColor: Colors.black,
        inactiveColor: Colors.white,
        activeColor: Colors.orange,
      ),
      appBarTitle: Text(appBarTitle),
      appBarActions: [
        if (currentUser != null && photoUrl != null)
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
                case "logout":
                  context.read<AuthBloc>().add(SignOutUserStarted());
                  context.goNamed(SignInScreen.name);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
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
              const PopupMenuItem(
                value: "documents",
                height: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Documents',
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
              ),
            ],
          )
      ],
      body: widget.child,
    );
  }
}
