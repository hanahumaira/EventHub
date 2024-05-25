// ignore_for_file: prefer_const_constructors

// import 'package:eventhub/model/user.dart';
// import 'package:eventhub/screen/admin/admin_homepage.dart';
// import 'package:eventhub/screen/profile/edit_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'screen/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // User dummyUser = User(
  //   name: 'Admin User',
  //   email: 'admin@example.com',
  //   password: '123456',
  //   phoneNum: '',
  //   accountType: '',
  // );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        //GetPage(name: '/', page: () => AdminHomePage(passUser: dummyUser)),
        GetPage(name: '/', page: () => Login()),
        // GetPage(name: '/editProfile', page: () => const EditProfileScreen()),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
