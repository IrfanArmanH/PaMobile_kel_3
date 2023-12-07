import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();
  String _displayName = '';
  String _email = '';
  String _password = '';
  String _city = '';
  String _tanggalLahir = '';

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      // Adding displayName, city, and tanggal_lahir to user information
      await userCredential.user!.updateProfile(displayName: _displayName);

      // Saving user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'image': '',
        'email': _email,
        'displayName': _displayName,
        'city': _city,
        'tanggal_lahir': _tanggalLahir,
      });

      print("User Registered: ${userCredential.user!.email}");

      // Showing a notification when the account is successfully created
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Successful"),
            content: Text("Your account has been successfully created."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate back to the login page
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Showing an error message when registration fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Failed"),
            content: Text(
                "An error occurred while creating the account. Please try again."),
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
      print("Error During Registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var orangeColor = Color(0xFF2A2F4F);
    var yellowColor = Color(0xFF2A2F4F);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: orangeColor,
        centerTitle: true,
      ),
      backgroundColor: yellowColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Display Name",
                      filled: true,
                      fillColor: Color(0xFF917FB3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your display name";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _displayName = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "City",
                      filled: true,
                      fillColor: Color(0xFF917FB3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your city";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _tanggalLahirController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Birthdate (YYYY-MM-DD)",
                      filled: true,
                      fillColor: Color(0xFF917FB3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your birthdate";
                      }
                      // Validate the birthdate format (e.g., YYYY-MM-DD)
                      RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!datePattern.hasMatch(value)) {
                        return "Invalid date format (YYYY-MM-DD)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _tanggalLahir = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      filled: true,
                      fillColor: Color(0xFF917FB3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      filled: true,
                      fillColor: Color(0xFF917FB3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Use 6 characters or more for your password";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _handleSignUp();
                      }
                    },
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      primary: orangeColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
