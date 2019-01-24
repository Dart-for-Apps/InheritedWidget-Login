import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/app_state.dart';

class AppStateContainer extends StatefulWidget {
  final Widget child;
  final AppState state;

  AppStateContainer({
    @required this.child,
    this.state,
  });
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer).data;
  }
  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = AppState.loading();
      initUser();
    }
  }

  GoogleSignInAccount googleUser;
  final googleSIgnIn = GoogleSignIn();
  Future<Null> initUser() async {
    googleUser = await _ensureLoggedInOnStartUp();
    if (googleUser == null) {
      // 자동 로그인 안된 상태 인 경우 루틴
      setState(() {
        state.isLoading = false;
      });
    } else {
      // 로그인 완료 된 루틴을 여기에 추가하면 됨.
      await logIntoFirebase();
    }
  }

  Future<GoogleSignInAccount> _ensureLoggedInOnStartUp() async {
    // 이미 로그인 된 정보가 기기에 남아있는지 확인.
    GoogleSignInAccount user = googleSIgnIn.currentUser;
    if (user == null) {
      // 자동 로그인 시도함.
      // 이것도 실패 할 수도 있으므로 user를 받아서 사용하는 곳에서
      // 알아서 null 처리를 해야함.
      user = await googleSIgnIn.signInSilently();
    }

    googleUser = user;
    return user;
  }

  Future<Null> logIntoFirebase() async {
    if (googleUser == null) {
      googleUser = await googleSIgnIn.signIn();
    }
    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      firebaseUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('Logged in with ${firebaseUser.displayName}');

      setState(() {
        state.isLoading = false;
        state.user = firebaseUser;
      });
    } catch (error) {
      print(error);
      return null;
    }
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }


}
