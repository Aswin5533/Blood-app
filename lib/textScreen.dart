import 'package:blood_app/screens/homeScreen.dart';
import 'package:blood_app/utils/appColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Textscreen extends StatefulWidget {
  final DocumentSnapshot? bloods;

  const Textscreen({super.key, this.bloods});

  @override
  State<Textscreen> createState() => _TextscreenState();
}

class _TextscreenState extends State<Textscreen> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; //step1 : intializing firebase.
  Future<void> saveBlood() async {
    //step2 ; giving on tap fuction.
    String names =
        nameController.text; //step3 : putting controllers into a variable.
    String blood = bloodGroupController.text;
    String numbers = numberController.text;
    if (widget.bloods == null) {
      firestore.collection('Bloods').add({
        //step 4 : adding collection name.
        'name': names, //step 5 : adding variables in to a firebase field.
        'bloodGroup': blood,
        'phoneNumber' : numbers,

      });
    } else {
      firestore.collection('Bloods').doc(widget.bloods?.id).update({
        'name': names,
        'bloodGroup': blood,
        'phoneNumber' :numbers,

      });
    }
    nameController.clear(); //step 6 : clearing the controllers
    bloodGroupController.clear();
    numberController.clear();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.bloods != null) {
      nameController.text = widget.bloods?['name'];
      bloodGroupController.text = widget.bloods?['bloodGroup'];
      numberController.text = widget.bloods?['phoneNumber'];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          },
          icon: Icon(CupertinoIcons.back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              saveBlood();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Homescreen()),
              );
            },
            // step 7 : giving the onpressed to firebase varialble to store the data.
            icon: Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: TextField(
              style: TextStyle(color: AppColor.textColor),
              maxLength: 20,
              controller: nameController,
              cursorColor: AppColor.textColor,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
                hintText: "Name",
                hintStyle: TextStyle(color: AppColor.textColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: TextField(
              maxLength: 3,
              controller: bloodGroupController,
              style: TextStyle(color: AppColor.textColor),
              decoration: InputDecoration(
                hintText: "Blood Group",
                hintStyle: TextStyle(color: AppColor.textColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 20),
            child: TextField(
              controller: numberController,
              style: TextStyle(color: AppColor.textColor),
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(color: AppColor.textColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
