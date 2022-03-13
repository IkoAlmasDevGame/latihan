import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latihan/api.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final Products products;
  final VoidCallback refreshProduk;
  EditData({required this.products, required this.refreshProduk});
  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final formKey = GlobalKey<FormState>();

  check(){
    final form = formKey.currentState;
    if(form!.validate()){
    form.save();
    submit();
      }else{}
    }

    late TextEditingController kodeProduk;
    late TextEditingController namaProduk;
    late TextEditingController stock;
    late TextEditingController harga;

    setUp() {
      kodeProduk = TextEditingController(text: widget.products.kodeProduk);
      namaProduk = TextEditingController(text: widget.products.namaProduk);
      stock = TextEditingController(text: widget.products.stock);
      harga = TextEditingController(text: widget.products.harga);
    }

    Future submit() async{
      String editdata = "${ApiHomeData.EditProducts}";
      final response = await http.post(Uri.parse(editdata),
      body: {
        "kode_produk": kodeProduk.text,
        "nama_produk": namaProduk.text,
        "stock": stock.text,
        "harga": harga.text,
        "id": widget.products.id,
      });
      final message = json.encode(response.body);
      debugPrint("Pesan : " + message.toString());
      debugPrint("Status Code : " + (response.statusCode).toString());
      debugPrint("Headers : " + (response.headers).toString());
      return productsFromJson(response.body);
    }

    void initState(){
    super.initState();
    setUp();
    }

  Widget _listAddProduct(){
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: kodeProduk,
                    onSaved: (e) => kodeProduk = e! as TextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Kode Produk",
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      icon: Icon(Icons.code, size: 32,),
                    ),
                    autofocus: false,
                    maxLength: 255,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: namaProduk,
                    keyboardType: TextInputType.text,
                    onSaved: (e) => namaProduk = e! as TextEditingController,
                    decoration: InputDecoration(
                      labelText: "Nama Produk",
                      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      icon: Icon(Icons.widgets, size: 32,),
                    ),
                    autofocus: false,
                    maxLength: 255,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: stock,
                      onSaved: (e) => stock = e! as TextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Stock Barang",
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        icon: Icon(Icons.production_quantity_limits, size: 32,),
                      ),
                      autofocus: false,
                      maxLength: 11
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: harga,
                      onSaved: (e) => harga = e! as TextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Harga Barang",
                        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        icon: Icon(Icons.price_change, size: 32,),
                      ),
                      autofocus: false,
                      maxLength: 11
                  ),
                ),
                RaisedButton(
                  child: Text("SIMPAN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    submit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Produk Barang',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: _listAddProduct(),
    );
  }
}
