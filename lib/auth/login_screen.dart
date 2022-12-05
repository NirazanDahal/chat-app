import 'package:chat_app/auth/signup_screen.dart';
import 'package:chat_app/chat/chat_screen.dart';
import 'package:chat_app/main.dart';
// import 'package:chat_app/todopages/home_page.dart';
// import 'package:chat_app/home/home_page.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isObscure = true;

  _loginUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        Navigator.of(AppSettings.navigatorKey.currentContext!)
            .pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => const ChatScreen()),
                (route) => false);
        showSuccessSnack("Logged in successfully");
        Navigator.of(AppSettings.navigatorKey.currentContext!)
            .pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
                (route) => false);
      } else {
        showErrorSnack("Something went wrong");
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Login"),
      // ),
      body: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Email"),
                validator: (value) {
                  if (value != null &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return null;
                  } else {
                    return "Please enter a valid email.";
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                keyboardType: TextInputType.number,
                obscureText: _isObscure,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure ? _isObscure = false : _isObscure = true;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye))),
                controller: _passwordController,
                validator: (value) {
                  if (value != null && value.length > 7) {
                    return null;
                  } else {
                    return "Password should be of minimum 8 characters.";
                  }
                },
              ),
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 223, 146, 123),
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  _loginUser(_emailController.text, _passwordController.text);
                }
              },
              child: const Text(
                "Login",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have an account? Sign up.",
                style: TextStyle(color: Color.fromARGB(255, 218, 205, 205)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
