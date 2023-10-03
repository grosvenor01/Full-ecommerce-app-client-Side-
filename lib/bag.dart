import 'package:flutter/material.dart';
import 'package:full/containe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:full/wish.dart';

class bag extends StatefulWidget {
  const bag({super.key});
  @override
  State<bag> createState() => _bagState();
}

int autocounter = 0;
List<int> prices = [0];

class _bagState extends State<bag> {
  int dady() {
    int dady1 = 0;
    setState(() {
      dady1 = prices.reduce((value, element) => value + element);
    });
    return dady1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: const [
            Icon(Icons.search, color: Colors.black),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 14, top: 18),
                  child: Text("My Bag",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Metropolis",
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ))),
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("bag").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('Your bag is empty.');
                  }

                  final bagDocs = snapshot.data!.docs;

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(
                      bagDocs.map((bagDoc) async {
                        final productRef =
                            bagDoc.get("product_ref") as DocumentReference;
                        final size = bagDoc.get("size");
                        final color = bagDoc.get("color");
                        final quantity = bagDoc.get("quantity");
                        final productSnapshot = await productRef.get();
                        final productName = productSnapshot.get("name");
                        final productprice = productSnapshot.get("new_price");
                        final productimage = productSnapshot.get("image");
                        final bagitemId = bagDoc.id;
                        return {
                          "image": productimage,
                          "product_ref": productSnapshot.id,
                          "productprice": productprice,
                          "productName": productName,
                          "color": color,
                          "size": size,
                          "quantity": quantity,
                          "bagId": bagitemId
                        };
                      }).toList(),
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>>
                            productSnapshots) {
                      if (productSnapshots.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (productSnapshots.hasError) {
                        return Text('Error: ${productSnapshots.error}');
                      }
                      final combinedData =
                          productSnapshots.data!.map((productData) {
                        prices.add(productData['quantity'] *
                            productData['productprice']);
                        print(
                            prices.reduce((value, element) => value + element));
                        return containe(
                            image:productData['image'],
                            productref: productData['product_ref'],
                            bagid: productData['bagId'],
                            name: productData['productName'],
                            color: productData['color'],
                            size: productData['size'],
                            quantity: productData['quantity'],
                            price_one: productData[
                                'productprice'] // You can set this to the desired price
                            );
                      }).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: combinedData,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Container(
                height: 36,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.white),
                child: const TextField(
                  decoration: InputDecoration(
                    labelText: "Code Promo",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.close),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent, // Border color when focused
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 28, left: 16, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        "Total amount:",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                       dady().toString()+"\$",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
              Center(
                  child: Container(
                      height: 48,
                      width: 343,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("CHECK OUT"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDB3022),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                        ),
                      ))),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
