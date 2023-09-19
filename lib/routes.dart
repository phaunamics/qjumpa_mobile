import 'package:flutter/material.dart';
import 'package:qjumpa/src/domain/entity/arguments.dart';
import 'package:qjumpa/src/domain/entity/store_entity.dart';
import 'package:qjumpa/src/presentation/change_username/change_username_screen.dart';
import 'package:qjumpa/src/presentation/login/login.dart';
import 'package:qjumpa/src/presentation/login/login_view.dart';
import 'package:qjumpa/src/presentation/otp/otp_screen.dart';
import 'package:qjumpa/src/presentation/product_scan/product_scan_screen.dart';
import 'package:qjumpa/src/presentation/product_search/product_search_screen_.dart';
import 'package:qjumpa/src/presentation/profile/profile_screen.dart';
import 'package:qjumpa/src/presentation/register_user/register_screen.dart';
import 'package:qjumpa/src/presentation/select_store/select_store_screen.dart';
import 'package:qjumpa/src/presentation/shopping_cart/cart.dart';
import 'package:qjumpa/src/presentation/shopping_cart/empty_cart_screen.dart';
import 'package:qjumpa/src/presentation/shopping_list/create_new_list.dart';
import 'package:qjumpa/src/presentation/shopping_list/shopping_list_screen.dart';
import 'package:qjumpa/src/presentation/splash_screen/splash_screen.dart';
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
  ProductSearchScreen.routeName: (context) => ProductSearchScreen(
        storeEntity: ModalRoute.of(context)!.settings.arguments as StoreEntity,
      ),
  ProductScanScreen.routeName: (context) => ProductScanScreen(
        arguments: ModalRoute.of(context)!.settings.arguments as Arguments,
      ),
  OTPScreen.routeName: (context) => const OTPScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  UpdatePasswordScreen.routeName: (context) => const UpdatePasswordScreen(),
  ChangeUserNameScreen.routeName: (context) => const ChangeUserNameScreen(),
  EmptyCartScreen.routeName: (context) => const EmptyCartScreen(),
  SelectStoreScreen.routeName: (context) => const SelectStoreScreen(),
  Cart.routeName: (context) => const Cart(),
  ShoppingListScreen.routeName: (context) => const ShoppingListScreen(),
  IOSScannerView.routeName: (context) => const IOSScannerView(),
  CreateNewListScreen.routeName: (context) => const CreateNewListScreen(),
};
