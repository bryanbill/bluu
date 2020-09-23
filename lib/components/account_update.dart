import 'dart:io';

import 'package:bluu/services/cloud_storage_service.dart';
import 'package:bluu/services/firestore_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
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
  bool loading = false;
  int editPos = 0;
  CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(children: <Widget>[
          Stack(
            children: [
              CircleAvatar(
                  radius: 40,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile)
                      : NetworkImage(widget.userProfilePic),
                  child: loading ? CircularProgressIndicator() : SizedBox()),
              Positioned(
                  top: 20,
                  left: 20,
                  bottom: 20,
                  right: 20,
                  child: IconButton(
                      onPressed: () async {
                        await _pickImage().then((f) => upload(f));
                      },
                      icon: Icon(Icons.camera_alt)))
            ],
          ),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: editPos == 1
                    ? TextField(
                        onChanged: (value) async {
                          await _firestoreService.updateFullName(
                              widget.userId, value);
                          print("$value");
                        },
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        decoration:
                            InputDecoration(suffixText: widget.fullName),
                        autofillHints: ["Bill", "Omondi", "New"],
                      )
                    : Text(widget.fullName),
                subtitle: Text("Display Name"),
                trailing: editPos != 1
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          return editting(1);
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          return editting(0);
                        }),
              )),
          SizedBox(height: 10, child: Divider()),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: ListTile(
                leading: Icon(Icons.person),
                title: editPos == 2
                    ? TextField(
                        onChanged: (value) {
                          _firestoreService.updateUserName(
                              widget.userId, value);
                        },
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        decoration:
                            InputDecoration(suffixText: widget.userName),
                        autofillHints: ["Bill", "Omondi", "New"],
                      )
                    : Text(widget.userName),
                subtitle: Text("User Name"),
                trailing: editPos != 2
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          return editting(2);
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          return editting(0);
                        }),
              )),
          SizedBox(height: 10, child: Divider()),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: ListTile(
                  leading: Icon(Icons.alternate_email),
                  title: Text(widget.userEmail),
                  subtitle: Text("Email"),
                  trailing: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      return editting(3);
                    },
                  ))),
          SizedBox(height: 10, child: Divider()),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: editPos == 4
                    ? TextField(
                        onChanged: (value) {
                          _firestoreService.updateUserStatus(
                              widget.userId, value);
                        },
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        decoration:
                            InputDecoration(suffixText: widget.userStatus),
                        autofillHints: ["Bill", "Omondi", "New"],
                      )
                    : Text(
                        widget.userStatus,
                        overflow: TextOverflow.ellipsis,
                      ),
                subtitle: Text("Status"),
                trailing: editPos != 4
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          return editting(4);
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          return editting(0);
                        }),
              )),
          SizedBox(height: 10, child: Divider()),
        ]),
      ],
    );
  }

  Future<File> _pickImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null)
      setState(() {
        loading = true;
        imageFile = file;
      });
    return file;
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

    await _firestoreService
        .updateProfilePic(widget.userId, result.imageUrl)
        .whenComplete(() => setState(() {
              loading = false;
            }));
  }

  void editting(int pos) {
    setState(() {
      editPos = pos;
    });
  }

  @override
  void dispose() {
    imageFile = null;
    super.dispose();
  }
}
