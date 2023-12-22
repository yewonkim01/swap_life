import 'package:flutter/material.dart';

class AlertFriendDialog extends StatelessWidget {
  const AlertFriendDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.close),
      ),
    ));
  }
}
