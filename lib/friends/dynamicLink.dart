import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';

class DynamicLink{
  Future<Uri> buildDynamicLink() async{
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://swaplife.page.link/friend'),
        uriPrefix: 'https://swaplife.page.link',
        androidParameters: AndroidParameters(packageName: "com.example.swap_life")
    );

    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    //print('이게 다이나믹 링크 ${dynamicLink}');
    return dynamicLink;
  }

  Future<Uri?> initDynamicLink(BuildContext context) async{
    Uri? deepLink;
    print('init');
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null){
      deepLink = initialLink.link;
      //Navigator.push(context, MaterialPageRoute(builder: (context) => FriendPage()));
      return deepLink;
    }
    print('init222');
    //다이나믹 링크로 앱이 열릴 때 리스너
    FirebaseDynamicLinks.instance.onLink.listen(
        (PendingDynamicLinkData? Dynamiclink) async{

          //앱이 다이나믹 링크로 열렸을 때의 처리
          if(Dynamiclink != null){
            print('init333');
            deepLink = Dynamiclink.link;
            // Navigator.pushNamed(context, '/friendScreen');
            // print('다이나믹 링크로 열림: ${deepLink}');
            // print('init444444');
          }
        },
    );
    return deepLink;

  }



}