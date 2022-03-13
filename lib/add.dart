import 'package:flutter/material.dart';
import 'package:latihan/api.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

class AddData extends StatefulWidget {
  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController KodeProdukController = TextEditingController();
  final TextEditingController NamaProdukController = TextEditingController();
  final TextEditingController StockProdukController = TextEditingController();
  final TextEditingController HargaProdukController = TextEditingController();

  Future fetchProducts()async {
    String tambahdata = "${ApiHomeData.TambahData}";
    final response = await http.post(Uri.parse(tambahdata), body: {
      "kode_produk": KodeProdukController.text,
      "nama_produk": NamaProdukController.text,
      "stock": StockProdukController.text,
      "harga": HargaProdukController.text
    });
    debugPrint("Response : " + response.body);
    debugPrint("Status Code : " + (response.statusCode).toString());
    debugPrint("Headers : " + (response.headers).toString());
    return productsFromJson(response.body);
  }

  late String kodeProduk, namaProduk, stock, harga;

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
                    controller: KodeProdukController,
                    onSaved: (e) => kodeProduk = e!,
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
                    controller: NamaProdukController,
                    keyboardType: TextInputType.text,
                    onSaved: (e) => namaProduk = e!,
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
                    controller: StockProdukController,
                    onSaved: (e) => stock = e!,
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
                      controller: HargaProdukController,
                      onSaved: (e) => harga = e!,
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
                    fetchProducts();
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
        title: Text('Tambah Produk Barang',
        style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: _listAddProduct(),
    );
  }
}
