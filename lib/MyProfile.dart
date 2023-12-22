import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:swap_life/kakao_login/mainview.dart';
import 'package:swap_life/report.dart';
import 'kakao_login/login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_storage/firebase_storage.dart';

//예선 작성//
class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

//예선 작성//
class _MyProfileState extends State<MyProfile> {

  String? _selectedMBTI; //User MBTI
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  XFile? _image;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String? _imageUrl;
  kakao.User ? user;

  final profile = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  //firebase 연동 - 진영//
  Future <void> saveProfile() async {
    user = await kakao.UserApi.instance.me();
    await profile.collection('MyProfile').doc(user!.id.toString()).set(
        {
          "profileID": _nameController.text,
          "Introduction": _introController.text,
          "MBTI": _selectedMBTI,
          "ImageUrl" : _imageUrl
        }
    );
  }

  Future<void> getProfile() async {
    user = await kakao.UserApi.instance.me();
    DocumentSnapshot getprof =
    await profile.collection('MyProfile').doc(user!.id.toString()).get();
    _nameController.text = getprof['profileID'];
    _introController.text = getprof['Introduction'];
    _selectedMBTI = getprof['MBTI'];
    _imageUrl = getprof['ImageUrl'];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'EDIT PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FutureBuilder<void>(
          // 프로필 데이터를 가져오기 위해 FutureBuilder 사용
          future: getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buildProfileContent(); // 데이터를 가져왔을 때 프로필 화면 구성
            } else {
              return Center(child: CircularProgressIndicator()); // 데이터를 가져오는 동안 로딩 표시
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        //shrinkWrap: true,
        children: <Widget>[
          imageProfile(),
          SizedBox(height: 30),
          nameTextField(),
          introduction(),
          SizedBox(height: 40,),
          chooseMBTI(),
          selectedMBTI(),
          if (_selectedMBTI == null)
            SizedBox(height: 20,)
          else
            SizedBox(height: 10,),
          myReport(),
          Logout(),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          (_imageUrl == null || _imageUrl!.isEmpty)
              ? CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/profile.png'),
            backgroundColor: Colors.deepPurple[50],
          )
              : CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(_imageUrl!), // Use NetworkImage for URL
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget nameTextField() {
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
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey,
        ),
        labelText: 'Name',
        hintText: 'Input your name',

      ),
      onFieldSubmitted: (value) {
        saveProfile();
      },
    );
  }

  Widget introduction() {
    return TextFormField(
      controller: _introController,
      maxLength: 20,
      decoration: InputDecoration(
        hintText: 'introduction',
      ),

      onFieldSubmitted: (value) {
        saveProfile();
      },
    );
  }

  Widget chooseMBTI() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple[50],
    ),
      onPressed: () async {
        var selectedMBTI = await showModalBottomSheet(
          context: context,
          builder: (builder) => MBTI(),
        );
        if (selectedMBTI != null) {
          setState(() {
            _selectedMBTI = selectedMBTI;
            saveProfile();
          });
        }
      },
      child: Row(
        children: [
          Icon(Icons.edit,color: Colors.deepPurple,),
          Text('                                    MBTI',style: TextStyle(color: Colors.deepPurple),),
        ],
      ),
    );
  }

  Widget selectedMBTI() {
    return _selectedMBTI != null
        ? Text(
      ' MBTI:  $_selectedMBTI',
      style: TextStyle(fontSize: 18,color: Colors.deepPurple,)
    )
        : Container(); // 선택된 MBTI가 없을 때는 빈 컨테이너 반환
  }

  Widget myReport() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[50],
        ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mbti_report()),
      ),
      child: Row(
        children: [
          Icon(Icons.favorite,color: Colors.deepPurple,),
          Text('                           My MBTI Report',style: TextStyle(color: Colors.deepPurple),),
        ],
      ),
    );
  }

  final viewModel = MainViewModel(KakaoLogin());

  //Logout 진영//
  Widget Logout() {
    return TextButton(
      onPressed: () => viewModel.logout(),
      child: Text("Logout",
        style: TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline),
      ),
    );
  }

  //예선 작성//
  Widget bottomSheet() {
    return Container(
        height: 100,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                  icon: Icon(Icons.camera, size: 35, color: Colors.deepPurple),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: Text('Camera',
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                TextButton.icon(
                  icon: Icon(
                      Icons.photo_library, size: 35, color: Colors.deepPurple),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text('Gallery',
                    style: TextStyle(fontSize: 20, color: Colors.grey),),
                )
              ],
            )
          ],
        )
    );
  }

  Future<void> takePhoto(ImageSource source) async {
    user = await kakao.UserApi.instance.me();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      File _file = File(pickedFile.path);

      // Firebase Storage에 이미지 업로드
      Reference _ref = _storage.ref('Profile/image/${user!.id}.jpg');
      UploadTask _uploadTask = _ref.putFile(_file);

      // 업로드 태스크가 완료될 때까지 기다린 후 이미지 URL을 얻어옴
      TaskSnapshot taskSnapshot = await _uploadTask.whenComplete(() => print('Image uploaded'));
      _imageUrl = await taskSnapshot.ref.getDownloadURL();
      print('Download URL: $_imageUrl');
      saveProfile();
    }
  }
}
//예선 작성//
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

//예선 작성//
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
