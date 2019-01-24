import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/app_state.dart';

class AppStateContainer extends StatefulWidget {
  // 전체 스테이트 관리하는 컨테이너 이므로, 앱의 메인 위젯을 child로 받는다.
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
    // 단순히 InheritedWidget을 리턴 한다.
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    // 다른 앱의 위치에서 새롭게 copy 한 경우 init을 두번 하지 않도록 처리
    if (widget.state != null) {
      state = widget.state;
    } else {
      // 처음 생성된 state일 경우 로그인을 진행한다.
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
      // google 로그인 완료 된 루틴을 여기에 추가하면 됨.
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
  // 앱 내에서 전체적으로 공유할 데이터가 state 이므로
  // _AppStateContinaerState를 data로 사용한다.
  // 변수명을 다르게 지정해도 상관없다.
  // 다른 변수를 추가해서 다르게 사용해도 된다.

  // InheritedWidget 은 단순히 내부 정보 공유만을 진행하므로
  // child를 그대로 전달 하는 역할을 한다.
  final _AppStateContainerState data;
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }): super(key: key, child: child);

  // 내부에서 관리하는 state가 바꼈을 때 render 다시 할 지 말지 결정
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
