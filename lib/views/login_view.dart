import 'package:flutter/material.dart';
import 'package:newnotes/constants/routes.dart';
import 'package:newnotes/services/auth/auth_exceptions.dart';
import 'package:newnotes/services/auth/auth_service.dart';
import 'package:newnotes/ultilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter a valid Email'),
          ),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter a valid Password')),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                //  FirebaseAuth.instance.signInWithEmailAndPassword(
                //   email: email,
                //   password: password,
                // );
                // final user = FirebaseAuth.instance.currentUser;
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //users email is NOT verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
                // devtools.log(userCredential.toString());
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong credentails',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'user-not-found') {
              //     // devtools.log('User not found');

              //   } else if (e.code == 'wrong-password') {
              //     // devtools.log('Password Incorrect');

              //   } else {
              //     // devtools.log('Something Went wrong');
              //     // devtools.log(e.code);
              //     await showErrorDialog(
              //       context,
              //       'Error: ${e.code}',
              //     );
              //   }
              // } catch (e) {
              //   // devtools.log('something bad happened');
              //   // devtools.log(e.runtimeType.toString());
              //   // devtools.log(e.toString());
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }),
              child: const Text('Not Registered yet? Register here!'))
        ],
      ),
    );
  }
}
