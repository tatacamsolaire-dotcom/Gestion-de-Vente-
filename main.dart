import 'package:flutter/material.dart';
import 'package:gestion_vente_ultra/pages/dashboard.dart';
import 'package:gestion_vente_ultra/pages/products_page.dart';
import 'package:gestion_vente_ultra/pages/sales_page.dart';
import 'package:gestion_vente_ultra/pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GestionVenteUltraApp());
}

class GestionVenteUltraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GESTION DE VENTE ULTRA',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardPage(),
      routes: {
        '/products': (_) => ProductsPage(),
        '/sales': (_) => SalesPage(),
        '/history': (_) => HistoryPage(),
      },
    );
  }
}
