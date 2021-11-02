import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  TextEditingController _phoneController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference data = FirebaseFirestore.instance.collection('newData');

  Future<void> updateUser() {
    return data
        .doc(_auth.currentUser.uid)
        .update({'name': _nameController.text, 'number': _phoneController.text})
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Updated Successfully"))))
        .catchError((error) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Some Errors Occurred"))));
  }

  getData() {
    data
        .doc(_auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _phoneController.text = documentSnapshot.get('number');
        });
        _nameController.text = documentSnapshot.get('name');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  dynamic sendNotifications() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotifications');

    final results = await callable.call({});

    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(results.data.toString())));
  }

  logOut() async {
    return await _auth.signOut();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  shadowColor: Colors.blueGrey.shade100,
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: logOut,
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
//                          child: ElevatedButton(
//                            style: ElevatedButton.styleFrom(
//                              primary: Colors.white,
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(10),
//                              ),
//                            ),
//                            onPressed: sendNotifications,
//                            child: Text(
//                              "Send Notification",
//                              style: TextStyle(color: Colors.blueGrey),
//                            ),
//                          ),
                            child: TextButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: sendNotifications,
                              icon: Icon(
                                Icons.add_alert,
                                color: Colors.blue.shade300,
                              ),
                              label: Text(
                                "Send",
                                style: TextStyle(color: Colors.blue.shade300),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blueGrey.shade100,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0.1,
                                    blurRadius: 2)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Mobile Number: ${_phoneController.text}",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade400,
//                                    fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Name: ',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.blueGrey.shade100,
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: Offset(0, 1))
                                    ]),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                  cursorColor: Colors.blueGrey,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  controller: _nameController,
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade300,
                                      elevation: 3,
                                      shadowColor: Colors.blue.shade100,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  onPressed: updateUser,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
