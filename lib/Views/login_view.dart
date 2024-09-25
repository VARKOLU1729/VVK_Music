import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/tab_screen.dart';


final _firebase = FirebaseAuth.instance;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final authKey = GlobalKey<FormState>();

  String? _password;
  String? _email;

  bool signIn = false;
  bool signUp = false;

  void save() async
  {
    if(authKey.currentState!.validate())
      {

        try
        {
          if(signIn)
          {
            final userDetails = await _firebase.signInWithEmailAndPassword(email:_email!, password: _password!);
          }
          if(signUp)
          {
            final userDetails = await _firebase.createUserWithEmailAndPassword(email: _email!, password: _password!);
          }
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TabScreen()));
        }
        on FirebaseAuthException catch(error)
        {
          // print(error.message);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: authKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              TextFormField(
                style: TextStyle(
                    color: Colors.black87
                ),
                validator: (val) {
                  if(!(val!.contains('@gmail.com')))
                    {
                      return 'Email must contain @gmail.com';
                    }
                  return null;
                },
                onChanged: (val){
                  _email = val;
                },
                decoration:InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder()
                ),
              ),

              SizedBox(height: 20,),

              TextFormField(
                style: TextStyle(
                    color: Colors.black87
                ),
                validator: (val)
                {
                  if(val!.length<8)
                    return 'Password should contain atleast 8 letters';
                  return null;
                },
                onChanged: (val){
                  _password = val;
                },
                decoration:InputDecoration(
                  fillColor: Colors.white,
                    label: Text("Password"),
                    border: OutlineInputBorder()
                ),
                obscureText: true,
              ),

              FilledButton(
                  onPressed: ()
                  {
                    setState(() {
                      signIn = true;
                      save();
                    });

                  },
                  child: Text("sign in")
              ),
              FilledButton(
                  onPressed: ()
                  {
                    setState(() {
                      signUp = true;
                      save();
                    });
                  },
                  child: Text("signUp")
              ),

            ],
          ),
        ),
      ),
    );
  }
}
