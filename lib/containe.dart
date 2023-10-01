import 'package:flutter/material.dart';

class containe extends StatefulWidget {
  final String name;
  final String color;
  final String size;
  final int quantity;
  final int price_one;
  const containe({
    Key? key,
    required this.name,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price_one,
  }) : super(key: key);

  @override
  State<containe> createState() => _containeState();
}

class _containeState extends State<containe> {
  late String name;
  late String color;
  late String size;
  late int quantity;
  late int price_one;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    color = widget.color;
    size = widget.size;
    quantity = widget.quantity;
    price_one = widget.price_one;
  }
  @override
  Widget build(BuildContext context) {
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
                          if (quantity > 0) {
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
                      child: Text((quantity * price_one).toString() + "\$",
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
    ;
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
        position.dy ,
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
}
