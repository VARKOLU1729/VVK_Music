import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  final user = FirebaseAuth.instance.currentUser;
  String userName = "UserName";
  bool isLoading = true;
  void getUserName() async
  {
    // final sp = await SharedPreferences.getInstance();
    // print(sp.getKeys());
    // List<String> val = sp.getStringList(user!.uid)!;
    // userName = val[0];

    final userData = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    userName = userData.data()!['userName'];

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState()
  {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {

    return isLoading ? Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.white,)),) : Scaffold(
      appBar: Responsive.isMobile() ? MobileAppBar(context, disablePop: false, title: "My Profile") : null,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile_image.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
               userName,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              user?.email ?? 'user@example.com', // Add user's email or a default
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                onPressed: () async{
                  print("signing out");
                  await FirebaseAuth.instance.signOut();
                  print("signed out");
                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginView()), (route)=>false);
                  context.go("/login");
                  context.pop();
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
