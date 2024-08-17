import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routers.dart';
import 'package:notes/helpers/loading/loading_screen.dart';
import 'package:notes/services/auth/auth_services.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/services/auth/firbase_auth_provider.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes/create_update_note_view.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      // loginRoute: (context) => const LoginView(),
      // registrationRoute: (context) => const RegisterView(),
      // notesRoute: (context) => const NotesView(),
      // verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateOrUpdateNoteView(),
    },
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading, please wait...',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
      listener: (BuildContext context, AuthState state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
    );
    // return FutureBuilder(
    //     future: AuthService.firebase().initialize(),
    //     builder: (context, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           final user = AuthService.firebase().currentUser;
    //           if (user != null) {
    //             if (user.isEmailVerified) {
    //               return const NotesView();
    //             } else {
    //               return const VerifyEmailView();
    //             }
    //           } else {
    //             return const LoginView();
    //           }
    //         default:
    //           return const CircularProgressIndicator();
    //       }
    //     });
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text(
//               "Testing Bloc",
//               style: TextStyle(color: Colors.white),
//             ),
//             backgroundColor: Colors.blue,
//           ),
//           body: BlocConsumer<CounterBloc, CounterState>(
//             listener: (context, state) {
//               _controller.clear();
//             },
//             builder: (context, state) {
//               final invalidValue = (state is CounterStateInValidNumber)
//                   ? state.invalidValue
//                   : '';
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Current Value => ${state.value}',
//                     style: const TextStyle(fontSize: 30),
//                   ),
//                   Visibility(
//                     visible: state is CounterStateInValidNumber,
//                     child: Text('Invalid Input : $invalidValue'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(40.0),
//                     child: TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                           hintText: 'Enter a number here...'),
//                       keyboardType: TextInputType.number,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(DecrementEvent(_controller.text));
//                           },
//                           child: const Text(
//                             '-',
//                             style: TextStyle(fontSize: 40),
//                           )),
//                       TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(IncrementEvent(_controller.text));
//                           },
//                           child: const Text(
//                             '+',
//                             style: TextStyle(fontSize: 40),
//                           )),
//                     ],
//                   )
//                 ],
//               );
//             },
//           )),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(super.value);
// }

// class CounterStateInValidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInValidNumber(
//       {required this.invalidValue, required int previousValue})
//       : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(super.value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(super.value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInValidNumber(
//             invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInValidNumber(
//             invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }
