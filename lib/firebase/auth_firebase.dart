import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:model_firebase/firebase/model_out_message.dart';

class AuthFirebase {
  FirebaseAuth instance = FirebaseAuth.instance;

  // anonymous SignIn
  Future<OutMessage> anonymousSignIn() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return OutMessage(message: 'success login', status: true);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          return OutMessage(
              message: 'Anonymous auth hasn\'t been enabled for this project.',
              status: true);
        default:
          return OutMessage(message: '${e.message}', status: true);
      }
    }
  }

  /*create user*/
  Future<OutMessage> createUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user!.sendEmailVerification();
      return OutMessage(status: true, message: 'send verification to email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return OutMessage(status: false, message: '');
      } else if (e.code == 'email-already-in-use') {
        return OutMessage(status: false, message: 'email-already-in-use');
      } else {
        return OutMessage(status: false, message: '${e.message}');
      }
    } catch (e) {
      return OutMessage(status: false, message: 'Unknown error $e');
    }
  }

  /*sign in with user*/
  Future<OutMessage> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.emailVerified) {
        return OutMessage(status: true, message: 'logged success');
      } else {
        // credential.user!.sendEmailVerification();
        return OutMessage(status: false, message: 'email not verification');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return OutMessage(
            status: false, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return OutMessage(
            status: false, message: 'Wrong password provided for that user.');
      } else {
        return OutMessage(status: false, message: '${e.message}');
      }
    } catch (e) {
      return OutMessage(status: false, message: 'Unknown error $e');
    }
  }


  /*google signIn*/
  Future<OutMessage> signInWithGoogle() async {
    // generate sha_1;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return OutMessage(status: true, message: 'logged success');
    } on FirebaseAuthException catch (e) {
      return OutMessage(status: false, message: 'logged failed');
    } catch (e) {
      return OutMessage(status: false, message: '$e');
    }
  }

  /*forget password*/
  Future<OutMessage>forgetPassword(String email)async{
    try{
      await instance.sendPasswordResetEmail(email: email);
      return OutMessage(status: true, message: 'success reset password');
    }catch(e){
      return OutMessage(status: false, message: '$e');
    }
  }

  /*signIn with phone*/
  Future<OutMessage>signInWithPhone(String phoneNumber)async{
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return OutMessage(status: true, message: 'success login with phone');
    }catch(e){
      return OutMessage(status: false, message: '$e');
    }
  }

  /*logout*/
  Future<void> logout() async {
    await instance.signOut();
  }

  bool get isLogged => instance.currentUser != null ;

}
