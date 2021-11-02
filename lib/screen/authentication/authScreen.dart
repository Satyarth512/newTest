import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newapp/screen/authentication/otp.dart';
import 'package:newapp/screen/dashboard.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('90');

  Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('90');
  String code = "+91";

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text(
              "+${country.phoneCode}(${country.isoCode})",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DashBoard();
          }
          return Scaffold(
            body: Center(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blueGrey.shade100,
                            spreadRadius: 0.001,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 60, bottom: 5),
                        child: Text(
                          'Enter your mobile number',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: CountryPickerDropdown(
                              initialValue: 'IN',
                              itemBuilder: _buildDropdownItem,
                              priorityList: [
                                CountryPickerUtils.getCountryByIsoCode('IN'),
                                CountryPickerUtils.getCountryByIsoCode('US'),
                              ],
                              sortComparator: (Country a, Country b) =>
                                  a.isoCode.compareTo(b.isoCode),
                              onValuePicked: (Country country) {
                                setState(() {
                                  code = "+${country.phoneCode}";
                                });
                                print(code);
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blueGrey.shade100,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0.5)
                            ]),
                        width: size.width / 1.2,
                        height: size.height / 15,
                        margin: EdgeInsets.only(right: 20, left: 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(color: Colors.blueGrey),

                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(code, style: TextStyle(color: Colors.blueGrey),),
                              ),),
                          keyboardType: TextInputType.number,
                          controller: _controller,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        width: size.width,
                        height: size.height / 15,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue.shade300,
                            elevation: 5,
                            shadowColor: Colors.lightBlue.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              return Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                          phone: "$code${_controller.text}")));
                            }
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
