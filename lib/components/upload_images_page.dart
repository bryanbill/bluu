import 'package:bluu/components/multipicker.dart';
import 'package:bluu/models/contact.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadImages extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const UploadImages({Key key, this.globalKey}) : super(key: key);
  @override
  _UploadImagesState createState() => new _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    images = null;
    super.dispose();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ThreeDContainer(
            backgroundColor: MultiPickerApp.darker,
            backgroundDarkerColor: MultiPickerApp.darker,
            height: 50,
            width: 50,
            borderDarkerColor: MultiPickerApp.pauseButton,
            borderColor: MultiPickerApp.pauseButtonDarker,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.globalKey,
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: loadAssets,
                      child: Container(
                        width: 130,
                        height: 50,
                        child: Center(
                            child: Text(
                          "Pick images",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (images.length == 0) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  content: Text("No image selected",
                                      style: TextStyle(color: Colors.white)),
                                  actions: <Widget>[
                                    InkWell(
                                      child: ThreeDContainer(
                                        width: 80,
                                        height: 30,
                                        backgroundColor:
                                            MultiPickerApp.navigateButton,
                                        backgroundDarkerColor:
                                            MultiPickerApp.background,
                                        child: Center(
                                            child: Text(
                                          "Ok",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    )
                                  ],
                                );
                              });
                        } else {
                          _displayDialog(context);
                        }
                      },
                      child: Container(
                        width: 130,
                        height: 50,
                        child: Center(
                            child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: buildGridView(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          int chars = 0;
          String desc = "";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: new Container(
                width: 400.0,
                height: 234.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // dialog centre
                    new Container(
                      child: new TextFormField(
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(256),
                        ],
                        onChanged: (value) {
                          setState(() {
                            chars = value.length;
                            desc = value;
                          });
                        },
                        textInputAction: TextInputAction.newline,
                        decoration: new InputDecoration(
                          suffix: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Text("$chars",
                                style: TextStyle(
                                    color:
                                        256 - chars < 10 ? Colors.red : null)),
                          ),
                          labelText: "Description",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Can't be blank!";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),

                    // dialog bottom
                    new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(),
                      child: FlatButton(
                        highlightColor: Theme.of(context).accentColor,
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                              "Uploading", "Please wait, we are uploading");
                          uploadImages(desc);
                        },
                        child: new Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'helvetica_neue_light',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future getFriends() async {
    QuerySnapshot qShot = await Firestore.instance
        .collection('users')
        .document(_authenticationService.currentUser.uid)
        .collection('contacts')
        .getDocuments();
    return qShot.documents
        .map(
          (doc) => doc.data['contact_id'],
        )
        .toList();
  }

  void uploadImages(String desc) async {
    List friends = await getFriends();
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          Firestore.instance.collection('posts').document().setData({
            'urls': imageUrls,
            'to': friends + [_authenticationService.currentUser.uid],
            'desc': desc,
            'timestamp': Timestamp.now(),
            'likes': [],
            'shares': [],
            'repost': [],
            'profilePhoto': _authenticationService.currentUser.profilePhoto,
            'by': _authenticationService.currentUser.name
          }).then((_) {
            Get.snackbar("Success", "Post made!");
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}
