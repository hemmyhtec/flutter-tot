import 'package:flutter/material.dart';
import 'package:newnotes/constants/routes.dart';
import 'package:newnotes/services/auth/auth_exceptions.dart';
import 'package:newnotes/services/auth/auth_service.dart';
import 'package:newnotes/ultilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //   email: email,
                //   password: password,
                // );
                // final user = FirebaseAuth.instance.currentUser;
                AuthService.firebase().sendEmailVerification();
                // await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
                // devtools.log(userCredential.toString());
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak Password',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email already in use',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid Email',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
                // } on FirebaseAuthException catch (e) {
                //   if (e.code == 'weak-password') {
                //     // devtools.log('Weak Password');
                //     await showErrorDialog(
                //       context,
                //       'Weak Password',
                //     );
                //   } else if (e.code == 'email-already-in-use') {
                //     // devtools.log('Email already in use');
                //     await showErrorDialog(
                //       context,
                //       'Email already in use',
                //     );
                //   } else if (e.code == 'invalid-email') {
                //     // devtools.log('Invalid email');
                //     await showErrorDialog(
                //       context,
                //       'Invalid Email',
                //     );
                //   } else {
                //     await showErrorDialog(
                //       context,
                //       'Error: ${e.code}',
                //     );
                //   }
                // } catch (e) {
                //   await showErrorDialog(
                //     context,
                //     e.toString(),
                //   );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login Here'))
        ],
      ),
    );
  }
}
