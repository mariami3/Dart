import 'dart:io';
import 'dart:math';

const int size = 10;
const List<int> shipLengths = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
const int totalShipCells = 20; // Сумма всех палуб

class Cell {
  bool ship = false;
  bool hit = false;
  bool miss = false;
}

class Board {
  List<List<Cell>> grid =
      List.generate(size, (_) => List.generate(size, (_) => Cell()));

  void display({bool hideShips = false}) {
    stdout.write("   ");
    for (int i = 0; i < size; i++) stdout.write("$i ");
    print("");
    for (int y = 0; y < size; y++) {
      stdout.write("${String.fromCharCode(65 + y)}  ");
      for (int x = 0; x < size; x++) {
        Cell c = grid[y][x];
        if (c.hit) {
          stdout.write("X ");
        } else if (c.miss) {
          stdout.write("• ");
        } else if (c.ship && !hideShips) {
          stdout.write("O ");
        } else {
          stdout.write("~ ");
        }
      }
      print("");
    }
  }

  bool placeShip(int x, int y, int length, bool horizontal) {
    if (horizontal) {
      if (x + length > size) return false;
      for (int i = 0; i < length; i++) {
        if (grid[y][x + i].ship) return false;
      }
      for (int i = 0; i < length; i++) {
        grid[y][x + i].ship = true;
      }
    } else {
      if (y + length > size) return false;
      for (int i = 0; i < length; i++) {
        if (grid[y + i][x].ship) return false;
      }
      for (int i = 0; i < length; i++) {
        grid[y + i][x].ship = true;
      }
    }
    return true;
  }

  bool shoot(int x, int y) {
    if (grid[y][x].hit || grid[y][x].miss) return false;
    if (grid[y][x].ship) {
      grid[y][x].hit = true;
      return true;
    } else {
      grid[y][x].miss = true;
      return false;
    }
  }

  bool allShipsDestroyed() {
    for (var row in grid) {
      for (var cell in row) {
        if (cell.ship && !cell.hit) return false;
      }
    }
    return true;
  }

  int countRemainingShips() {
    int remaining = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (cell.ship && !cell.hit) remaining++;
      }
    }
    return remaining;
  }

  int countDestroyedShips() {
    int destroyed = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (cell.ship && cell.hit) destroyed++;
      }
    }
    return destroyed;
  }
}

class PlayerStats {
  int hits = 0;
  int misses = 0;
  int turns = 0;

  int get totalShots => hits + misses;
}

class Game {
  Board player1 = Board();
  Board player2 = Board();
  bool vsAI;
  Random rand = Random();

  PlayerStats stats1 = PlayerStats();
  PlayerStats stats2 = PlayerStats();

  Game(this.vsAI);

  void randomPlacement(Board board) {
    for (var ship in shipLengths) {
      bool placed = false;
      while (!placed) {
        int x = rand.nextInt(size);
        int y = rand.nextInt(size);
        bool horizontal = rand.nextBool();
        placed = board.placeShip(x, y, ship, horizontal);
      }
    }
  }

  void manualPlacement(Board board) {
    for (var ship in shipLengths) {
      bool placed = false;
      while (!placed) {
        print("Введите координаты для корабля длиной $ship (например, A5):");
        String? input = stdin.readLineSync();
        print("Введите направление (h - горизонтально, v - вертикально):");
        String? dir = stdin.readLineSync();

        if (input == null || input.length < 2) {
          print("Ошибка: неправильный ввод!");
          continue;
        }

        int y = input.codeUnitAt(0) - 65;
        int? x = int.tryParse(input.substring(1));
        bool horizontal = (dir?.toLowerCase() == "h");

        if (x == null || x < 0 || x >= size || y < 0 || y >= size) {
          print("Ошибка: неверные координаты!");
          continue;
        }

        placed = board.placeShip(x, y, ship, horizontal);
        if (!placed) {
          print("Ошибка: нельзя разместить корабль здесь!");
        } else {
          board.display();
        }
      }
    }
  }

  List<int>? parseInput(String? input) {
    if (input == null || input.length < 2) return null;
    int y = input.codeUnitAt(0) - 65;
    int? x = int.tryParse(input.substring(1));
    if (x == null || x < 0 || x >= size || y < 0 || y >= size) return null;
    return [x, y];
  }

  void saveStats(String winner) {
    final dir = Directory('stats');
    if (!dir.existsSync()) dir.createSync();
    final file = File('stats/game_stats.txt');

    String statsText = '''
Результат игры:
Победитель: $winner
---
Игрок 1:
  Попаданий: ${stats1.hits}
  Промахов: ${stats1.misses}
  Всего выстрелов: ${stats1.totalShots}
  Уничтожено палуб противника: ${player2.countDestroyedShips()}
  Осталось своих палуб: ${player1.countRemainingShips()}/$totalShipCells
  Количество ходов: ${stats1.turns}

${vsAI ? "Компьютер" : "Игрок 2"}:
  Попаданий: ${stats2.hits}
  Промахов: ${stats2.misses}
  Всего выстрелов: ${stats2.totalShots}
  Уничтожено палуб противника: ${player1.countDestroyedShips()}
  Осталось своих палуб: ${player2.countRemainingShips()}/$totalShipCells
  Количество ходов: ${stats2.turns}
''';

    file.writeAsStringSync(statsText);
    print("\nСтатистика игры сохранена в stats/game_stats.txt");
  }

  void play({bool manual = false}) {
    if (manual) {
      print("Ручная расстановка кораблей для Игрока 1:");
      manualPlacement(player1);
    } else {
      randomPlacement(player1);
    }
    randomPlacement(player2);

    bool turn = true;
    while (true) {
      print("\nПоле игрока 1:");
      player1.display();
      print("\nПоле соперника:");
      player2.display(hideShips: true);

      if (turn) {
        print("\nИгрок 1, ваш ход (например, A5):");
        String? input = stdin.readLineSync();
        var coords = parseInput(input);
        if (coords == null) {
          print("Ошибка: неверный ввод!");
          continue;
        }
        bool hit = player2.shoot(coords[0], coords[1]);
        stats1.turns++;
        if (hit) {
          stats1.hits++;
          print("Игрок 1 попал!");
        } else {
          stats1.misses++;
          print("Игрок 1 промахнулся!");
        }
        if (player2.allShipsDestroyed()) {
          print("Игрок 1 победил!");
          saveStats("Игрок 1");
          break;
        }
      } else {
        if (vsAI) {
          print("\nХод компьютера...");
          int x, y;
          do {
            x = rand.nextInt(size);
            y = rand.nextInt(size);
          } while (player1.grid[y][x].hit || player1.grid[y][x].miss);

          bool hit = player1.shoot(x, y);
          stats2.turns++;
          if (hit) {
            stats2.hits++;
          } else {
            stats2.misses++;
          }
          print(
              "Компьютер стреляет в ${String.fromCharCode(65 + y)}$x и ${hit ? "попадает!" : "промахивается!"}");
          if (player1.allShipsDestroyed()) {
            print("Компьютер победил!");
            saveStats("Компьютер");
            break;
          }
        } else {
          print("\nИгрок 2, ваш ход (например, B7):");
          String? input = stdin.readLineSync();
          var coords = parseInput(input);
          if (coords == null) {
            print("Ошибка: неверный ввод!");
            continue;
          }
          bool hit = player1.shoot(coords[0], coords[1]);
          stats2.turns++;
          if (hit) {
            stats2.hits++;
            print("Игрок 2 попал!");
          } else {
            stats2.misses++;
            print("Игрок 2 промахнулся!");
          }
          if (player1.allShipsDestroyed()) {
            print("Игрок 2 победил!");
            saveStats("Игрок 2");
            break;
          }
        }
      }
      turn = !turn;
    }
  }
}

void main() {
  print("Морской бой");
  print("1. Играть против компьютера");
  print("2. Играть против другого игрока");
  String? choice = stdin.readLineSync();

  print("Выберите способ расстановки кораблей:");
  print("1. Случайная");
  print("2. Ручная");
  String? setup = stdin.readLineSync();

  Game(choice == "1").play(manual: setup == "2");
}
