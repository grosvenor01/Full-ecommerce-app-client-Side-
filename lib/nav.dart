import 'package:flutter/material.dart';
import 'package:full/home.dart';

int _currentIndex = 0;
const  screens = <Widget> [home(), home(), home(), home(), home()];

class navbar extends StatefulWidget {
  const navbar({super.key});

  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color.fromARGB(255, 216, 14, 0),
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                  label: "Shop"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                  ),
                  label: "Bag"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    size: 30,
                  ),
                  label: "Favorite"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_2_outlined,
                    size: 30,
                  ),
                  label: "Profile"),
            ]));
  }
}
