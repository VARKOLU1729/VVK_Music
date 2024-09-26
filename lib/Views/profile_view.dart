import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/Helper/Responsive.dart';
import 'package:runo_music/Widgets/mobile_app_bar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile()? MobileAppBar(context, disablePop: false):null,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child:Column(
          children: [
            SizedBox(height: 100,),
            Center(child: Image.asset('assets/images/profile_image.png', width: 200, height: 200,)),
            FilledButton(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                },
                child: Text("Sign Out", style: TextStyle(color: Colors.white),)
            )
          ],
        ),
      ),
    );
  }
}
