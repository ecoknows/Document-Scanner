import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String name = 'Profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? photoUrl = currentUser?.photoURL;

    String? displayName = currentUser?.displayName;
    String? email = currentUser?.email;

    return BaseScaffold(
      appBar: AuthenticatedAppBar(
        title: ProfileScreen.name,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(photoUrl!),
              radius: 80.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            displayName!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            email!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
