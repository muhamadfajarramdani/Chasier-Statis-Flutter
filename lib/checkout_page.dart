import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final int totalItem;
  final int totalHarga;
  final int cash;

  const CheckoutPage({
    Key? key,
    required this.products,
    required this.totalItem,
    required this.totalHarga,
    required this.cash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final int kembalian = cash - totalHarga;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Struk Pembelian"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 50),
              const SizedBox(height: 8),
              const Text(
                "Coffee Shop",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text("Jl. Bogor 1, Padjajaran, Bogor"),
              const Text("No. Telp 0812-3456-7890"),
              const Text("16413520230802084636"),
              const Divider(thickness: 1, height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(now)),
                  const Text("Kasir: Fajar"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('HH:mm:ss').format(now)),
                  const Text("No. 0-3", style: TextStyle(color: Colors.green)),
                ],
              ),
              const Divider(height: 24),

              // Produk
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: products.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final product = entry.value;
                  final String name = product['name'];
                  final int qty = product['quantity'];
                  final int price = product['price'];
                  final int total = qty * price;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$index. $name",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  $qty x ${currencyFormat.format(price)}"),
                            Text(currencyFormat.format(total)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total QTY :"),
                  Text("$totalItem"),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sub Total"),
                  Text(currencyFormat.format(totalHarga)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(totalHarga),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Cash"),
                  Text(currencyFormat.format(cash)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Kembalian"),
                  Text(currencyFormat.format(kembalian < 0 ? 0 : kembalian)),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Terimakasih Telah Berbelanja"),
              const SizedBox(height: 4),
              const Text("Link Kritik dan Saran:"),
              const Text(
                "bit.ly/karis-feedback",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text('Tutup', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
