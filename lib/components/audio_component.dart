import 'dart:async';
import 'dart:convert';

import 'package:chatapp/models/file.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

const title =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

class AudioComponent extends StatefulWidget {
  @override
  _AudioComponentState createState() => _AudioComponentState();
}

class _AudioComponentState extends State<AudioComponent> {
  List<FileModel> files;
  FileModel selectedModel;
  var audio;
  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';



  @override
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    getAllAudio();
  }

  Future getAudiosPath() async {
    var audioPath = await StoragePath.audioPath;
    var audios = jsonDecode(audioPath) as List;
    files = audios.map<FileModel>((e) {
      return FileModel.fromJson(e);
    }).toList();

    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        audio = files[0].files[0];
      });
    return files;
  }

  Stream getAllAudio() {
    return Stream.fromFuture(getAudiosPath());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  playPause() {
    return IconButton(
     // color: Colors.white70,
      iconSize: 80.0,
      icon: _isPlaying
          ? Icon(Icons.pause_circle_filled)
          : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (_isPlaying) {
            _pause();
          } else {
            _play();
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
                      audio = d.files[0];
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
          audio != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [playPause()],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              Slider(
                                onChanged: (v) {
                                  final position = v * _duration.inMilliseconds;
                                  _audioPlayer.seek(
                                      Duration(milliseconds: position.round()));
                                },
                                value: (_position != null &&
                                        _duration != null &&
                                        _position.inMilliseconds > 0 &&
                                        _position.inMilliseconds <
                                            _duration.inMilliseconds)
                                    ? _position.inMilliseconds /
                                        _duration.inMilliseconds
                                    : 0.0,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _position != null
                              ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                              : _duration != null ? _durationText : '',
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                    Text(audio['displayName'].toString()?.split('.')?.first ??
                        "")
                  ],
                )
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
                              child: _pickedFile.contains(file)?
                              Container(
                                decoration: playingDeco(),
                                child: Text(
                                  file['displayName']
                                          .toString()
                                          ?.split('.')
                                          ?.first ??
                                      "",
                                  overflow: TextOverflow.fade,
                                ),
                              ):Container(
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
                                  audio = file;
                                  _stop().then((value) => _play());
                                   (_pickedFile.contains(audio)) ?
                                        _pickedFile.remove(audio):_pickedFile.add(audio);
                                });
                              },
                              onLongPress: (){
                                 audio = file;
                                  _stop().then((value) => _play());
                                   (_pickedFile.contains(audio)) ?
                                        _pickedFile.remove(audio):_pickedFile.add(audio);
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

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

   
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(audio['path'].toString(),
        position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }


  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
