import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runo_music/tab_screen.dart';

import '../Helper/deviceParams.dart';


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

  int _selectedRadioVal = 1;

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
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>TabScreen()));
        }
        on FirebaseAuthException catch(error)
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message!)));
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Center(child: const Text("Runo Music", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400, fontSize: 25),)),

          const SizedBox(height: 40,),
          Padding(
            padding:  EdgeInsets.only(left: 20),
            child: const Text("Welcome", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400, fontSize: 20),),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white)
              ),
              width: 400,
              height: 330,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: authKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          margin: EdgeInsets.all(0),
                          color: _selectedRadioVal==0 ? Colors.black87 : Colors.grey,
                          child: RadioListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: Text("Create account", style: TextStyle(color: Colors.white),),
                            activeColor: Colors.orange,
                              value: 0,
                              groupValue: _selectedRadioVal,
                              onChanged: (val){setState(() {
                                _selectedRadioVal = val!;
                              });}
                          ),
                        ),

                        if(_selectedRadioVal==0)
                          InputField(
                            labelText: "Email",
                            onChanged: (val){
                              _email = val;
                            },
                            validator: (val) {
                              if(!(val!.contains('@gmail.com')))
                              {
                                return 'Email must contain @gmail.com';
                              }
                              return null;
                            },
                          ),

                        if(_selectedRadioVal==0)
                          const SizedBox(height: 20,),

                        if(_selectedRadioVal==0)
                          InputField(
                              labelText: "Password",
                              onChanged: (val){
                                _password = val;
                              },
                              validator: (val)
                              {
                                if(val!.length<8)
                                  return 'Password should contain atleast 8 letters';
                                return null;
                              },
                              obscureText:true
                          ),

                        if(_selectedRadioVal==0)
                        const SizedBox(height: 20,),

                        if(_selectedRadioVal==0)
                        FilledButton(
                            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary)),
                            onPressed: ()
                            {
                              setState(() {
                                signUp = true;
                                save();
                              });

                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 130,),
                              child: Text("Sign Up",style: TextStyle(color: Colors.black87),),
                            )
                        ),

                        const SizedBox(height: 20,),
                        
                        Card(
                          margin: EdgeInsets.all(0),
                          color: _selectedRadioVal==1 ? Colors.black87 : Colors.grey,
                          child: RadioListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text("Sign in", style: TextStyle(color: Colors.white),),
                              activeColor: Colors.orange,
                              value: 1,
                              groupValue: _selectedRadioVal,
                              onChanged: (val){setState(() {
                                _selectedRadioVal = val!;
                              });}
                          ),
                        ),

                        if(_selectedRadioVal==1)
                        InputField(
                          labelText: "Email",
                            onChanged: (val){
                              _email = val;
                              },
                            validator: (val) {
                              if(!(val!.contains('@gmail.com')))
                              {
                                return 'Email must contain @gmail.com';
                              }
                              return null;
                            },
                        ),

                        if(_selectedRadioVal==1)
                        SizedBox(height: 20,),


                        if(_selectedRadioVal==1)
                        InputField(
                          labelText: "Password",
                          onChanged: (val){
                            _password = val;
                          },
                          validator: (val)
                          {
                            if(val!.length<8)
                              return 'Password should contain atleast 8 letters';
                            return null;
                          },
                          obscureText:true
                        ),

                        if(_selectedRadioVal==1)
                        const SizedBox(height: 20,),

                        if(_selectedRadioVal==1)
                        FilledButton(
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary)),
                            onPressed: ()
                            {
                              setState(() {
                                signIn = true;
                                save();
                              });

                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 130,),
                              child: Text("Sign In",style: TextStyle(color: Colors.black87),),
                            )
                        ),
                        // SizedBox(height: 20,),
                        // Row(
                        //   children: [
                        //     Text("Don't have an account?"),
                        //     TextButton(onPressed: (){},
                        //         child: Text("Sign Up now", style: TextStyle(color: Colors.orange),)
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class InputField extends StatelessWidget {

  final void Function(String?) onChanged;
  final String? Function(String?) validator;
  final bool? obscureText;
  final String labelText;
  const InputField({super.key, required this.onChanged, required this.validator,required this.labelText, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onChanged: onChanged,
      decoration:InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2)
          ),
          floatingLabelStyle:TextStyle(color: Colors.orange),
          filled: true,
          fillColor: Color.fromARGB(255, 41, 41, 43),
          label: Text("$labelText"),
          border: OutlineInputBorder(),
      ),
      obscureText: obscureText??false,
    );
  }
}

