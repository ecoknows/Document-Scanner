import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
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
    return BaseScaffold(
      appBar: AuthenticatedAppBar(
        title: ProfileScreen.name,
      ),
      body: Container(),
    );
  }
}
