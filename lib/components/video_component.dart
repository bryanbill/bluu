import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';
import 'package:video_player/video_player.dart';

const title =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

class VideoComponent extends StatefulWidget {
  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  List<FileModel> files;
  FileModel selectedModel;

  VideoPlayerController _controller;
  var video;

  String selected;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getVideosPath();
  }

  Future getVideosPath() async {
    var videoPath = await StoragePath.videoPath;
    var video = jsonDecode(videoPath) as List;
    files = video.map<FileModel>((e) {
      return FileModel.fromJson(e);
    }).toList();

    if (files != null && files.length > 0)
      setState(() {
        try {
          selectedModel = files[0];
          video = files[0].files[0];
        } catch (e) {
          print("errror: $e");
        }
      });

    return files;
  }

  Stream getAllVideo() {
    return Stream.fromFuture(getVideosPath());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  playPause() {
    return IconButton(
      color: Colors.white70,
      iconSize: 80.0,
      icon: _controller.value.isPlaying
          ? Icon(Icons.pause_circle_filled)
          : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
    );
  }

  List _pickedFile = [];
  BoxDecoration playingDeco() {
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).accentColor,
        width: 5.0,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //         <--- border radius here
          ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          int chars = 0;
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
                          });
                        },
                        maxLines: null,
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
                        onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.folder_open),
                  SizedBox(width: 10),
                  DropdownButtonHideUnderline(
                      child: DropdownButton<FileModel>(
                    items: getItems(),
                    onChanged: (FileModel d) {
                      assert(d.files.length > 0);
                      video = d.files[0];
                      setState(() {
                        selectedModel = d;
                      });
                    },
                    value: selectedModel,
                  ))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      onPressed: () => _displayDialog(context),
                      child: Text('Next')))
            ],
          ),
          Divider(),
          _controller != null
              ? _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: new VideoPlayer(_controller),
                    )
                  : Container()
              : Container(),
          SizedBox(height: 10),
          Divider(),
          files != null
              ? selectedModel == null && selectedModel.files.length < 1
                  ? Container()
                  : Flexible(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3),
                          itemBuilder: (_, i) {
                            var file = selectedModel.files[i];

                            return GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _pickedFile.contains(
                                          file['displayName'].toString())
                                      ? HapticFeedback.vibrate().then((value) =>
                                          _pickedFile.remove(
                                              file['displayName'].toString()))
                                      : HapticFeedback.vibrate().then((value) =>
                                          _pickedFile.add(
                                              file['displayName'].toString()));
                                });
                              },
                              child:
                                  selected == file['displayName'].toString() ||
                                          _pickedFile.contains(
                                              file['displayName'].toString())
                                      ? Container(
                                          decoration: playingDeco(),
                                          child: Text(
                                            file['displayName']
                                                    .toString()
                                                    ?.split('.')
                                                    ?.first ??
                                                "",
                                            overflow: TextOverflow.fade,
                                          ),
                                        )
                                      : Container(
                                          child: Text(
                                            file['displayName']
                                                    .toString()
                                                    ?.split('.')
                                                    ?.first ??
                                                "",
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                              onTap: () {
                                setState(() {
                                  selected = file['displayName'].toString();
                                  try {
                                    _controller = VideoPlayerController.file(
                                        File(file['path']))
                                      ..initialize().then((value) {
                                        setState(() {});
                                        _controller.play();
                                      });
                                    _pickedFile.contains(
                                            file['displayName'].toString())
                                        ? _pickedFile.remove(
                                            file['displayName'].toString())
                                        : _pickedFile.add(
                                            file['displayName'].toString());
                                  } catch (e) {
                                    print("PlayBack error:$e");
                                  }
                                });
                              },
                            );
                          },
                          itemCount: selectedModel.files.length))
              : SizedBox()
        ]));
  }

  List<DropdownMenuItem<FileModel>> empty = [];
  List<DropdownMenuItem> getItems() {
    return files != null
        ? files
                .map((e) => DropdownMenuItem(
                      child: Text(
                        e.folder,
                        //   style: TextStyle(color: Colors.black),
                      ),
                      value: e,
                    ))
                .toList() ??
            []
        : empty;
  }
}
