import 'package:flutter/material.dart';
import 'package:library_app/Bottom_navMenu/Books/Books.dart';
import 'package:library_app/Bottom_navMenu/Home/Home.dart';
import 'package:library_app/Bottom_navMenu/Members/Members.dart';

class HomeNav extends StatefulWidget {
  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _SelectedIndex = 0;

  PageController _pageController = PageController();

  List<Widget> _screens = <Widget>[Home(), Books(), Members()];

  void _onPageChanged(int index) {}

  void _onItemTap(int index) {
    setState(() {
      _SelectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BottomAppBar(
            child: BottomNavigationBar(
              backgroundColor: Colors.orange[300],
              iconSize: 25,
              currentIndex: _SelectedIndex, //widget.index
              onTap: _onItemTap,
              selectedItemColor: Color(0xff6A639F),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 30),
                  title: Text(
                    "Home",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.collections_bookmark, size: 30),
                  title: Text(
                    "Buku",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people, size: 30),
                  title: Text(
                    "Member",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
