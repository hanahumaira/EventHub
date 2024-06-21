import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/admin/admin_homepage.dart';
import 'package:eventhub/screen/forgot_password.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:eventhub/screen/signup/signup_screen.dart';
import 'package:eventhub/screen/user/user_homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key, Key? newKey});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null; // Reset error message before attempting to sign in
    });

    try {
      firebase_auth.UserCredential userCredential =
          await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      firebase_auth.User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('userData')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // Extracting user details from Firestore document
          final data = userSnapshot.data() as Map<String, dynamic>;

          // Navigate to the appropriate home page based on user type
          String accountType = data['accountType'];
          User passUser = User(
            name: data['name'],
            email: data['email'],
            password: data['password'],
            phoneNum: data['phoneNum'],
            accountType: accountType,
            address: data.containsKey('address') ? data['address'] : '',
            website: data.containsKey('website') ? data['website'] : '',
            sector: data.containsKey('sector') ? data['sector'] : '',
          );

          if (accountType == 'ADMIN') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomePage(passUser: passUser),
              ),
            );
          } else if (accountType == 'Organizer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrganiserHomePage(passUser: passUser, appBarTitle: 'Home'),
              ),
            );
          } else if (accountType == 'Participant') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(
                  passUser: passUser,
                  appBarTitle: 'Home',
                ),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'Invalid account type.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'User data not found in Firestore.';
          });
        }
      }
    } catch (e) {
      setState(() {
        if (e is firebase_auth.FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              _errorMessage = 'No user found for that email.';
              break;
            case 'wrong-password':
              _errorMessage = 'Incorrect password.';
              break;
            default:
              _errorMessage = 'Failed to sign in: ${e.message}';
          }
        } else {
          _errorMessage = 'Failed to sign in: $e';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 70),
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/images/mainpage.png',
                        height: 150,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Welcome to EventHub!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Password",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 100, 8, 222),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('LOGIN'),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(
                                    firestore: FirebaseFirestore.instance,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Create an account",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
