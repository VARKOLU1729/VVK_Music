import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';
import 'login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    // Fetching user data
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: Responsive.isMobile() ? MobileAppBar(context, disablePop: false, title: "My Profle") : null,
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
              user?.displayName ?? 'User Name', // Add user's display name or a default
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
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginView()));
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
