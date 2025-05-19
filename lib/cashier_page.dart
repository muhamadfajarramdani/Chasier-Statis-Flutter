import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  late List<Map<String, dynamic>> allProducts;
  late List<Map<String, dynamic>> products;

  int _totalItem = 0;
  int _totalHarga = 0;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allProducts = [
      {
        "image": "assets/images/cokelatsusu.jpg",
        "name": "Adidas Shoes",
        "price": 30000,
        "stock": 10,
        "quantity": 0,
      },
      {
        "image": "assets/images/kopihitam.jpg",
        "name": "Border Figure Noel/Liam Gallagher",
        "price": 15000,
        "stock": 15,
        "quantity": 0,
      },
      {
        "image": "assets/images/rotibakar.jpg",
        "name": "Dickies/Carhartt Pants",
        "price": 10000,
        "stock": 6,
        "quantity": 0,
      },
      {
        "image": "assets/images/cokelatsusu.jpg",
        "name": "Jersey Beckham",
        "price": 5000,
        "stock": 1,
        "quantity": 0,
      },
    ];
    products = List<Map<String, dynamic>>.from(allProducts);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        products = List<Map<String, dynamic>>.from(allProducts);
      } else {
        products = allProducts
            .where((product) =>
                product['name'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _TambahItemBeli(int index) async {
    setState(() {
      if (products[index]['stock'] > 0) {
        products[index]['stock']--;
        products[index]['quantity'] = (products[index]['quantity'] ?? 0) + 1;
        _totalItem++;
        _totalHarga += products[index]['price'] as int;
      }
    });
  }

  Future<void> _KurangItemBeli(int index) async {
    setState(() {
      if (products[index]['quantity'] > 0) {
        products[index]['stock']++;
        products[index]['quantity'] = (products[index]['quantity'] ?? 0) - 1;
        _totalItem--;
        _totalHarga -= products[index]['price'] as int;
      }
    });
  }

  void _showPaymentSheet() {
    final TextEditingController _cashController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 32,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.payments, size: 48, color: Colors.brown),
              const SizedBox(height: 8),
              const Text(
                "Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Pembelian:", style: TextStyle(fontSize: 16)),
                  Text(
                    "Rp. $_totalHarga",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cashController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Masukkan nominal pembayaran',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text(
                    "Bayar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final cash = int.tryParse(_cashController.text) ?? 0;
                    if (cash < _totalHarga) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uang tidak cukup untuk membayar!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.pop(context); // Tutup modal
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            products: products.where((p) => p['quantity'] > 0).toList(),
                            totalItem: _totalItem,
                            totalHarga: _totalHarga,
                            cash: cash,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cashier App",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
                const Text(
                  "Semoga harimu menyenangkan 🙂",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                  child: Image.asset(
                                    product["image"],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product["name"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "Stok: ${product["stock"]}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        "Rp. ${product["price"]}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: product['quantity'] > 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (product['quantity'] > 0) {
                                          _KurangItemBeli(index);
                                        }
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Center(
                                      child: Visibility(
                                        visible: product['quantity'] > 0,
                                        child: Text(
                                          "${product['quantity']}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (product['stock'] > 0) {
                                        _TambahItemBeli(index);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Stock Kosong!"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Icon(
                                        Icons.add_circle_outline_outlined,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPaymentSheet();
                },
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                label: Text(
                  "Total ($_totalItem item) = Rp. $_totalHarga",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
