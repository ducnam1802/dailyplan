import 'package:daily_planner/data/task_page.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int _selectedIndex = 0;
  List<Widget> listBody = [];
  
  @override
  void initState() {
    super.initState();
    listBody = [
      TaskPage()
    ];
  }
  List<Widget> getPages(){
    return [
      TaskPage()
    ];
  }
   
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = getPages();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onItemTapped,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar( 
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Công việc"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Lịch"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: onItemTapped,
        ),
      )
    );

  }
}