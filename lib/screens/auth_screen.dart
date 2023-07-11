import 'package:flutter/material.dart';
import 'package:model_firebase/firebase/auth_firebase.dart';
import 'package:model_firebase/firebase/model_out_message.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  resetPass()async{
   OutMessage response = await AuthFirebase().forgetPassword('kassm7md.1@gmail.com');
   if(response.status){
     print(response.message);
   }else{
     print(response.message);
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: ElevatedButton(onPressed: (){
              resetPass();
            }, child: Text('reset')))
          ],
        )
    );
  }

  platformAnonymousLogin() {
    if (checkData()) {
      login();
    }
  }

  bool checkData() {
    if (globalKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  login() async {
    var response = await AuthFirebase().signInWithGoogle();
    if (response.status!) {
      showSnackBar(message: '${response.message}', status: true);
      // navigator screen
    } else {
      showSnackBar(message: '${response.message}', status: false);
    }
  }

  showSnackBar({required String message, bool status = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: 1),
          content: Text('$message'),
          backgroundColor: status ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating),
    );
  }
}
