import 'package:flutter/material.dart';
import 'package:full/containe.dart';
class bag extends StatefulWidget {
  const bag({super.key});
  @override
  State<bag> createState() => _bagState();
}
int autocounter = 1;
class _bagState extends State<bag> {
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
      body:SingleChildScrollView( 
      child:Column(
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
          containe(name:"Pullover",color:"White",size:"L",quantity:autocounter,price_one:43),
          containe(name:"Pullover",color:"White",size:"L",quantity:autocounter,price_one:43),
          containe(name:"Pullover",color:"White",size:"L",quantity:autocounter,price_one:43),
          containe(name:"Pullover",color:"White",size:"L",quantity:autocounter,price_one:43),
          Container(
            height: 36,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white
            ),
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
            padding:EdgeInsets.only(top: 20,bottom: 28,left: 16,right: 20),
            child:Row(
              children: [
                Text("Total amount:",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: "Metropolis",
                  fontWeight: FontWeight.w500
                ),),
                Spacer(),
                Text("112\$",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "Metropolis",
                  fontWeight: FontWeight.w500
                ),)
              ],
            )
          ),
          Center(child:Container(
            height: 48,
            width: 343,
            child : ElevatedButton(
              onPressed: (){}, 
              child: const Text("CHECK OUT"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDB3022),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)
                ),
              ),
            )
          )),
          SizedBox(height: 20,)
        ],
      ),
    ));
  }
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
        position.dx - 200.0,
        position.dy + button.size.height + 200,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Addtofavorites',
          child: Text('Add to favorites'),
        ),
        const PopupMenuItem<String>(
          value: 'Deletefromthelist',
          child: Text('Delete from the list'),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue == null) return; // No item was selected
      switch (selectedValue) {
        case 'lowestToHighest':
          setState(() {
            //data
          });
          break;
        case 'highestToLowest':
          setState(() {
            //data
          });
          break;
      }
    });
  }
  Widget Bag_container(String name,String color,String size,int quantity,int price_one) {
    return Center(
        child: Container(
      height: 104,
      width: 343,
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(
            height: 104,
            width: 100,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/b5ab0a6c-6393-4af6-abbc-4f1acaa6ed94/air-max-dawn-shoes-CLTL55.png"),
                    fit: BoxFit.cover)),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(left: 6, top: 11),
                    child: Text(name,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Metropolis",
                            fontWeight: FontWeight.w500))),
                Spacer(),
                Container(
                  height: 40,
                  width: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    onPressed: () {
                      _showContextMenu(context);
                    },
                    child: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 6,
                )
              ]),
              const SizedBox(height: 4),
              Row(
                children: [
                  SizedBox(width: 6),
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
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor:
                              const Color.fromARGB(255, 223, 223, 223)),
                      onPressed: () {
                        setState(() {
                          if (autocounter > 0) {
                            quantity--;
                          }
                        });
                      },
                      child: Icon(
                        Icons.remove,
                        color: Colors.grey,
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(quantity.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Metropolis",
                              fontWeight: FontWeight.w500))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor:
                              const Color.fromARGB(255, 223, 223, 223)),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.grey,
                      )),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text((quantity*price_one).toString()+"\$",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Metropolis",
                              fontWeight: FontWeight.w500))),
                ],
              )
            ],
          ))
        ],
      ),
    ));
  }
}
