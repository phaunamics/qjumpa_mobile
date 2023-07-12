import 'package:flutter/material.dart';
import 'package:qjumpa/src/domain/entity/store_inventory.dart';
import 'package:qjumpa/src/presentation/cart/cart.dart';
import 'package:qjumpa/src/presentation/cart/empty_cart_screen.dart';
import 'package:qjumpa/src/presentation/change_username/change_username_screen.dart';
import 'package:qjumpa/src/presentation/login/login.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/otp/otp_screen.dart';
import 'package:qjumpa/src/presentation/product_scan/product_scan_screen.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen.dart';
import 'package:qjumpa/src/presentation/profile/profile_screen.dart';
import 'package:qjumpa/src/presentation/register_user/register_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/create_new_list.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list.dart';
import 'package:qjumpa/src/presentation/splash/splash_screen.dart';
import 'package:qjumpa/src/presentation/store_search/store_search_screen.dart';
import 'package:qjumpa/src/presentation/update_password/update_password_screen.dart';
import 'package:qjumpa/src/presentation/verification/email_verification.dart';
import 'package:qjumpa/src/presentation/widgets/ios_scanner_view.dart';

final Map<String, WidgetBuilder> routes = {
  EmailVerificationScreen.routeName: (context) =>
      const EmailVerificationScreen(),
  SplashScreeen.routeName: (context) => const SplashScreeen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  Login.routeName: (context) => const Login(),
  LoginView.routeName: (context) => const LoginView(),
  ProductSearchScreen.routeName: (context) => const ProductSearchScreen(),
  ProductScanScreen.routeName: (context) => ProductScanScreen(
        inventory: ModalRoute.of(context)!.settings.arguments as Inventory,
      ),
  OTPScreen.routeName: (context) => const OTPScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  UpdatePasswordScreen.routeName: (context) => const UpdatePasswordScreen(),
  ChangeUserNameScreen.routeName: (context) => const ChangeUserNameScreen(),
  EmptyCartScreen.routeName: (context) => const EmptyCartScreen(),
  StoreSearchScreen.routeName: (context) => const StoreSearchScreen(),
  Cart.routeName: (context) => const Cart(),
  ShoppingList.routeName: (context) => const ShoppingList(),
  IOSScannerView.routeName: (context) => const IOSScannerView(),
  CreateNewListScreen.routeName: (context) => const CreateNewListScreen(),
};
