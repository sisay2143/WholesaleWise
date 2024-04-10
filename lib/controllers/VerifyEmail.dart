// import 'package:flutter/material.dart';

// class VerifyEmail extends StatefulWidget {
//   const VerifyEmail({super.key});

//   @override
//   State<VerifyEmail> createState() => _VerifyEmailState();
// }

// class _VerifyEmailState extends State<VerifyEmail> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(title: Text('Verify Email')) ,
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Views/login.dart';
import 'package:untitled/main.dart';
// import 'package:un/extensions/buildcontext/loc.dart';
// import 'package:untitled/services/auth/bloc/auth_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(context.loc.verify_email),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(
    //             context.loc.verify_email_view_prompt,
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             context.read<AuthBloc>().add(
    //                   const AuthEventSendEmailVerification(),
    //                 );
    //           },
    //           child: Text(
    //             context.loc.verify_email_send_email_verification,
    //           ),
    //         ),
    //         TextButton(
    //           // onPressed: () async {
    //           //   context.read<AuthBloc>().add(
    //           //         // const AuthEventLogOut(),
    //           //       );
    //           // },
    //           child: Text(
    //             context.loc.restart,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginView()), // Replace LoginPage with the actual name of your login page class
            );
          }
        ),
      ),

      body: Column(children: [
        const Text('Please verify your email address'),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send email verification'))
      ]
      ),
    );
  }
}
