import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual_flutter/helpers/firebase_errors.dart';
import 'package:loja_virtual_flutter/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  late Users user;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn(
      {Users? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user!.email, password: user.password);

      this.user = result.user as Users;

      onSuccess!();
    } on PlatformException catch (e) {
      onFail!(getErrorString(e.code));
    }

    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final User? currentUser = auth.currentUser;
    if (currentUser != null) {
      user = currentUser as Users;
    }
    notifyListeners();
  }
}
