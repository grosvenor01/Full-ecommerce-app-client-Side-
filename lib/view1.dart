import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget dady(String id, int reviews,String name, String title, int old, int newp, String pic) {
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
      ),
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
