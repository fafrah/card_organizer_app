import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2-Suit Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CardsScreen(),
    );
  }
}

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future _loadCards() async {
    final cards = await DatabaseHelper().getAllCards();
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('2-Suit Cards')),
      body: _cards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        card['image_url'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Image Not Available'));
                        },
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${card['card_name'].toString().toUpperCase()} of ${card['suit'].toString().toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
