import 'package:flutter/material.dart';
import 'package:gestion_vente_ultra/db/database.dart';
import 'package:gestion_vente_ultra/models/product.dart';
import 'package:gestion_vente_ultra/models/sale.dart';
import 'package:intl/intl.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final db = AppDatabase();
  List<Product> products = [];
  Product? selected;
  int qty = 1;
  String clientName='', city='', phone='';

  @override
  void initState(){ super.initState(); _load(); }

  Future<void> _load() async {
    final ps = await db.getAllProducts();
    setState(()=>products=ps);
  }

  Future recordSale() async {
    if(selected==null) return;
    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final s = Sale(
      productId: selected!.id!,
      productName: selected!.name,
      quantity: qty,
      unitPrice: selected!.salePrice,
      clientName: clientName,
      clientCity: city,
      clientPhone: phone,
      date: now,
    );
    await db.insertSale(s);
    // update product quantity
    selected!.quantity = selected!.quantity - qty;
    await db.updateProduct(selected!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vente enregistrée')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Vente & Facturation')),
      body: ListView(padding: EdgeInsets.all(12), children:[
        DropdownButtonFormField<Product>(
          items: products.map((p)=>DropdownMenuItem(value:p, child: Text('\${p.name} (Qt:\${p.quantity})'))).toList(),
          onChanged: (v)=>setState(()=>selected=v),
          decoration: InputDecoration(labelText:'Produit'),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          initialValue: '1',
          decoration: InputDecoration(labelText:'Quantité vendue'),
          onChanged: (v)=>qty = int.tryParse(v) ?? 1,
        ),
        TextFormField(
          decoration: InputDecoration(labelText:'Ville du client'),
          onChanged: (v)=>city = v,
        ),
        TextFormField(
          decoration: InputDecoration(labelText:'Nom du client'),
          onChanged: (v)=>clientName = v,
        ),
        TextFormField(
          decoration: InputDecoration(labelText:'Numéro du client'),
          keyboardType: TextInputType.phone,
          onChanged: (v)=>phone = v,
        ),
        SizedBox(height:12),
        ElevatedButton(onPressed: recordSale, child: Text('Enregistrer & Facturer')),
      ]),
    );
  }
}
