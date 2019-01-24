import 'package:flutter/material.dart';
import '../app_state_container.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // 실제 로그인을 담당하는 container를 가져온다.
    // 해당 컨테이너는 최상위 root widget 이므로 어느 context로든 가져올 수 있다.
    final container = AppStateContainer.of(context);
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: (){
              // 앱 전체 컨테이너의 login 루틴을 따르도록 호출
              container.logIntoFirebase();
            },
            color: Colors.white,
            child: Container(
              width: 230.0,
              height: 50.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Image.asset('images/google-signin.png', width: 30.0,),
                  ),
                  Text(
                    'Sign in with Google',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
