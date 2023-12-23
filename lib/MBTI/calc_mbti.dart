import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class getList {
  final String friendid;

  getList({
    required this.friendid
  });

  kakao.User? user;
  final profile = FirebaseFirestore.instance;
  List<String> MBTIList = [];
  List<double> EmoticonList = [];
  List<String> MBTI = [];
  String resultMBTI = "";
  double E = 0,
      I = 0,
      S = 0,
      N = 0,
      T = 0,
      F = 0,
      P = 0,
      J = 0;
  double E_num = 0,
      I_num = 0,
      S_num = 0,
      N_num = 0,
      T_num = 0,
      F_num = 0,
      P_num = 0,
      J_num = 0;

  Future<void> getProfile() async {
    user = await kakao.UserApi.instance.me();
    if (user != null) {
      DocumentSnapshot getprof = await profile
          .collection('checklist')
          .doc(user!.id.toString())
          .collection('friends')
          .doc(friendid)
          .get();

      var data = getprof.data() as Map<String, dynamic>;
      for (int i = 0; i < data.length; i++) {
        var itemKey = 'item_$i';
        if (data.containsKey(itemKey)) {
          var itemData = data[itemKey] as Map<String, dynamic>;
          if (itemData.containsKey('MBTI')) {
            var mbtiValue = itemData['MBTI'] as String;
            MBTIList.add(mbtiValue);
          }
          if (itemData.containsKey('intMBTI')) {
            var intMBITValue = itemData['intMBTI'] as int;
            EmoticonList.add(intMBITValue.toDouble());
          }
        }
      }
    }
  }

  Future<void> savemyChecklist() async {
    user = await kakao.UserApi.instance.me();
    DocumentReference Ref = profile.collection('checklist').doc(
        user!.id.toString())
        .collection('mychecklist').doc('allchecklist');
    DocumentSnapshot me = await Ref.get();

    if (me.data() == null) {
      await Ref.set(
          {
            "checklist_mbti": [resultMBTI]
          }
      );
    } else {
      await Ref.update(
          {
            "checklist_mbti": [resultMBTI]
          }
      );
    }
  }
    processList() async {
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
        E = (E_num != 0) ? (E / E_num).toDouble() : 0;
        I = (I_num != 0) ? (I / I_num).toDouble() : 0;
        N = (N_num != 0) ? (N / N_num).toDouble() : 0;
        S = (S_num != 0) ? (S / S_num).toDouble() : 0;
        F = (F_num != 0) ? (F / F_num).toDouble() : 0;
        T = (T_num != 0) ? (T / T_num).toDouble() : 0;
        P = (P_num != 0) ? (P / P_num).toDouble() : 0;
        J = (J_num != 0) ? (J / J_num).toDouble() : 0;
      }
    }

    finalMBTI() async {
      MBTI = [];
      if (E > I) {
        if (E > 75) {
          MBTI.add('E');
        }
        else
          MBTI.add('e');
      }
      if (I > E) {
        I > 75 ? MBTI.add('I') : MBTI.add('i');
      }
      if (S > N) {
        S > 75 ? MBTI.add('S') : MBTI.add('s');
      }
      if (N > S) {
        N > 75 ? MBTI.add('N') : MBTI.add('n');
      }
      if (F > T) {
        F > 75 ? MBTI.add('F') : MBTI.add('f');
      }
      if (T > F) {
        T > 75 ? MBTI.add('T') : MBTI.add('t');
      }
      if (P > J) {
        P > 75 ? MBTI.add('P') : MBTI.add('p');
      }
      if (J > P) {
        J > 75 ? MBTI.add('J') : MBTI.add('j');
      }
    }

    getMBTI() async {
      resultMBTI = MBTI.join();
      print(resultMBTI);
      savemyChecklist();
      return resultMBTI;
    }
  }

