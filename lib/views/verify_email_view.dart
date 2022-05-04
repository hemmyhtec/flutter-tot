import 'package:flutter/material.dart';
import 'package:newnotes/constants/routes.dart';
import 'package:newnotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification, check your email for verification"),
          const Text(
              "If you haven't received a verification email yet, press the below button"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
              // final user = AuthService.firebase().currentUser;
              // final user = FirebaseAuth.instance.currentUser;
              // await user?.sendEmailVerification();
            },
            child: const Text('Send Verification Email'),
          ),
          TextButton(
            onPressed: () async {
              // await FirebaseAuth.instance.signOut();
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
