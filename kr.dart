

void main() {
  var coffee = MenuItem(name: 'Компот', price: 300);
  var tea = MenuItem(name: 'Чай', price: 150);
  var sandwich = MenuItem(name: 'Кофе', price: 250);

  var order1 = Order();
  order1.addItem(coffee);
  order1.addItem(sandwich);

  print('Сумма заказа: ${order1.totalPrice()?.toString() ?? '0'} руб');

  Order? order2;
  print('Сумма второго заказа: ${order2?.totalPrice() ?? 'Заказ пуст'}');

  var order3 = Order()
    ..addItem(tea)
    ..addItem(sandwich)
    ..addItem(coffee);

  print('Сумма третьего заказа: ${order3.totalPrice()} руб');
}

class MenuItem {
  String name;
  int price;

  MenuItem({required this.name, required this.price});
}

class Order {
  List<MenuItem> items = [];

  void addItem(MenuItem item) {
    items.add(item);
  }

  int? totalPrice() {
    if (items.isEmpty) return null;
    int total = 0;
    for (var item in items) {
      total += item.price;
    }
    return total;
  }
}