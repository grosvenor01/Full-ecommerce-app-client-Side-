import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full/view1.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});
  @override
  State<Wishlist> createState() => _WishlistState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
int ordering = 0;
int view = 1;

class _WishlistState extends State<Wishlist> {
  CollectionReference wish_product = firestore.collection("wishlist");
  void _showContextMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final Offset position =
        button.localToGlobal(Offset.zero, ancestor: overlay);
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 200.0,
        position.dx + 200.0,
        position.dy + button.size.height + 200,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'lowestToHighest',
          child: Text('Lowest to Highest'),
        ),
        const PopupMenuItem<String>(
          value: 'highestToLowest',
          child: Text('Highest to Lowest'),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue == null) return; // No item was selected
      switch (selectedValue) {
        case 'lowestToHighest':
          setState(() {
            ordering = -1;
          });
          break;
        case 'highestToLowest':
          setState(() {
            ordering = 1;
          });
          break;
      }
    });
  }

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
              const SizedBox(height: 14),
              Row(children: <Widget>[
                SizedBox(width: 14),
                ElevatedButton(
                  onPressed: () {
                    _showContextMenu(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: const Row(children: [
                    Icon(
                      Icons.swap_vert,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Price:Lowest to high",
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent
                  ),
                  child: const Icon(
                    Icons.view_list_sharp,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (view == 1) {
                        view = 0;
                      } else {
                        view = 1;
                      }
                    });
                  },
                ),
                const SizedBox(
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

                  // Fetch all the wishlist documents
                  final wishlistDocs = snapshot.data!.docs;

                  // Fetch all product data based on product references
                  final productFutures = wishlistDocs.map((wishlistDoc) {
                    final productRef =
                        wishlistDoc.get("product_ref") as DocumentReference;
                    return productRef.get();
                  }).toList();

                  // Wait for all product data futures to complete
                  return FutureBuilder<List<DocumentSnapshot>>(
                    future: Future.wait(productFutures),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DocumentSnapshot>>
                            productSnapshots) {
                      if (productSnapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (productSnapshots.hasError) {
                        return Text('Error: ${productSnapshots.error}');
                      }

                      // Combine wishlist and product data into a list
                      final combinedData = <Map<String, dynamic>>[];
                      for (int i = 0; i < wishlistDocs.length; i++) {
                        final wishlistDoc = wishlistDocs[i];
                        final productSnapshot = productSnapshots.data![i];

                        if (wishlistDoc.exists && productSnapshot.exists) {
                          final wishlistId = wishlistDoc.id;
                          final data =
                              productSnapshot.data() as Map<String, dynamic>;

                          combinedData.add({
                            'wishlistId': wishlistId,
                            'productData': data,
                          });
                        }
                      }
                      //lowest to high
                      if (ordering == -1) {
                        combinedData.sort((a, b) => (a['productData']
                                ['new_price'] as int)
                            .compareTo(b['productData']['new_price'] as int));
                      }
                      //high to lowest
                      else if (ordering == 1) {
                        combinedData.sort((b, a) => (a['productData']
                                ['new_price'] as int)
                            .compareTo(b['productData']['new_price'] as int));
                      }

                      // Build your UI with the sorted and combined data
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (view == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: combinedData.map((item) {
                                final wishlistId = item['wishlistId'];
                                final productData = item['productData'];
                                return wish(
                                  wishlistId,
                                  productData['image'],
                                  productData['publisher'],
                                  productData['name'],
                                  "Grey",
                                  "L",
                                  productData['new_price'],
                                  productData['reviews'],
                                );
                              }).toList(),
                            ),
                          if (view == 1)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: combinedData.length ~/
                                  2, // Display two items in each row
                              itemBuilder: (BuildContext context, int index) {
                                final startIndex = index * 2;
                                final item1 = combinedData[startIndex];
                                final item2 = combinedData[startIndex + 1];

                                final wishlistId1 = item1['wishlistId'];
                                final wishlistId2 = item2['wishlistId'];

                                final productData1 = item1['productData'];
                                final productData2 = item2['productData'];

                                final widget1 = dady(
                                  wishlistId1,
                                  productData1['reviews'],
                                  productData1['publisher'],
                                  productData1['name'],
                                  productData1['old_price'],
                                  productData1['new_price'],
                                  productData1['image'],
                                );

                                final widget2 = dady(
                                  wishlistId2,
                                  productData2['reviews'],
                                  productData2['publisher'],
                                  productData2['name'],
                                  productData2['old_price'],
                                  productData2['new_price'],
                                  productData2['image'],
                                );

                                return Row(
                                  children: [
                                    Spacer(),
                                    widget1,
                                    Spacer(),
                                    widget2,
                                    Spacer(),
                                  ],
                                );
                              },
                            )
                        ],
                      );
                    },
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
