import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink{

  Future<Uri> buildDynamicLink() async{
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('https://swaplife.page.link/friends'),
        uriPrefix: 'https://swaplife.page.link',
        androidParameters: AndroidParameters(packageName: "com.example.swap_life")
    );

    Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    print('이게 다이나믹 링크 ${dynamicLink}');
    return dynamicLink;
  }




}