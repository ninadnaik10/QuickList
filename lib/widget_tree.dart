import 'package:quick_list/auth.dart';

import 'package:flutter/material.dart';
import 'package:quick_list/pages/home_page.dart';
import 'package:quick_list/pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: ((context, snapshot) =>
            snapshot.hasData ? const HomePage() : const LoginPage()));
  }
}
