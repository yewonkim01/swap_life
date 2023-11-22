import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
import 'dart:core';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _selectedMBTI; //User MBTI
  TextEditingController _nameController = TextEditingController(); //User Name

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            imageProfile(),
            SizedBox(height:30),
            nameTextField(),
            introduction(),
            SizedBox(height: 80,),
            chooseMBTI(),
            selectedMBTI(),
            if (_selectedMBTI == null)
              SizedBox(height: 20,)
            else
              SizedBox(height: 10,),
            myReport(),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          (_imageFile==null) ? CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/profile.png')
          ) :
          CircleAvatar(
            radius: 80,
            backgroundImage: FileImage(File(_imageFile!.path)),
          ) ,
          Positioned(
            bottom:20,
            right: 20,
            child: InkWell(
              onTap:() {
                showModalBottomSheet(context: context, builder: ((builder)=> bottomSheet()));
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size:40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextField(){
    return TextFormField(
      controller: _nameController,
      maxLength: 10,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(
              color: Colors.black,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          labelText: 'Name',
          hintText: 'Input your name'
      ),
    );
  }
  String getName() {
    return _nameController.text;
  }

  Widget introduction() {
    return TextField(
      maxLength: 30,
      decoration: InputDecoration(
        hintText: 'introduction',
      ),
    );
  }

  Widget chooseMBTI() {
    return ElevatedButton(
      onPressed: () async {
        final selectedMBTI = await showModalBottomSheet(
          context: context,
          builder: (builder) => MBTI(),
        );
        if (selectedMBTI != null) {
          setState(() {
            _selectedMBTI = selectedMBTI;
          });
        }
      },
      child: Row(
        children: [
          Icon(Icons.edit),
          Text('                                    MBTI'),
        ],
      ),
    );
  }

  Widget selectedMBTI() {
    return _selectedMBTI != null
        ? Text(
      ' MBTI:  $_selectedMBTI',
      style: TextStyle(fontSize: 18,),
    )
        : Container(); // 선택된 MBTI가 없을 때는 빈 컨테이너 반환
  }

  Widget myReport() {
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(Icons.favorite),
          Text('                           My MBTI Report'),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
        height:100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Choose Profile photo',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.camera, size:35, color: Colors.deepPurple),
                  onPressed: () {takePhoto(ImageSource.camera);},
                  label: Text('Camera', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                TextButton.icon(
                  icon: Icon(Icons.photo_library,size:35, color: Colors.deepPurple),
                  onPressed: () {takePhoto(ImageSource.gallery);},
                  label: Text('Gallery',style: TextStyle(fontSize: 20, color: Colors.grey),),
                )
              ],
            )
          ],
        )
    );
  }

  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }
}

class MBTI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Text(
            'MBTI Selection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MBTITile(type: 'ISTJ'),
                      MBTITile(type: 'ISTP'),
                      MBTITile(type: 'ISFJ'),
                      MBTITile(type: 'ISFP'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MBTITile(type: 'INTJ'),
                      MBTITile(type: 'INTP'),
                      MBTITile(type: 'INFJ'),
                      MBTITile(type: 'INFP'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MBTITile(type: 'ESTJ'),
                      MBTITile(type: 'ESTP'),
                      MBTITile(type: 'ESFJ'),
                      MBTITile(type: 'ESFP'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MBTITile(type: 'ENTJ'),
                      MBTITile(type: 'ENTP'),
                      MBTITile(type: 'ENFJ'),
                      MBTITile(type: 'ENFP'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MBTITile extends StatelessWidget {
  final String type;

  MBTITile({required this.type});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Navigator.pop(context, type);
      },
      label: Text(type),
      icon: Icon(Icons.cloud_outlined),
    );
  }
}
