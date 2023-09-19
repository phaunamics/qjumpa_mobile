import 'package:flutter/material.dart';
import 'package:qjumpa/injection.dart';
import 'package:qjumpa/src/core/firebase_auth.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/shopping_cart/cart.dart';
import 'package:qjumpa/src/presentation/widgets/bottom_nav/shopping_list_nav_bar.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = sl.get<Auth>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // argument of route to return to
            final String? previousRouteName =
                ModalRoute.of(context)?.settings.arguments as String?;

            
            if (previousRouteName == '/cartView') {
              Navigator.pushReplacementNamed(context, Cart.routeName);
            } else {
              // Navigate to the default screen if no specific route is needed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingListNavBar(),
                ),
              );
            }
          } else {
            return const LoginView();
          }
          return const SizedBox.shrink();
        });
  }
}
