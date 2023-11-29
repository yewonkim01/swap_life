import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class SocialLogin {
  Future<bool> login();
  Future<bool> logout();
}

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      //카카오톡이 설치되어있는지 확인
      bool isInstalled = await isKakaoTalkInstalled();
      if(isInstalled){
        try{
          //카카오톡으로 로그인
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch(error) {
          return false;
        }
      } else {
        try{
          //카카오톡 계정으로 로그인
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch(error) {
          return false;
        }
      }
    } catch(error) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      //카카오톡과의 연결을 끊는다.
      await UserApi.instance.unlink();
      return true;
    } catch(error) {
      return false;
    }
  }
}
