import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

// 최상위 view 를 표시할 루트 위젯
class AppRootWidget extends StatefulWidget {
  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => ThemeData(
    primaryColor: Colors.cyan,
    accentColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[300],
  );

  @override
  Widget build(BuildContext context) {
    // 단순 메테리얼 앱을 사용한다.
    return MaterialApp(
      title: 'Inherited',
      theme: _themeData,
      // 네비게이션 할 때 사용할 다양한 루틴들.
      // 이 앱에서는 routes를 정해 놨찌만 별걸 하지 않고 끝낸다.
      // 기본 예제의 '/auth' 를 사용하지 않으므로 삭제 하였다.
      routes: {
        '/': (BuildContext context) => HomeScreen(),
      },
    );
  }
}
