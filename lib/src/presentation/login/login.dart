import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/bottom_nav_bar.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = sl.get<Auth>();
  final List<Widget> _pages = <Widget>[
    const SelectStoreScreen(),
    const ShoppingList()
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNavBar(
              pages: _pages,
              customWidget: SvgPicture.asset(
                'assets/shop_icon.svg',
              ),
            );
          } else {
            return const LoginView();
          }
        });
  }
}
