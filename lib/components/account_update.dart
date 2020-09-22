import 'dart:io';

import 'package:bluu/services/cloud_storage_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AccountUpdate extends StatefulWidget {
  final String userName;
  final String userProfilePic;
  final String userStatus;
  final String userEmail;
  final String fullName;
  final String userId;

  AccountUpdate(
      {Key key,
      this.userName,
      this.userProfilePic,
      @required this.userId,
      this.userStatus,
      this.userEmail,
      this.fullName})
      : super(key: key);

  @override
  _AccountUpdateState createState() => _AccountUpdateState();
}

class _AccountUpdateState extends State<AccountUpdate> {
  File imageFile;
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.userProfilePic),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                  onPressed: () async {
                    // await _pickImage()
                    //     .then((f) => _cropImage(f).then((c) => upload(c)));
                  },
                  icon: Icon(Icons.camera_alt)))
        ],
      ),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(children: <Widget>[
          Text("Display Name"),
          GestureDetector(
              onTap: () {
                //TODO: transform to textfield using an animator
                print("ontap to turn on textfield");
              },
              child: Text(widget.fullName))
        ]),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(children: <Widget>[
          Text("User Name"),
          GestureDetector(
              onTap: () {
                //TODO: transform to textfield using an animator
                print("ontap to turn on textfield");
              },
              child: Text(widget.userName))
        ]),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(children: <Widget>[
          Text("Status"),
          GestureDetector(
              onTap: () {
                //TODO: transform to textfield using an animator
                print("ontap to turn on textfield");
              },
              child: Text(widget.userStatus))
        ]),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(children: <Widget>[
          Text("Email"),
          GestureDetector(
              onTap: () {
                //TODO: transform to textfield using an animator
                print("ontap to turn on textfield");
              },
              child: Text(widget.userEmail))
        ]),
      ),
      SizedBox(height: 10),
    ]));
  }

  Future<File> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  // Future _cropImage(pickedImageFile) async {
  //   File croppedFile = await ImageCropper.cropImage(
  //       sourcePath: pickedImageFile.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio16x9
  //             ]
  //           : [
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio5x3,
  //               CropAspectRatioPreset.ratio5x4,
  //               CropAspectRatioPreset.ratio7x5,
  //               CropAspectRatioPreset.ratio16x9
  //             ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.deepOrange,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));
  //   if (croppedFile != null) {
  //     imageFile = croppedFile;
  //   }
  // }

  Future upload(File file) async {
    final String title = "Bluu-profile" + DateTime.now().toUtc().toString();
    var result = await _cloudStorageService.uploadImage(
        imageToUpload: file, title: title);

    await _firestoreService.updateProfilePic(widget.userId, result.imageUrl);
  }
}
