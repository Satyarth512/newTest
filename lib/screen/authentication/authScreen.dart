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
                  height: size.height*0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0,1 ))]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 60, bottom: 5),
                        child: Text(
                          'Enter your mobile number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.grey),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'We will send you a verification code. Message \n and data rate may apply.',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.blue),
                        ),
                      ),
                      Container(
                        width: size.width / 1.2,
                        height: size.height / 11,
                        margin: EdgeInsets.only(right: 20, left: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty || value.length < 10) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: 'Mobile Number',
                              prefix: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('+91'),
                              )),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, right: 20, left: 20),
                        width: size.width ,
                        height: size.height / 15,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              return Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OtpScreen(phone: _controller.text)));
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