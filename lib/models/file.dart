class FileModel {
  List<dynamic> files;
  String folder;

  FileModel({this.files, this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json['files'];
    folder = json['folderName'];
  }
}