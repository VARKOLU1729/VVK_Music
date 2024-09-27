import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _isSignIn = true;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: const Text("Runo Music", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25))),
            const SizedBox(height: 40),
            const Text("Welcome", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20)),
            const SizedBox(height: 40),
            _buildAuthForm(),
          ],
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
          children: [
            _buildRadioTile("Create account", false),
            if (!_isSignIn) _buildUserNameField(),
            if (!_isSignIn) const SizedBox(height: 20),
            if (!_isSignIn) _buildEmailField(),
            if (!_isSignIn) const SizedBox(height: 20),
            if (!_isSignIn) _buildPasswordField(),
            if (!_isSignIn) const SizedBox(height: 20),
            if (!_isSignIn) _buildActionButton("Sign Up"),
            const SizedBox(height: 20),
            _buildRadioTile("Sign in", true),
            if (_isSignIn) _buildEmailField(),
            if (_isSignIn) const SizedBox(height: 20),
            if (_isSignIn) _buildPasswordField(),
            if (_isSignIn) const SizedBox(height: 20),
            if (_isSignIn) _buildActionButton("Sign In"),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title, bool isSignIn) {
    return Container(
      color: _isSignIn == isSignIn ? Colors.black87 : Colors.grey,
      child: RadioListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
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
        labelText: "UserName",
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
        labelText: "Email",
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
        labelText: "Password",
        onChanged: (val) => _password = val,
        validator: (val) {
          if (val!.length < 8) {
            return 'Password should contain at least 8 characters';
          }
          return null;
        },
        obscureText: true,
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
        ),
        onPressed: _save,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 125),
          child: Text(text, style: const TextStyle(color: Colors.black87)),
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
