import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink{
  void buildDynamicLink(String code) async{
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://swaplife.page.link/friends?code=${code}'),
        uriPrefix: 'https://swaplife.page.link',
        androidParameters: AndroidParameters(packageName: "com.example.swap_life")
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
  }


}