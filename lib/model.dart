// To parse this JSON data, do
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String welcomeToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {

  String id;
  String kodeProduk;
  String namaProduk;
  String stock;
  String harga;

  Products({
    required this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.stock,
    required this.harga,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        kodeProduk: json["kode_produk"],
        namaProduk: json["nama_produk"],
        stock: json["stock"],
        harga: json["harga"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_produk": kodeProduk,
        "nama_produk": namaProduk,
        "stock": stock,
        "harga": harga,
      };
}
