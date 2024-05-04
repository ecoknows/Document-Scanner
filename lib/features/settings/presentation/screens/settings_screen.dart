import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static String name = 'Settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AuthenticatedAppBar(
        title: SettingsScreen.name,
      ),
      body: Container(),
    );
  }
}
