import 'package:flutter/material.dart';
import 'TextScreen.dart';
import 'VideoScreen.dart';
import 'MainPage.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  const HomeScreen({super.key, required this.selectedIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex.clamp(0, _widgetOptions.length - 1);
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const TextScreen(),
    const VideoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index.clamp(0, _widgetOptions.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'TEXT' : 'VIDEO',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 44, 215),
         iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 41, 44, 215),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text Summarization',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // If spacing is needed, consider adjusting layout instead
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Video Summarization',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 62, 62, 210),
        onTap: _onItemTapped,
      ),
    );
  }
}
