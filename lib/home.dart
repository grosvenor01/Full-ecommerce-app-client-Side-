import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushNamed(context, "/signup");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    CollectionReference products = firestore.collection("products");
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: 260 * (MediaQuery.of(context).size.width / 360),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pic1.png"), fit: BoxFit.fill),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 260 * (MediaQuery.of(context).size.width / 360) - 50,
                left: 21),
            child: const Text(
              "Street clothes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontFamily: "Metropolis-black.otf",
                fontWeight: FontWeight.w900,
              ),
            ),
          )),
      const Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sale",
                    style: TextStyle(
                        fontFamily: "Metropolis",
                        fontSize: 34,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Super summer sale",
                    style: TextStyle(
                      fontFamily: "Metropolis-Medium",
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Spacer(),
              Text("View all"),
              SizedBox(
                width: 10,
              )
            ],
          )),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
            stream: products.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Display a loading indicator while data is loading
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No data available.');
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data["type"] == "Sale") {
                    return Containers(
                      doc.id,
                      Color(0xFFDB3022),
                      data["pourcetage"],
                      data["reviews"],
                      data['publisher'],
                      data['name'],
                      data['old_price'],
                      data['new_price'],
                      data['image'],
                    );
                  }
                  return SizedBox();
                }).toList(),
              );
            }),
      ),
      const Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New",
                    style: TextStyle(
                        fontFamily: "Metropolis",
                        fontSize: 34,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "You've never seen it before!",
                    style: TextStyle(
                      fontFamily: "Metropolis-Medium",
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Spacer(),
              Text("View all"),
              SizedBox(
                width: 10,
              )
            ],
          )),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: products.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display a loading indicator while data is loading
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data available.');
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    if (data["type"] == "New") {
                      return Containers(
                        doc.id,
                        Colors.black,
                        "New",
                        data["reviews"],
                        data['publisher'],
                        data['name'],
                        data['old_price'],
                        data['new_price'],
                        data['image'],
                      );
                    }
                    return SizedBox();
                  }).toList(),
                );
              })),
      const Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Selling",
                    style: TextStyle(
                        fontFamily: "Metropolis",
                        fontSize: 34,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Items with flash sales",
                    style: TextStyle(
                      fontFamily: "Metropolis-Medium",
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Spacer(),
              Text("View all"),
              SizedBox(
                width: 10,
              )
            ],
          )),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: products.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Display a loading indicator while data is loading
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data available.');
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    if (data["type"] == "Top") {
                      return Containers(
                          doc.id,
                          Colors.transparent,
                          "",
                          data["reviews"],
                          data['publisher'],
                          data['name'],
                          data['old_price'],
                          data['new_price'],
                          data['image']);
                    }
                    return SizedBox();
                  }).toList(),
                );
              }))
    ])));
  }

  Widget Containers(String id,Color color, String pourcentage, int reviews, String name,
    String title, int old, int newp, String pic) {
    return Container(
      height: 260,
      width: 140,
      margin: const EdgeInsets.only(left: 18, top: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 6,
        ),
        Container(
            height: 150,
            width: 190,
            decoration: BoxDecoration(
                color: Colors.grey,
                image:
                    DecorationImage(image: NetworkImage(pic), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 20,
                    width: 40,
                    margin: const EdgeInsets.only(left: 8, top: 8),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(pourcentage,
                            style: const TextStyle(
                              color: Colors.white,
                            )))),
                Padding(
                    padding: const EdgeInsets.only(left: 40, top: 6),
                    child: SizedBox(
                        height: 30,
                        width: 40,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!(await FirebaseFirestore.instance
                                      .collection("wishlist")
                                      .where("name", isEqualTo: title)
                                      .limit(1)
                                      .get()).docs.isNotEmpty) {
                                FirebaseFirestore.instance.collection("wishlist").add({
                                  "product_ref":firestore.collection("products").doc(id)
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Icon(Icons.favorite_border,
                                color: Colors.grey))))
              ],
            )),
        SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 196, 0),
              size: 14,
            ),
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 196, 0),
              size: 14,
            ),
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 196, 0),
              size: 14,
            ),
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 196, 0),
              size: 14,
            ),
            Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 196, 0),
              size: 14,
            ),
            Text(
              "(" + reviews.toString() + ")",
              style: const TextStyle(
                fontFamily: "Metropolis-Medium",
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        Text(
          name,
          style: const TextStyle(
            fontFamily: "Metropolis-Medium",
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Metropolis",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Row(children: [
          Text(
            old.toString() + "\$   ",
            style: const TextStyle(
                fontFamily: "Metropolis-Medium",
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough),
          ),
          Text(newp.toString() + "\$",
              style: const TextStyle(
                fontFamily: "Metropolis-Medium",
                fontSize: 14,
                color: Color(0xFFDB3022),
                fontWeight: FontWeight.w500,
              ))
        ]),
      ]),
    );
  }
}
