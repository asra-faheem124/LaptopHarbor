import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/Admin/add_product.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/Admin/admin_home.dart';
import 'package:laptop_harbor/Admin/admin_products.dart';
import 'package:laptop_harbor/userPanel/product.dart';
import 'package:laptop_harbor/userPanel/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'ProductSans'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
