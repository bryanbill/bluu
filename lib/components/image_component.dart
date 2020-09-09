import 'dart:convert';
import 'dart:io';

import 'package:chatapp/models/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';

class ImageComponent extends StatefulWidget {
  @override
  _ImageComponentState createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
   List<FileModel> files;
  FileModel selectedModel;
  String image;
  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) {
      return FileModel.fromJson(e);
    }).toList();

    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
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
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
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
                        image = d.files[0];
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
                      child: Text('Next'))
                )
              ],
            ),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image != null
                    ? Hero(
                        tag: "btn1",
                        child: Image.file(File(image),
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width),
                      )
                    : Container()),
            Divider(),
            files != null
                ? selectedModel == null && selectedModel.files.length < 1
                    ? Container()
                    : Flexible(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4),
                              itemBuilder: (_, i) {
                                var file = selectedModel.files[i];

                                return GestureDetector(
                                  child: _pickedFile.contains(file)?
                                  Container(
                                    decoration: playingDeco(),
                                    child: Image.file(
                                      File(file),
                                      fit: BoxFit.cover,
                                    ),
                                  ): Container(

                                    child: Image.file(
                                      File(file),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      image = file;

                                      (_pickedFile.contains(image)) ?
                                        _pickedFile.remove(image):_pickedFile.add(image);
                                      
                                    });
                                  },
                                  onLongPress: (){
                                    setState(() {
                                      image = file;

                                      (_pickedFile.contains(image)) ?
                                        _pickedFile.remove(image):_pickedFile.add(image);
                                      
                                    });
                                  },
                                );
                              },
                              itemCount: selectedModel.files.length),
                        ),
                      )
                : SizedBox()
          ],
        ),
      )
;
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

