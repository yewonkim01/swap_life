import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_share.dart';
import 'messageTemplate.dart';
import 'log.dart';
import 'dynamicLink.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;


const String tag = 'SwapLife';
kakao.User ? user;

class KakaoShareManager{
  final TodoController controller;
  KakaoShareManager({required this.controller});

  Future<bool> isKakaoTalkInstalled() async{
    bool installed = await ShareClient.instance.isKakaoTalkSharingAvailable();
    return installed;
  }

  void ShareWithKaKaoTalk(BuildContext context) async{
    user = await kakao.UserApi.instance.me();
    Uri dynamicLink = await DynamicLink(controller, context).buildDynamicLink(user!.id.toString());
    final nickname = user!.kakaoAccount!.profile!.nickname;
    TextTemplate template = createTemplate(dynamicLink, nickname!);
    try{
      //카카오톡 공유 uri(메시지를 공유하는 화면으로 이동) 생성
      Uri uri = await ShareClient.instance.shareDefault(template: template);
      //공유하기 실행
      await ShareClient.instance.launchKakaoTalk(uri);
      Log.d(context, tag, '카카오톡 공유 성공');
    }catch (e){
      Log.e(context, tag, '카카오톡 공유 실패', e);
    }
  }
}

class KakaoShareButton extends StatelessWidget {
  final TodoController controller;
  KakaoShareButton({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment(3, -0.85),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: SizedBox(
        height: 35,
        child: TextButton(
          // style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
          child: Text('카카오톡으로 친구 초대 요청 보내기', style: TextStyle(color: Colors.black)),
          onPressed: () async{
            final installed = await KakaoShareManager(controller: controller).isKakaoTalkInstalled();
            if (installed){
              Log.i(context, tag, '[카카오톡 공유 가능]\n카카오톡과 연결합니다');
              KakaoShareManager(controller: controller).ShareWithKaKaoTalk(context);
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('친구에게 친구 요청을 보냈습니다.')));
            }else{
              Log.i(context, tag, '[카카오톡 공유 불가]\n카카오톡이 설치되어 있지 않아 카카오톡에 연결할 수없습니다.\n카카오톡 설치 후 다시 진행해주세요.');
            }
          },
        ),
      ),
    );
  }
}
