import 'package:flutter/material.dart';
import 'package:gestion_vente_ultra/db/database.dart';
import 'package:gestion_vente_ultra/models/product.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Product> products = [];
  int totalStock = 0;
  int totalValue = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = AppDatabase();
    final ps = await db.getAllProducts();
    int stock = 0;
    int value = 0;
    for(final p in ps) {
      stock += p.quantity;
      value += p.quantity * p.salePrice;
    }
    setState(() {
      products = ps;
      totalStock = stock;
      totalValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<Product, String>(
        id: 'Stock',
        domainFn: (Product p, _) => p.name,
        measureFn: (Product p, _) => p.quantity,
        data: products,
      )
    ];

    return Scaffold(
      appBar: AppBar(title: Text('GESTION DE VENTE ULTRA')),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              child: ListTile(
                title: Text('Total produits'),
                trailing: Text('\${products.length}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Stock global'),
                trailing: Text('\$totalStock'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Valeur du stock (FCFA)'),
                trailing: Text('\$totalValue'),
              ),
            ),
            SizedBox(height:12),
            SizedBox(height:200, child: charts.BarChart(series, animate: true)),
            SizedBox(height:12),
            Wrap(
              spacing:8,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.inventory),
                  label: Text('Gérer produits'),
                  onPressed: ()=>Navigator.pushNamed(context,'/products').then((_)=>_loadStats()),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.point_of_sale),
                  label: Text('Vente'),
                  onPressed: ()=>Navigator.pushNamed(context,'/sales').then((_)=>_loadStats()),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.history),
                  label: Text('Historique'),
                  onPressed: ()=>Navigator.pushNamed(context,'/history'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
