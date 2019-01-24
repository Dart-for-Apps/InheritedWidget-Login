import 'package:flutter/material.dart';
import 'app.dart';
import 'app_state_container.dart';

void main() => runApp(
  // 로그인 정보를 최상위 위젯에 포함 시켜 놓는다.
  // 이후 inherit 정보를 통해 사용한다.
  AppStateContainer(
    child: AppRootWidget(),
  )
);
