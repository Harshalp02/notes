import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/auth_exception.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, "Weak Password");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, "Email is already in use");
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, "Email is invalid");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Failed to register");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
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
                    const InputDecoration(hintText: 'Enter Your password Here'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventRegister(email, password));
                  //   try {
                  //     await AuthService.firebase()
                  //         .createUser(email: email, password: password);
                  //     await AuthService.firebase().sendEmailVerification();

                  //     Navigator.of(context).pushNamed(verifyEmailRoute);
                  //   } on WeakPasswordAuthException {
                  //     await showErrorDialog(context, 'Weak-password');
                  //   } on EmailAlreadyInUseAuthException {
                  //     await showErrorDialog(context, 'Email already in use');
                  //   } on InvalidEmailAuthException {
                  //     await showErrorDialog(context, 'Invalid Email');
                  //   } on GenericAuthException {
                  //     await showErrorDialog(context, 'Error: Failed To Register');
                  //   }
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Already register? Login here!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
