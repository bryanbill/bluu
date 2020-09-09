import 'package:chatapp/components/themeChooser_modal.dart';
import 'package:chatapp/logic/sharedPref_logic.dart';
import 'package:chatapp/pages/languages.dart';
import 'package:chatapp/pages/weview.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'callscreens/pickup/pickup_layout.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class RadioList {
  bool isActive;
  final String colorName;
  final Color radioColor;

  RadioList(
    this.isActive,
    this.colorName,
    this.radioColor,
  );
}

class CanvasList {
  bool isActive;
  final String colorName;
  final Color radioColor;

  CanvasList(
    this.isActive,
    this.colorName,
    this.radioColor,
  );
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  //This is the List that holds data of Theme Chooser Radio Buttons.
  List<RadioList> radioList = [
    RadioList(false, 'Yellow', Color(0xffEAC21E)),
    RadioList(false, 'Red', Color(0xffff3f20)),
    RadioList(false, 'Blue', Color(0xff00aeff)),
    RadioList(false, 'Green', Color(0xff00d000)),
    RadioList(false, 'Pink', Color(0xffff00a8)),
  ];

  List<CanvasList> canvasList = [
    CanvasList(false, 'White', Colors.white),
    CanvasList(false, 'Night', Colors.grey),
    CanvasList(false, 'Dark', Colors.black),
  ];

  //This Function loads Theme Color from ShharedPreferences and update radioList's active status
  @override
  void initState() {
    super.initState();
    loadColorForRadio(radioList);

    loadCanvasColorForRadio(canvasList);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            title: 'Common',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              ),
              SettingsTile(
                title: 'Canvas Color',
                subtitle: 'theme: Tap to change',
                leading: Icon(Icons.cloud_queue),
                onTap: () {
                  setState(() {
                    showSettingsBottomSheetCanvas(context, canvasList);
                  });
                },
              ),
              SettingsTile(
                title: 'Accent',
                subtitle: 'colors',
                leading: Icon(Icons.color_lens),
                onTap: () {
                  setState(() {
                    showSettingsBottomSheet(context, radioList);
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(title: 'Phone number', leading: Icon(Icons.phone)),
              SettingsTile(title: 'Email', leading: Icon(Icons.email)),
              SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
            ],
          ),
          SettingsSection(
            title: 'Security',
            tiles: [
              SettingsTile.switchTile(
                title: 'Lock app in background',
                leading: Icon(Icons.phonelink_lock),
                switchValue: lockInBackground,
                switchActiveColor: Theme.of(context).accentColor,
                onToggle: (bool value) {
                  setState(() {
                    lockInBackground = value;
                    notificationsEnabled = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                  title: 'Use fingerprint',
                  leading: Icon(Icons.fingerprint),
                  switchActiveColor: Theme.of(context).accentColor,
                  onToggle: (bool value) {},
                  switchValue: false),
            
              SettingsTile.switchTile(
                title: 'Enable Notifications',
                enabled: notificationsEnabled,
                leading: Icon(Icons.notifications_active),
                switchActiveColor: Theme.of(context).accentColor,
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WeViewPage(
                            url:
                                "https://www.websitepolicies.com/policies/view/XEQFoOVl")));
                  },
                  title: 'Terms of Service',
                  leading: Icon(Icons.description)),
              SettingsTile(
                  onTap: () {
                    showLicensePage(
                      context: context,
                    );
                  },
                  title: 'Open source licenses',
                  leading: Icon(Icons.book)),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                  child: Image.asset(
                    'assets/images/settings.png',
                    height: 50,
                    width: 50,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  'Version: 1.0.5 (build.57890-genesis)',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
