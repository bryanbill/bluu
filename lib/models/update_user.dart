import 'dart:io';

class UpdateUserModel{
  final File mediaFile;
  final String displayName;
  final String username;
  final String statusUpdate;
  
  UpdateUserModel({
    this.mediaFile,
    this.displayName,
    this.username,
    this.statusUpdate
  });
}
