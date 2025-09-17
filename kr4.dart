void main() {

  
  // 1. Подсчёт вхождения каждого символа двумя способами
  String text =
      "Представим ситуацию, что у нас имеется вложенный цикл (цикл в цикле).";

  var freq1 = <String, int>{};
  for (var ch in text.split('')) {
    freq1[ch] = (freq1[ch] ?? 0) + 1;
  }
  print("Частота символов (способ 1): $freq1");

  var freq2 = <String, int>{};
  text.split('').forEach((ch) {
    freq2[ch] = (freq2[ch] ?? 0) + 1;
  });
  print("Частота символов (способ 2): $freq2");





  // 2. Числа от 23 до 35
  print("\nЧисла от 23 до 35 (for):");
  for (int i = 23; i <= 35; i++) {
    print(i);
  }

  print("\nЧисла от 23 до 35 (while):");
  int j = 23;
  while (j <= 35) {
    print(j);
    j++;
  }

  print("\nЧисла от 23 до 35 (do-while):");
  int k = 23;
  do {
    print(k);
    k++;
  } while (k <= 35);




  // 3. Список от 0 до 99
  var list1 = List.generate(100, (i) => i);
  print("\nСписок 0–99: $list1");




  // 4. Список только тех чисел, что делятся на 5
  var list2 = [for (var x in list1) if (x % 5 == 0) x];
  print("\nЧисла, делящиеся на 5: $list2");





  // 5. Числа от -35 до -1 с шагом 1, 4, 7
  print("\nДиапазон шаг 1:");
  for (int i = -35; i <= -1; i++) {
    print(i);
  }

  print("\nДиапазон шаг 4:");
  for (int i = -35; i <= -1; i += 4) {
    print(i);
  }

  print("\nДиапазон шаг 7:");
  for (int i = -35; i <= -1; i += 7) {
    print(i);
  }




  // 6. Минимум и максимум из a, b, c
  int a = 12, b = 5, c = 42;
  int maxVal = a;
  if (b > maxVal) maxVal = b;
  if (c > maxVal) maxVal = c;

  int minVal = a;
  if (b < minVal) minVal = b;
  if (c < minVal) minVal = c;

  print("\nМаксимум: $maxVal, Минимум: $minVal");





  // 7. Обратный список
  var arr1 = [4, 5, 6, 7, 2, 1, 2, 3, 4];
  print("\nОбратный список: ${arr1.reversed.toList()}");




  // 8. Все элементы кроме 2 и 6
  print("\nСписок без 2 и 6:");
  for (var x in arr1) {
    if (x == 2 || x == 6) continue;
    print(x);
  }





  // 9. Сумма элементов списка
  int sum = arr1.fold(0, (a, b) => a + b);
  print("\nСумма элементов: $sum");




  // 10. Среднее арифметическое
  var arr2 = [4, 5, 6, 7, 30, 22, 2, 39, 41];
  double avg = arr2.reduce((a, b) => a + b) / arr2.length;
  print("\nСреднее арифметическое: $avg");




  // 11. Удаление дубликатов
  var arr3 = [1, 3, 4, 1, 4, 5, 7, 3, 8, 5];
  var unique = arr3.toSet().toList();
  print("\nУникальные элементы: $unique");




  // 12. Switch-case для гласных и согласных
  String letter = 'о';
  switch (letter) {
    case 'а':
    case 'о':
    case 'у':
    case 'э':
    case 'ы':
    case 'я':
    case 'ё':
    case 'ю':
    case 'и':
    case 'е':
      print("\n$letter — гласная");
      break;
    default:
      print("\n$letter — согласная");
  }






  // 13. Элементы с индексами
  print("\nЭлементы с индексами:");
  for (int i = 0; i < arr1.length; i++) {
    print("Индекс $i -> ${arr1[i]}");
  }






  // 14. Switch-case диапазон от 0 до 5
  int number = 3;
  switch (number) {
    case 0:
      print("\nЧисло равно 0");
      break;
    case 1:
      print("Число равно 1");
      break;
    case 2:
      print("Число равно 2");
      break;
    case 3:
      print("Число равно 3");
      break;
    case 4:
      print("Число равно 4");
      break;
    case 5:
      print("Число равно 5");
      break;
    default:
      print("Число вне диапазона 0–5");
  }
}
