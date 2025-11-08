import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gestion_vente_ultra/db/database.dart';
import 'package:gestion_vente_ultra/models/product.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final db = AppDatabase();
  List<Product> products = [];

  final _formKey = GlobalKey<FormState>();
  String name='', desc='';
  int purchase=0, sale=0, qty=0;
  String? imagePath;
  Product? editing;

  @override
  void initState(){ super.initState(); _load(); }

  Future<void> _load() async {
    final ps = await db.getAllProducts();
    setState(()=>products=ps);
  }

  Future pickImage() async {
    final ip = ImagePicker();
    final XFile? f = await ip.pickImage(source: ImageSource.gallery);
    if(f!=null) setState(()=>imagePath = f.path);
  }

  Future saveProduct() async {
    if(!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final p = Product(
      id: editing?.id,
      name: name,
      description: desc,
      purchasePrice: purchase,
      salePrice: sale,
      quantity: qty,
      imagePath: imagePath
    );
    if(editing==null) await db.insertProduct(p);
    else await db.updateProduct(p);
    _resetForm();
    await _load();
  }

  void _resetForm(){
    _formKey.currentState!.reset();
    setState(()=>editing=null);
  }

  Future deleteAll() async {
    await db.deleteAllProducts();
    await _load();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Produits')),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Form(
            key: _formKey,
            child: Column(children:[
              TextFormField(
                initialValue: editing?.name,
                decoration: InputDecoration(labelText:'Nom du produit'),
                validator: (v)=> v==null||v.isEmpty ? 'Required' : null,
                onSaved: (v)=>name = v ?? '',
              ),
              TextFormField(
                initialValue: editing?.description,
                decoration: InputDecoration(labelText:'Description'),
                onSaved: (v)=>desc = v ?? '',
              ),
              TextFormField(
                initialValue: editing!=null? '\${editing!.purchasePrice}' : '',
                decoration: InputDecoration(labelText:'Prix d\'achat (FCFA)'),
                keyboardType: TextInputType.number,
                onSaved: (v)=>purchase = int.tryParse(v ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: editing!=null? '\${editing!.salePrice}' : '',
                decoration: InputDecoration(labelText:'Prix de vente (FCFA)'),
                keyboardType: TextInputType.number,
                onSaved: (v)=>sale = int.tryParse(v ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: editing!=null? '\${editing!.quantity}' : '',
                decoration: InputDecoration(labelText:'Quantité en stock'),
                keyboardType: TextInputType.number,
                onSaved: (v)=>qty = int.tryParse(v ?? '0') ?? 0,
              ),
              SizedBox(height:8),
              Row(children:[
                ElevatedButton.icon(onPressed: pickImage, icon: Icon(Icons.photo), label: Text('Choisir un fichier')),
                SizedBox(width:8),
                if(imagePath!=null) Expanded(child: Text(imagePath!)),
              ]),
              SizedBox(height:8),
              Row(children:[
                ElevatedButton(onPressed: saveProduct, child: Text(editing==null ? 'Enregistrer produit' : 'Modifier')),
                SizedBox(width:8),
                ElevatedButton(onPressed: _resetForm, child: Text('Effacer le formulaire')),
                SizedBox(width:8),
                ElevatedButton(onPressed: deleteAll, child: Text('Supprimer tous les produits')),
              ])
            ]),
          ),
          Divider(),
          Text('Liste des produits', style: TextStyle(fontWeight: FontWeight.bold)),
          ...products.map((p)=>Card(child:ListTile(
            title: Text(p.name),
            subtitle: Text('Qt: \${p.quantity} • PV: \${p.salePrice} FCFA'),
            trailing: IconButton(icon: Icon(Icons.edit), onPressed: (){
              setState((){
                editing = p;
                imagePath = p.imagePath;
              });
            }),
          ))).toList()
        ],
      ),
    );
  }
}
