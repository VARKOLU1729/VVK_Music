import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/Helper/deviceParams.dart';
import 'package:runo_music/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/Responsive.dart';

final _firebase = FirebaseAuth.instance;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _authKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _username;
  bool _showPassword = false;
  Color color = Color.fromARGB(255, 29, 148, 202);
  bool _isSignIn = true;
  bool _isHelp = false;

  Future<void> _save() async {
    if (_authKey.currentState!.validate()) {
      final sp = await SharedPreferences.getInstance();
      try {
        if (_isSignIn)
        {
          await _firebase.signInWithEmailAndPassword(email: _email!, password: _password!);
        }
        else
        {
          await _firebase.createUserWithEmailAndPassword(email: _email!, password: _password!);
          sp.setStringList(_firebase.currentUser!.uid, [_username!]);
        }
        print(_firebase.currentUser!.uid);

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TabScreen()));
      }
      on FirebaseAuthException catch (error)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
      }
    }
  }

  void onPasswordCheckBox(val)
  {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void toggleHelp()
  {
    setState(() {
      _isHelp = !_isHelp;
    });
  }


  @override
  void initState()
  {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TabScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        height: getHeight(context),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                  Colors.grey.withOpacity(0.1),
                ]
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:getHeight(context)/8),
                Center(child: const Text("Runo Music", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25))),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left:  (getWidth(context)/2 > 215)? (getWidth(context)/2 - 215) : 20),
                  child: const Text("Welcome", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)),
                ),
                const SizedBox(height: 5),
                Center(child: _buildAuthForm()),
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(text: TextSpan(text: "Conditions of Use", style: TextStyle(color: color))),
                        RichText(text: TextSpan(text: "Privacy Notice", style: TextStyle(color: color))),
                        RichText(text: TextSpan(text: "Help", style: TextStyle(color: color))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      width: 400,
      // padding: const EdgeInsets.all(20),
      child: Form(
        key: _authKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadioTile("Create account ","New to Runo?" , false),
            if (!_isSignIn) Header("First and last name"),
            if (!_isSignIn) _buildUserNameField(),
            if (!_isSignIn) const SizedBox(height: 20),
            if (!_isSignIn) Header("Your email adress"),
            if (!_isSignIn) _buildEmailField(),
            if (!_isSignIn) const SizedBox(height: 20),
            if (!_isSignIn) Header("Set password"),
            if (!_isSignIn) _buildPasswordField(),
            if (!_isSignIn) PasswordNotice(),
            if (!_isSignIn) showPassword(),
            if (!_isSignIn) _buildActionButton("Sign Up"),
            if (!_isSignIn) _statement(),
            if (!_isSignIn) const SizedBox(height: 10),
            _buildRadioTile("Sign in ","Already a customer?" , true),
            if (_isSignIn) Header("Email"),
            if (_isSignIn) _buildEmailField(),
            if (_isSignIn) const SizedBox(height: 20),
            if (_isSignIn) Header("Password"),
            if (_isSignIn) _buildPasswordField(),
            if (_isSignIn) showPassword(),
            if (_isSignIn) _buildActionButton("Sign In"),
            if (_isSignIn) _statement(),
            if(_isSignIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton.icon(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)
                  ),
                  onPressed: toggleHelp,
                  icon: Icon(
                    _isHelp ? Icons.arrow_drop_down_sharp : Icons.arrow_right,
                    color: Colors.grey
                  ),
                  label: Text(
                    "Need help?",
                    style: TextStyle(color: color, fontSize: 15),
                  ),
                ),
              ),
            if (_isHelp)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color:color, height: 2),
                    children: [
                      TextSpan(
                        text: 'Forgot Password\n'
                      ),
                      TextSpan(
                        text: 'Other issues with Sign-in\n'
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget showPassword()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CheckboxListTile(
        splashRadius: 0,
        value: _showPassword,
        onChanged: onPasswordCheckBox,
        title: const Text(
          "Show password",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        fillColor: WidgetStatePropertyAll(Colors.white),
        activeColor: Colors.white,
        checkColor: Colors.orange,
        controlAffinity: ListTileControlAffinity.leading,
        tileColor: Colors.transparent,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        side: BorderSide(
          width: 2,
          color: _showPassword? Colors.orange : Colors.white
        ),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(horizontal: -4),
      ),
    );
  }



  Widget PasswordNotice()
  {
    double fontSize = 15;
    double letterSpacing  = 0.2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: RichText(
        text: TextSpan(
          text: 'i  ',style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green, fontSize: fontSize, letterSpacing: letterSpacing),
          children: [
            TextSpan(
              text: "Passwords must be at least 8 letters", style: TextStyle(fontStyle: FontStyle.normal, color: Colors.white, fontSize: fontSize, letterSpacing: letterSpacing)
            )
          ]
        ),
      ),
    );
  }

  Widget Header(String title)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(title ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
    );
  }


  Widget _statement()
  {
    double fontSize = 15;
    FontWeight fontWeight = FontWeight.w400;
    double letterSpacing = 0.2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RichText(
          text: TextSpan(text: "By creating an account or logging in, you agree to Runo's ", style: TextStyle(height:1.5, color: Colors.white, fontSize: fontSize, fontWeight: fontWeight, letterSpacing: letterSpacing),
            children: [
              TextSpan(text: "Conditions of Use ", style: TextStyle(color: color,  fontSize: fontSize, decoration: TextDecoration.underline, letterSpacing: letterSpacing)),
              TextSpan(text: "and ", style: TextStyle(color: Colors.white,  fontSize: fontSize, fontWeight: fontWeight, letterSpacing: letterSpacing)),
              TextSpan(text: "Privacy Notice", style: TextStyle(color: color,  fontSize: fontSize, decoration: TextDecoration.underline, letterSpacing: letterSpacing))
            ],
        )
      ),
    );
  }


  Widget _buildRadioTile(String title1, String title2, bool isSignIn) {
    return Container(
      color: _isSignIn == isSignIn ? Colors.black87 : Colors.grey,
      child: RadioListTile(
        title: RichText(
          text: TextSpan(text: title1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
            children: [
              TextSpan(
                text: title2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15)
              )
            ]
          ),

        ),
        activeColor: Colors.orange,
        value: isSignIn,
        groupValue: _isSignIn,
        onChanged: (val) {
          setState(() {
            _isSignIn = val!;
          });
        },
      ),
    );
  }

  Widget _buildUserNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InputField(
        labelText: "",
        onChanged: (val) => _username = val,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Username must not be null';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InputField(
        labelText: "",
        onChanged: (val) => _email = val,
        validator: (val) {
          if (!val!.contains('@gmail.com')) {
            return 'Email must contain @gmail.com';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InputField(
        labelText: "",
        onChanged: (val) => _password = val,
        validator: (val) {
          if (val!.length < 8) {
            return 'Password should contain at least 8 characters';
          }
          return null;
        },
        obscureText: !_showPassword,
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: 360, // Fixed width
        height: 48, // Fixed height
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: _save,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center, // Align text to center
          ),
        ),
      ),
    );
  }

}

class InputField extends StatelessWidget {
  final void Function(String?) onChanged;
  final String? Function(String?) validator;
  final String labelText;
  final bool? obscureText;

  const InputField({
    super.key,
    required this.onChanged,
    required this.validator,
    required this.labelText,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 2)),
        floatingLabelStyle: const TextStyle(color: Colors.orange),
        filled: true,
        fillColor: const Color.fromARGB(255, 41, 41, 43),
        label: Text(labelText),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
