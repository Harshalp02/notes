import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/auth_exception.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';
// import 'package:notes/utilities/dialogs/loading_dailog.dart'; 


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  // CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLoggedOut) {
          // final closeDialog = _closeDialogHandle;
          // if (!state.isLoading && closeDialog != null) {
          //   closeDialog();
          //   _closeDialogHandle = null;
          // } else if (state.isLoading && closeDialog == null) {
          //   _closeDialogHandle =
          //       showLoadingDialog(context: context, text: 'Loading....');
          // }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, "user not Found");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, "Wrong credentials");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication Error");
          }
        }
      },
      child: Scaffold(
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
                  onPressed: () {
                    final email = _email.text;
                    final password = _password.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventLogIn(email, password));
                    //   try {

                    //     await AuthService.firebase()
                    //         .logIn(email: email, password: password);
                    //     final user = AuthService.firebase().currentUser;
                    //     if (user?.isEmailVerified ?? false) {
                    //       Navigator.of(context)
                    //           .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    //     }
                    //   } on UserNotFoundAuthException {
                    //     await showErrorDialog(context, "Error: User Not Found");
                    //   } on WrongPasswordAuthException {
                    //     await showErrorDialog(context, "Error: Wrong Credentials");
                    //   } on GenericAuthException {
                    //     await showErrorDialog(
                    //         context, "Error: Authentication Error");
                    //   }
                  },
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     registrationRoute, (route) => false);
                },
                child: const Text('Not Registered yet? Register here!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
