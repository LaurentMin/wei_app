import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';
import '../utils/api_service.dart';
import 'product_page.dart';
import 'user_page.dart';
import 'scan_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final data = await ApiService.fetchItems();
    setState(() {
      items = data ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('ID : ${item['id']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageProduit(
                          idProduit: item['id'],
                          nameProduit: item['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
