import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AplikasiMakanan(),
    );
  }
}

class AplikasiMakanan extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem("Burger Classic", "Deskripsi Burger Classic", 30000, "assets/burger_classic.jpg"),
    MenuItem("Double Cheeseburger", "Deskripsi Double Cheeseburger", 35000, "assets/double_cheeseburger.jpg"),
    // Tambahkan item menu lainnya di sini
  ];

  final List<MenuItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Burger"),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuDetailPage(menuItems[index], (quantity) {
                    if (quantity > 0) {
                      cartItems.add(menuItems[index].copyWithQuantity(quantity));
                    }
                  }),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Image.asset(menuItems[index].imagePath),
                title: Text(menuItems[index].name),
                subtitle: Text(menuItems[index].description),
                trailing: Text("Rp ${menuItems[index].price}"),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (cartItems.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutPage(cartItems),
              ),
            );
          }
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class MenuDetailPage extends StatefulWidget {
  final MenuItem menuItem;
  final Function(int) onAddToCart;

  MenuDetailPage(this.menuItem, this.onAddToCart);

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int quantity = 1;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.menuItem.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
      ),
      body: Column(
        children: [
          Image.asset(widget.menuItem.imagePath),
          Text("Deskripsi: ${widget.menuItem.description}"),
          Text("Harga: Rp ${widget.menuItem.price}"),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: decreaseQuantity,
              ),
              Text(quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: increaseQuantity,
              ),
            ],
          ),
          Text("Total: Rp $total"),
          ElevatedButton(
            onPressed: () {
              widget.onAddToCart(quantity);
              Navigator.pop(context); // Kembali ke daftar menu
            },
            child: Text("Tambah ke Keranjang"),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String description;
  final int price;
  final String imagePath;
  int quantity;

  MenuItem(this.name, this.description, this price, this.imagePath, this.quantity);

  MenuItem copyWithQuantity(int quantity) {
    return MenuItem(name, description, price, imagePath, quantity);
  }
}

class CheckoutPage extends StatelessWidget {
  final List<MenuItem> cartItems;

  CheckoutPage(this.cartItems);

  int calculateTotal() {
    int total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang Pesanan"),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].name),
            subtitle: Text("Harga: Rp ${cartItems[index].price} x ${cartItems[index].quantity}"),
            trailing: Text("Rp ${cartItems[index].price * cartItems[index].quantity}"),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Harga:"),
                  Text("Rp ${calculateTotal()}"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk memproses pesanan
                  // Misalnya, mengirim pesanan ke dapur atau sistem pembayaran
                  Navigator.pop(context); // Kembali ke daftar menu
                },
                child: Text("Pesan Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
