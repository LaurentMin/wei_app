import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageScan(),
    );
  }
}

class PageScan extends StatefulWidget {
  const PageScan({Key? key}) : super(key: key);

  @override
  _PageScanState createState() => _PageScanState();
}

class _PageScanState extends State<PageScan> {
  String scannedResult = "Aucun code scanné";  // Variable pour afficher le résultat du scan

  // Fonction qui appelle le scanner
  Future<void> scanBarcode() async {
    // Lancement du scanner
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',       // Couleur de la ligne du scanner (ici rouge)
      'Annuler',       // Texte du bouton d'annulation
      true,            // Flash activé ou non
      ScanMode.BARCODE // Mode de scan : BARCODE ou QR_CODE
    );

    // Si un code est scanné (résultat différent de '-1')
    if (result != '-1') {
      setState(() {
        scannedResult = result;  // Met à jour le résultat scanné
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner un Code-barres'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Affiche le résultat du scan
            Text(
              'Résultat : $scannedResult',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Le bouton qui lance le scanner
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scanner un Code'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
