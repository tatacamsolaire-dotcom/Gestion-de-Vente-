import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestion_vente_ultra/db/database.dart';
import 'package:gestion_vente_ultra/models/sale.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final db = AppDatabase();
  List<Sale> sales = [];

  @override
  void initState(){ super.initState(); _load(); }

  Future<void> _load() async {
    final s = await db.getAllSales();
    setState(()=>sales=s);
  }

  Future exportJson() async {
    final ps = await db.getAllProducts();
    final s = await db.getAllSales();
    final data = {
      'products': ps.map((p)=>p.toMap()).toList(),
      'sales': s.map((x)=>x.toMap()).toList(),
    };
    final dir = await getApplicationDocumentsDirectory();
    final file = File('\${dir.path}/gestion_backup_\${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(data));
    await Share.shareFiles([file.path], text: 'Sauvegarde GESTION DE VENTE ULTRA');
  }

  Future importJson() async {
    // For simplicity: not implemented UI picker in this skeleton
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import JSON non implémenté dans le squelette')));
  }

  Future clearAll() async {
    await db.deleteAllSales();
    await db.deleteAllProducts();
    await _load();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Historique effacé')));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Historique des ventes')),
      body: ListView(padding: EdgeInsets.all(12), children:[
        Row(children:[
          ElevatedButton(onPressed: exportJson, child: Text('Exporter données (.json)')),
          SizedBox(width:8),
          ElevatedButton(onPressed: importJson, child: Text('Importer données (.json)')),
          SizedBox(width:8),
          ElevatedButton(onPressed: clearAll, child: Text('Effacer tout')),
        ]),
        Divider(),
        ...sales.map((sale)=>Card(child: ListTile(
          title: Text('\${sale.productName} x\${sale.quantity}'),
          subtitle: Text('\${sale.clientName} • \${sale.clientCity} • \${sale.date}'),
          trailing: Text('\${sale.unitPrice * sale.quantity} FCFA'),
        ))).toList()
      ]),
    );
  }
}
