import 'package:document_scanner/base/widgets/base_appbar.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/images_screen.dart';
import 'package:document_scanner/features/documents/presentation/screens/pdfs_screen.dart';
import 'package:document_scanner/features/profile/presentation/screens/profile_screen.dart';
import 'package:document_scanner/features/settings/presentation/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthenticatedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const AuthenticatedAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? photoUrl = currentUser?.photoURL;

    return BaseAppBar(
      title: Text(title),
      actions: [
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
                case "settings":
                  context.pushNamed(SettingsScreen.name);
                  break;
                case "images":
                  context.pushNamed(ImagesScreen.name);
                  break;
                case "pdfs":
                  context.pushNamed(PdfsScreen.name);
                  break;
                case "my-profile":
                  context.pushNamed(ProfileScreen.name);
                  break;
                case "logout":
                  context.read<AuthBloc>().add(SignOutUserStarted());
                  context.pushNamed(SignInScreen.name);
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
              const PopupMenuDivider(),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
