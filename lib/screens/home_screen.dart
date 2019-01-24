import 'package:flutter/material.dart';
import 'package:inherited_login/models/app_state.dart';
import 'package:inherited_login/app_state_container.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppState appState;

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      // 앱 전체 스테이트 로그인 loading 중인경우 loading view
      return _loadingView;
    } else {
      // 로딩이 끝난 경우 정상 뷰
      return _homeView;
    }
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get _homeView {
    // 로그인 되어 있지 않는 경우 로그인 화면으로
    // 로그인 되어 있는 경우 유저 이름 출력화면으로
    return Center(
      child: appState.user == null
          ? AuthScreen()
          : Text('User is ${appState.user.displayName}'),
    );
  }
  @override
  Widget build(BuildContext context) {
    // 앱 전체 스테이트 컨테이너 획득
    var container = AppStateContainer.of(context);
    appState = container.state;

    // 현재 state 에 따라서 어떤 뷰를 보여줄 지 결정
    Widget body = _pageToDisplay;

    return Scaffold(
      appBar: AppBar(
        title: Text('Suite'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          container.logout();
        },
        child: Text('Logout'),
      ),
    );
  }
}
