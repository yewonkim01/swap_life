import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;


class getList {
  kakao.User? user;
  final profile = FirebaseFirestore.instance;
  List MBTI = [];
  List<String> MBTIList = [];
  List<int> EmoticonList = [];
  double E=0,I=0,F=0,T=0,S=0,N=0,P=0,J=0;
  int E_num=0 ,I_num=0, F_num=0,T_num=0 ,S_num=0, N_num=0,P_num=0 ,J_num=0;

  Future<void> getProfile() async {
    user = await kakao.UserApi.instance.me();
    DocumentSnapshot getprof =
    await profile.collection('checklist').doc(user!.id.toString()).get();

    //여기다가 친구의 체크리스트 추가 하면 댐.
    List<Map<String, dynamic>>? userChecklistList =
    List<Map<String, dynamic>>.from(getprof['user_checklist']);
    if (userChecklistList != null) {
      for (var userChecklist in userChecklistList) {
        if (userChecklist['MBTI'] != null && userChecklist['emoticon'] != null) {
          MBTIList.add(userChecklist['MBTI']);
          if (userChecklist['emoticon'] is List<int>) {
            EmoticonList.add(List<int>.from(userChecklist['emoticon']) as int);
          }
        }
      }
    }
  }

  void processList() {
    for (int i = 0; i < MBTIList.length; i++) {
      switch (MBTIList[i]) {
        case 'E':
          E = E + EmoticonList[i];
          E_num++;
          break;
        case 'I':
          I = I + EmoticonList[i];
          I_num++;
          break;
        case 'F':
          F = F + EmoticonList[i];
          F_num++;
          break;
        case 'T':
          T = T + EmoticonList[i];
          T_num++;
          break;
        case 'S':
          S = S + EmoticonList[i];
          S_num++;
          break;
        case 'N':
          N = N + EmoticonList[i];
          N_num++;
          break;
        case 'P':
          P = P + EmoticonList[i];
          P_num++;
          break;
        case 'J':
          J = J + EmoticonList[i];
          J_num++;
          break;
      }
    }
  }

  finalMBTI() {
    if (E > I) {
      E >75 ? MBTI[0] = 'E' : MBTI[0]= 'e';
    }
    if (I > E) {
      I >75 ? MBTI[0] = 'I' : MBTI[0]= 'i';
    }
    if (F > T) {
      F >75 ? MBTI[0] = 'F' : MBTI[0]= 'f';
    }
    if (T > F) {
      T >75 ? MBTI[0] = 'T' : MBTI[0]= 't';
    }
    if (S > N) {
      S >75 ? MBTI[0] = 'S' : MBTI[0]= 's';
    }
    if (N > S) {
      N >75 ? MBTI[0] = 'N' : MBTI[0]= 'n';
    }
    if (P > J) {
      P >75 ? MBTI[0] = 'P' : MBTI[0]= 'p';
    }
    if (J > P) {
      J >75 ? MBTI[0] = 'J' : MBTI[0]= 'j';
    }
    E = (E_num != 0) ? (E / E_num).toDouble() : 0;
    I = (I_num != 0) ? (I / I_num).toDouble() : 0;
    N = (N_num != 0) ? (N / N_num).toDouble() : 0;
    S = (S_num != 0) ? (S / S_num).toDouble() : 0;
    F = (F_num != 0) ? (F / F_num).toDouble() : 0;
    T = (T_num != 0) ? (T / T_num).toDouble() : 0;
    P = (P_num != 0) ? (P / P_num).toDouble() : 0;
    J = (J_num != 0) ? (J / J_num).toDouble() : 0;
  }

  String? getMBTI(){
    String result = MBTIList.join(',');
    print(result);
    return result;
  }
}

