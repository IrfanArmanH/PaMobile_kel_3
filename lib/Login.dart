import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_pa/bottomnavigationBar.dart';
import 'package:test_pa/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("User Logged In: ${userCredential.user!.email}");

      // Menentukan halaman tujuan berdasarkan email
      String userEmail = userCredential.user!.email!;
      Widget destinationPage;
      destinationPage = BottomNavScreen();
      // Menampilkan notifikasi saat berhasil login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, $userEmail!"),
        ),
      );

      // Pindah ke halaman yang sesuai
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationPage,
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gagal Login"),
            content: Text("Periksa Email Atau Password Anda"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print("Error During Logged In: $e");
    }
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    double getButtonWidth() {
      return screenWidth > 600 ? 200 : screenWidth * 0.8;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login', 
        style: TextStyle(color: Color(0xFFFDF4F5))),
        backgroundColor: Color(0xFF2A2F4F),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF2A2F4F),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"
                    ,labelStyle: TextStyle(color: Color(0xFFFDF4F5)),
                    
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Color(0xFFFDF4F5)),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your password";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF917FB3)),
                    minimumSize:
                        MaterialStateProperty.all(Size(getButtonWidth(), 50)),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Color(0xFFFDF4F5)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an Account? Sign Up",
                    style: TextStyle(
                      color: Colors.black,
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
}
