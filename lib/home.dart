import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan/add.dart';
import 'package:latihan/api.dart';
import 'package:latihan/edit.dart';
import 'package:latihan/model.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Products> daftarProducts;
  bool loading = false;

  Future<void> refreshProduk() async {
    setState(() {
      daftarProducts = fetchProducts() as Future<Products>;
    });
  }

  _delete(String id) async {
    String deletedata = "${ApiHomeData.DeleteProducts}";
    final response = await http.post(Uri.parse(deletedata),
    body: {
      "id": id,
    });
    final message = productsFromJson(response.body);
    if (message == "Data berhasil dihapus"){
      setState(() {
        refreshProduk();
      });
    }else{
      print('Data tidak terhapus');
    }
    debugPrint("Response : " + response.body);
    debugPrint("Status Code : " +(response.statusCode).toString());
    debugPrint("Headers : "+(response.headers.toString()));
    return productsFromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    daftarProducts = fetchProducts() as Future<Products>;
  }

  final list = [];
  Future <List<Products>> fetchProducts() async {
    list.clear();
    setState(() {
      loading = true;
    });
    String lihatProducts = "${ApiHomeData.lihatProducts}";
    final response = await http.get(Uri.parse(lihatProducts));
    if(response.contentLength == 2){
      debugPrint('Status Code : ' + (response.statusCode).toString());
      debugPrint('Headers : ' + (response.headers).toString());
    }else{
      final data = productsFromJson(response.body);
      data.forEach((api) {
        final value = new Products(
          id: '',
          kodeProduk: '',
          namaProduk: '',
          stock: '',
          harga: ''
        );
        list.add(value);
      });
    }
    setState(() {
      loading = false;
    });
    return productsFromJson(response.body);
  }

  Widget _buildContent(){
    return RefreshIndicator(
      onRefresh: () => refreshProduk(),
      child: Container(
        child: FutureBuilder(
          future: fetchProducts(),
          builder: (context, AsyncSnapshot snapshot){
            if (snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index){
                  Products products = snapshot.data![index];
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Text('${products.kodeProduk}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          title: Text('Nama Produk : ${products.namaProduk}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text('Harga Produk : Rp.${products.harga}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          trailing: Text('${products.stock}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:<Widget>[
                          IconButton(
                          icon: Icon(Icons.edit, size: 18,),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditData(products: products, refreshProduk: refreshProduk)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, size: 18,),
                          onPressed: (){
                            _delete(products.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toko Database Latihan"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => AddData()));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }
}
