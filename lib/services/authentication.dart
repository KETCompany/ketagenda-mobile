import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:KETAgenda/components/basic_user_info.dart';
import 'package:KETAgenda/globals.dart' as globals;

class Authentication {

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<Null> handleSignOut() async {
    await _googleSignIn.signOut();
    globals.user = new BasicUserInfo();
  }

  Future<FirebaseUser> handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    String token = await user.getIdToken();
    print("Token from Firebase:");
    print(token);
    print("accessToken from googleAuth:");
    print(googleAuth.accessToken);
    print("idToken from googleAuth:");
    print(googleAuth.idToken);
    
    if(user.email != ""){
      if(user.email.split("@")[1] == "hr.nl"){
        globals.user.displayName = user.displayName; 
        globals.user.email = user.email; 
        globals.user.firebaseToken = token;

        // TODO: Send firebaseToken to API to get new API token
        // for now, we use the same token so we can pass the login screen.
        globals.user.apiToken = token;
      }
    }

    return user;
  }
}