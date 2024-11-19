import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:putri_surya/screens/menu.dart';
import 'package:putri_surya/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formkey = GlobalKey<FormState>();
  String _productName = "";
  int _productPrice = 0;
  String _productDescription = "";
  int _productQuantity = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'Tambahkan Produk baru yang dijual',
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            drawer: const LeftDrawer(),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 255,
                        decoration: InputDecoration(
                          hintText: "Product",
                          labelText: "Product",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _productName = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Nama produk tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Description",
                          labelText: "Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _productDescription = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Produk harus memiliki deskripsi tercantum!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Price",
                          labelText: "Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _productPrice = int.tryParse(value!) ?? 0;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Harga Produk tidak boleh kosong!";
                          }
                          if (int.tryParse(value) == null) {
                            return "Harga Produk harus berupa angka!";
                          } 
                          if (int.tryParse(value) != null) {
                            int tmpHargaProduk = int.parse(value);
                            if (tmpHargaProduk <= 0) {
                              return "Produk tak berharga?";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Quantity",
                          labelText: "Quantity",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _productQuantity = int.tryParse(value!) ?? 0;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Kuantitas Produk tidak boleh kosong!";
                          }
                          if (int.tryParse(value) == null) {
                            return "Kuantitas Produk harus berupa angka!";
                          } 
                          if (int.tryParse(value) != null) {
                            int tmpHargaProduk = int.parse(value);
                            if (tmpHargaProduk <= 0) {
                              return "Produknya tak ada?";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Produk telah berhasil tersimpan'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Nama Produk: $_productName'),
                                          Text('Deskripsi Produk: $_productDescription'),
                                          Text('Harga Produk: $_productPrice'),
                                          Text('Kuantitas Produk: $_productQuantity'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        // onPressed: () {
                                        //   Navigator.pop(context);
                                          // _formkey.currentState!.reset();
                                        // },
                                        onPressed: () async {
                                          if (_formkey.currentState!.validate()) {
                                              // Kirim ke Django dan tunggu respons
                                              // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                              final response = await request.postJson(
                                                  "http://127.0.0.1:8000/create-flutter/",
                                                  jsonEncode(<String, String>{
                                                  // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                                      'name': _productName,
                                                      'price': _productPrice.toString(),
                                                      'description': _productDescription,
                                                      'quantity': _productQuantity.toString(),
                                                  }),
                                              );
                                              if (context.mounted) {
                                                  if (response['status'] == 'success') {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(const SnackBar(
                                                      content: Text("Produk baru berhasil disimpan!"),
                                                      ));
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => MyHomePage()),
                                                      );
                                                  } else {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(const SnackBar(
                                                          content:
                                                              Text("Terdapat kesalahan, silakan coba lagi."),
                                                      ));
                                                  }
                                              }
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}