import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_car_app_firebase/services/util.dart';

import 'db_service.dart';


class AuthService{
  static final auth = FirebaseAuth.instance;


  static Future<User?> signUpUser(BuildContext context,String name,String email,String password)async{
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;
      await auth.currentUser?.updateDisplayName(name);
      return user;
    }catch(e){
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<User?> signInUser(BuildContext context,String email,String password)async{
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }catch(e){
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<void> signOutUser(BuildContext context)async{
    await auth.signOut();
    DBService.removeUserId().then((value){});

  }
}