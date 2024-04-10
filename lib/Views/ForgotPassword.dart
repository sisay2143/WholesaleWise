// import 'package:flutter/material.dart';

// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({super.key});

//   @override
//   State<ForgetPassword> createState() => _ForgetPasswordState();
// }

// class _ForgetPasswordState extends State<ForgetPassword> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _email = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

//  Future PasswordReset() async{
// try{
//   await FirebaseAuth.instance.sendPasswordResetEmail(
//       email:_email.text.trim());
//   showDialog(
//       context: context,
//       builder:(context) {
//         return AlertDialog(
//           content: Text('Password reset link sent! Go check your email'),
//         );
//       });
// }on FirebaseAuthException catch(e){
//   print(e);
//   showDialog(
//   context: context,
//       builder:(context) {
//     return AlertDialog(
//       content: Text(e.message.toString()),
//     );
//   });
// }
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Text(
              'Reset Password Screen',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 47,
          ),
          Text(
            'Please enter your email here .',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 19,
            ),
          ),
          SizedBox(
            height: 47,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:const  InputDecoration(
                prefixIcon:Icon(
                  Icons.email,
                  color: Colors.blue,
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 4,
                      color: Colors.deepPurpleAccent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                hintText: 'Enter your Email Here',
                hintStyle: const TextStyle(color: Colors.deepPurpleAccent),
              ),
            ),
          ),
         const  SizedBox(
            height: 12,
          ),
          MaterialButton(
            onPressed: () {},
            child: Text(
              '𝑹𝒆𝒔𝒆𝒕 𝑷𝒂𝒔𝒔𝒘𝒐𝒓𝒅',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.deepPurple,
          )
        ],
      ),
    );
  }
}
