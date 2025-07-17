import 'package:blood_app/textScreen.dart';
import 'package:blood_app/widgets/drawerWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/appColor.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Textscreen()),
          );
        },
        backgroundColor: AppColor.secondaryColor,
        child: Icon(Icons.add, color: AppColor.primaryColor),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.secondaryColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user?.photoURL ?? " "),
              ),
            );
          },
        ),
      ),
      drawer: Drawerwidget(),
      body: Column(
        children: [
          Center(
            child:
                loading
                    ? LoadingAnimationWidget.threeArchedCircle(
                      color: AppColor.secondaryColor,
                      size: 60,
                    )
                    : StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection('Bloods')
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          var bloods = snapshot.data?.docs;
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: bloods?.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          child: Material(
                                            elevation: 30,
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            child: SizedBox(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => Textscreen(
                                                            bloods:
                                                                bloods?[index],
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Dismissible(
                                                  background: Icon(
                                                    Icons.delete,
                                                    color:
                                                        AppColor.secondaryColor,
                                                  ),
                                                  key: UniqueKey(),
                                                  direction:
                                                      DismissDirection
                                                          .startToEnd,
                                                  onDismissed: (direction) {
                                                    setState(() {
                                                      FirebaseFirestore.instance
                                                          .collection('Bloods')
                                                          .doc(
                                                            bloods?[index].id,
                                                          )
                                                          .delete();
                                                      DismissDirection
                                                          .startToEnd;
                                                    });
                                                  },
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height /
                                                        12,
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColor
                                                              .secondaryColor,
                                                      border: Border.all(
                                                        color:
                                                            AppColor
                                                                .secondaryColor,
                                                        width: 3,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  25,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  25,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  25,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 15,
                                                            left: 10,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                bloods?[index]['name'],
                                                                style: GoogleFonts.adamina(
                                                                  textStyle: TextStyle(
                                                                    color:
                                                                        AppColor
                                                                            .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                bloods?[index]['phoneNumber'],
                                                                style: GoogleFonts.adamina(
                                                                  textStyle: TextStyle(
                                                                    color:
                                                                        AppColor
                                                                            .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 10,
                                                                ),
                                                            child: CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColor
                                                                      .primaryColor,
                                                              child: Center(
                                                                child: Text(
                                                                  bloods?[index]['bloodGroup'],
                                                                  style: GoogleFonts.alata(
                                                                    textStyle: TextStyle(
                                                                      color:
                                                                          AppColor
                                                                              .secondaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 20),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "No Bloods",
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
