import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routers.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Email Here'),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter Your Password Here'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(context, "Error: User Not Found");
                  } else if (e.code == 'invalid-credential') {
                    await showErrorDialog(context, "Error: Wrong Credentials");
                  } else {
                    await showErrorDialog(
                        context, "Error: An unknown error occurred ${e.code}");
                  }
                } catch (e) {
                  await showErrorDialog(
                      context, "${e.toString()}\nPlease try again.");
                }
              },
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registrationRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}
