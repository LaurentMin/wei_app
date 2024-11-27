import 'package:flutter/material.dart';
// Requete HTTP pour mysql via API
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

const urlApi = 'https://api.skeuly.com/items';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WEI Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Articles'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class PageScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Page'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la nouvelle page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PageUtilisateur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Page'),
      ),
      body: Center(
        child: Text(
          'Bienvenue sur la nouvelle page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> items = []; // Liste des éléments récupérés
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    fetchItems(); // Récupère les données dès l'ouverture de la page
  }

  Future<void> fetchItems() async {
    print("fetchItems() called"); // Log pour vérifier l'appel
    final url = Uri.parse(urlApi); // URL de l'API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          items = data;
          isLoading = false;
        });
      } else {
        print('Erreur : ${response.statusCode}');
        setState(() {
          isLoading = false; // Arrêter le loader même en cas d'erreur
        });
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      setState(() {
        isLoading = false; // Arrêter le loader même en cas d'erreur
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator()) // Affiche un loader pendant le chargement
      // Continuer la recherche
      : items.isEmpty
      ? Center(
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Text('Aucun élément trouvé ou erreur lors du chargement'),
              SizedBox(height: 10),
              ElevatedButton(
               onPressed: fetchItems, // Relance la récupération
               child: Text('Recharger'),
               ),
            ],
          ),
        )
        : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
           final item = items[index];
           return ListTile(
             title: Text(item['name']), // Affiche le champ 'name'
             subtitle: Text('ID : ${item['id']}'), // Affiche l'ID
             trailing: const Icon(Icons.arrow_forward),
             onTap: () {
               print('Item sélectionné : ${item['id']}');
              },
            );
          },
        ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 10,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageUtilisateur())
                  );
                },
              child: Icon(Icons.account_circle),
              ),
            ),
          ),
          Positioned(
            right: 160,
            bottom: 10,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageScan())
                  );
                },
              child: Icon(Icons.add_circle),
              ),
            ),
          ),
          Positioned(
            right: 300,
            bottom: 10,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                  onPressed: () {
                  print('Bouton 3 appuyé');
                },
              child: Icon(Icons.folder),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO(LaurentMin): Faire la requete mysql.
    return Center(  
      child: Text('Résultat pour "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
    ].where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
