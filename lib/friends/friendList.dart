import 'package:flutter/material.dart';
import 'KakaoTalkShare.dart';
import 'dynamicLink.dart';

class FriendList extends StatefulWidget {

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Text('Friend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black26),
              top: BorderSide(color: Colors.black26),
            )
          ),
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size: 50,),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size:50),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size:50),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size:50),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size:50),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: Icon(Icons.account_circle, color: Colors.black26,size:50),
                  ),
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width - 40,
                top: 20,
                child: GestureDetector(
                  onTap: (){
                    showDialog(
                      barrierColor: Colors.transparent,
                      barrierDismissible: true,
                        context: context,
                        builder: (context){
                        final d = DynamicLink();
                        d.buildDynamicLink();
                        return KakaoShareButton();
                        });
                  },
                  child: Container(
                    width: 30,
                    height: 37,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black54)
                    ),
                    child: Icon(Icons.add, color: Colors.black87,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
