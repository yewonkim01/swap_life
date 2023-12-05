import 'package:kakao_flutter_sdk/kakao_flutter_sdk_template.dart';

TextTemplate createTemplate(Uri link, String nickname){
    final TextTemplate Template = TextTemplate(
        buttonTitle: '친구 요청 수락',
        text: 'SwapLife에서 ${nickname}님이 친구가 되고싶어해요. 친구를 맺고 김예원님의 일상 체크리스트를 확인해보세요!',
        link: Link(
            mobileWebUrl: link
        )
    );
    return Template;
}
