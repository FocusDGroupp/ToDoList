import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> greetings;

  @override
  void initState() {
    super.initState();
    greetings = fetchGreetings();
  }

  Future<List<dynamic>> fetchGreetings() async {
    final url = Uri.parse('http://192.168.1.222:8080/device/greetings');
    print('Fetching data from $url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load greetings');
      }
    } catch (e) {
      throw Exception('Error fetching greetings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greetings'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: greetings,
        builder: (context, snapshot) {
          // Показуємо індикатор завантаження
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Обробка помилки
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Коли дані завантажені
          else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text('count: ${item['count']}'),
                  subtitle: Text('id: ${item['id']}'),
                );
              },
            );
          }
          // Порожній стан
          else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
