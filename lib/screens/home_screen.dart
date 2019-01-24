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
      return _loadingView;
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get _homeView {
    // 잘못된 부분 정정
    return Center(child: AuthScreen());
  }
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    appState = container.state;

    Widget body = _pageToDisplay;

    return Scaffold(
      appBar: AppBar(
        title: Text('Suite'),
      ),
      body: body,
    );
  }
}
