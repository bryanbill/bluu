import 'package:bluu/constants/route_names.dart';
import 'package:bluu/pages/pin_verification_screen.dart';
import 'package:bluu/services/authentication_service.dart';
import 'package:bluu/services/navigation_service.dart';
import 'package:bluu/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends StatefulWidget {
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController controller = TextEditingController();

  String initialCountry = 'NG';

  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  String phone;
  bool validated = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Form(
          key: formKey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                    setState(() {
                      phone = number.phoneNumber;
                      print(number.phoneNumber + "Phone");
                    });
                  },
                  onInputValidated: (bool value) {
                    setState(() {
                      validated = value;
                    });
                  },
                  selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                  ignoreBlank: false,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  inputBorder: OutlineInputBorder(),
                ),
                validated
                    ? RaisedButton(
                        onPressed: () async {
                          if (validated) {
                            await _authenticationService.phoneAuth(
                                phone: phone, context: context);

                            print("Phone Number: " + phone);
                          } else {
                            print("Phone number missing");
                          }
                        },
                        child: Text('Next'),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
