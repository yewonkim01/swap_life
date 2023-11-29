import 'package:firebase_auth/firebase_auth.dart';
import 'package:swap_life/kakao_login/firebase_auth_remote_data.dart';
import 'login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  MainViewModel(this._socialLogin);

  List<String> scopes = [];

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        //'displayName': user!.kakaoAccount!.profile!.nickname!,
        'email': user!.kakaoAccount!.email!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    await FirebaseAuth.instance.signOut();
    isLogined = false;
    user = null;
  }
}