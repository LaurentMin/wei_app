import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../utils/api_service.dart';
import 'product_page.dart'; // Importez la page produit

class PageScan extends StatefulWidget {
  const PageScan({super.key});

  @override
  _PageScanState createState() => _PageScanState();

}

class _PageScanState extends State<PageScan> {
  String scannedResult = "No scanned code"; // Variable pour afficher le résultat du scan
  List<dynamic> item = [];
  bool isFind = false;
  bool canShow = false;

  @override
  void initState() {
    super.initState();
    scanBarcode();
  }

  // Fonction qui appelle le scanner
  Future<void> scanBarcode() async {
    // Lancement du scanner
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Couleur de la ligne du scanner (ici rouge)
      'Annuler', // Texte du bouton d'annulation
      true, // Flash activé ou non
      ScanMode.BARCODE // Mode de scan : BARCODE ou QR_CODE
    );

    // Si un code est scanné (résultat différent de '-1')
    if (result != '-1') {
      setState(() {
        scannedResult = result; // Met à jour le résultat scanné
        canShow = true;
      });

      // Recherche de la référence en base
      final data = await ApiService.fetchItemRef(result);
      setState(() {
        item = data ?? [];
        isFind = item.isNotEmpty; // Détermine si un article a été trouvé
      });

      // Si un article est trouvé, redirigez vers la page produit
      if (isFind) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageProduit(
              idProduit: item[0]['id'],
              nameProduit: item[0]['name'],
              ref: item[0]['ref'],
              size: item[0]['size'],
              color: item[0]['color'],
              photo: item[0]['image'],
            ),
          ),
        );
      } else {
        // Affiche un message d'erreur si aucun article n'est trouvé
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun article trouvé pour ce code.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Affiche le résultat du scan
            Text(
              'Résultat : $scannedResult',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Le bouton qui lance le scanner
            ElevatedButton(
              onPressed: scanBarcode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Scan a barcode'),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
