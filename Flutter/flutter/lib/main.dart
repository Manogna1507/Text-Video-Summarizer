
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainPage.dart';
import 'welcome.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
     await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey:"YOUR API KEY",//new
      appId:"YOUR APP ID",//new
      messagingSenderId: "YOUR SENDER ID",//new
      projectId:"YOUR PROJECT ID") );//new





  runApp(const MyApp());
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const WelcomePage();
    } else {
      return const MainPage();
    }
  }
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}


