import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class _WishlistState extends State<Wishlist> {
  CollectionReference wish_product = firestore.collection("wishlist");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          actions: const [
            Icon(
              Icons.search,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18, left: 18),
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontFamily: "Metropolis",
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Categories("Summer"),
                      Categories("T-Shirts"),
                      Categories("Shirts"),
                      Categories("Parfume"),
                      Categories("Jeans"),
                    ],
                  )),
              SizedBox(height: 14),
              const Row(children: <Widget>[
                SizedBox(width: 14),
                Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Filters"),
                Spacer(),
                Icon(
                  Icons.swap_vert,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Price:Lowest to high"),
                Spacer(),
                Icon(
                  Icons.view_list_sharp,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
              ]),
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("wishlist").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No wishlist data found');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot wishlistDoc) {
                      if (wishlistDoc.exists) {
                        final wishlistId = wishlistDoc
                            .id; // Get the ID of the wishlist document
                        final productRef = wishlistDoc.get("product_ref")
                            as DocumentReference; // Get the DocumentReference

                        return FutureBuilder<DocumentSnapshot>(
                          future: productRef.get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                            if (productSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (productSnapshot.hasError) {
                              return Text('Error: ${productSnapshot.error}');
                            }

                            if (productSnapshot.hasData &&
                                productSnapshot.data!.exists) {
                              final data = productSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              return Column(
                                children: [
                                  wish(
                                    wishlistId,
                                    data["image"],
                                    data["publisher"],
                                    data["name"],
                                    "Grey",
                                    "L",
                                    data["new_price"],
                                    data["reviews"],
                                  ),
                                ],
                              );
                            } else {
                              return Text(
                                  'Product not found for Wishlist ID: $wishlistId');
                            }
                          },
                        );
                      } else {
                        return Text('Wishlist document does not exist');
                      }
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ));
  }

  Widget wish(String id, String image1, String author, String name,
      String color, String size, int price, int reviews) {
    return Container(
      width: 350,
      height: 130,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            height: 130,
            width: 115,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text(
                      author,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "Metropolis-Medium",
                          fontSize: 11,
                          fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    Container(
                      width: 15.0,
                      height: 15.0,
                      child: ElevatedButton(
                        onPressed: () {
                          wish_product.doc(id).delete();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors
                                .transparent // Remove padding to control the size
                            ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 3, left: 4),
                    child: Text(name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w700))),
                SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text("Color: ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontFamily: "Metropolis-Medium",
                          fontWeight: FontWeight.w400,
                        )),
                    Text(color,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: "Metropolis-Medium",
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(width: 26),
                    Text("Size: ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontFamily: "Metropolis-Medium",
                          fontWeight: FontWeight.w400,
                        )),
                    Text(size,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: "Metropolis-Medium",
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text("$price\$",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Metropolis",
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(width: 30),
                    Icon(Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 245, 188, 0), size: 14),
                    Icon(Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 245, 188, 0), size: 14),
                    Icon(Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 245, 188, 0), size: 14),
                    Icon(Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 245, 188, 0), size: 14),
                    Icon(Icons.star_rate_rounded,
                        color: Color.fromARGB(255, 245, 188, 0), size: 14),
                    Text("($reviews)",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontFamily: "Metropolis-Medium",
                          fontWeight: FontWeight.w400,
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        final productRef = await firestore
                            .collection("wishlist")
                            .doc(id)
                            .get()
                            .then((doc) {
                          if (doc.exists) {
                            return doc.get("product_ref") as DocumentReference?;
                          } else {
                            return null;
                          }
                        });
                        if (productRef != null) {
                          await firestore.collection("bag").add({
                            "product_ref": productRef,
                          });
                          print("Product added to the bag");
                        } else {
                          print("Product reference not found in the wishlist");
                        }
                      },
                      child: Icon(
                        Icons.shopping_bag_sharp,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(), backgroundColor: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget Categories(String category) {
    return Container(
        height: 30,
        width: 100,
        margin: const EdgeInsets.only(top: 12, left: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 51, 51, 51),
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            category,
            style: const TextStyle(
                fontFamily: "Metropolis-Medium",
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}
