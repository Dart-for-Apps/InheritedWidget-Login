import 'package:firebase_auth/firebase_auth.dart';

// 앱의 전체에서 공유되는 스테이트를 관리할 클래스
// 앱에 따라서 이곳에 더 많은 스테이트를 추가해도 되고, 빼도 된다.
class AppState {
  bool isLoading;
  FirebaseUser user;

  AppState({
    this.isLoading = false,
    this.user,
  });

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }


}