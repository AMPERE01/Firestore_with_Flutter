import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firestore/model/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FromScreen extends StatefulWidget {
   @override
  //const FromScreen({Key? key}) : super(key: key);
  _FromScreenState createState() => _FromScreenState();
}


class _FromScreenState extends State<FromScreen> {
  final formkey = GlobalKey<FormState>();
  Student myStudent = Student(age: '', fname: '', email: '', lname: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students");





  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('error'),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("form save data"),
              ),
              body: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "name",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "Pls enter name ><"),
                            onSaved: (fname) {
                              myStudent.fname = fname!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "lastname",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "Pls enter lastname ><"),
                            onSaved: (lname) {
                              myStudent.lname = lname!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "age",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            validator:
                                RequiredValidator(errorText: "Pls enter age"),
                            onSaved: (age) {
                              myStudent.age = age!;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "email",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              EmailValidator(errorText: "email incurret"),
                              RequiredValidator(errorText: "Pls enter email")
                            ]),
                            onSaved: (email) {
                              myStudent.email = email!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                "submit",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () async{ 
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  await _studentCollection.add({
                                    "fname":myStudent.fname,
                                    "lname":myStudent.lname,
                                    "age":myStudent.age,
                                    "email":myStudent.email
                        
                                  });
                                  formkey.currentState!.reset();
                                  /*print(
                                      "${myStudent.fname},${myStudent.lname},${myStudent.age},${myStudent.email}");*/
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    /* */
  }
}
