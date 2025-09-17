import 'dart:io';

void main() {
  // Меню кафе (Map: название → цена)
  final Map<String, double> menu = {
    "Кофе": 120.0,
    "Чай": 80.0,
    "Пирожное": 150.0,
    "Сэндвич": 200.0,
  };

  // Список заказанных позиций
  List<String> order = [];

  print("Добро пожаловать в кафе!\nМеню:");
  menu.forEach((item, price) {
    print(" - $item : $price руб.");
  });

  while (true) {
    stdout.write("\nВведите название блюда (или 'стоп'): ");
    String? input = stdin.readLineSync();

    if (input == null || input.toLowerCase() == "стоп") {
      break;
    }

    // Проверка наличия блюда
    if (menu.containsKey(input)) {
      order.add(input);
      print("Добавлено: $input");
    } else {
      print("Такого блюда нет в меню.");
    }
  }

  // Расчёт итоговой суммы
  double total = 0;
  for (var item in order) {
    total += menu[item]!;
  }

  // Используем оператор is
  if (total is double) {
    print("\nВаш заказ: ${order.join(", ")}");
    print("Итоговая сумма: $total руб.");
  }

  // Пример использования dynamic
  dynamic discount = total > 500 ? 0.9 : 1; // скидка 10%, если заказ > 500
  double finalPrice = total * discount;

  print("С учетом скидки: $finalPrice руб.");
}