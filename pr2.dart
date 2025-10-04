import 'dart:io';
import 'dart:math';

const int size = 10;

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
    if (grid[y][x].hit || grid[y][x].miss) {
      return false;
    }
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
}

class Game {
  Board player1 = Board();
  Board player2 = Board();
  bool vsAI;
  Random rand = Random();

  static int playerWins = 0;
  static int aiWins = 0;

  Game(this.vsAI);

  void randomPlacement(Board board) {
    List<int> ships = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
    for (var ship in ships) {
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
    List<int> ships = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
    for (var ship in ships) {
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
        print(hit ? "Игрок 1 попал!" : "Игрок 1 промахнулся!");
        if (player2.allShipsDestroyed()) {
          print("Игрок 1 победил!");
          playerWins++;
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
          print(
              "Компьютер стреляет в ${String.fromCharCode(65 + y)}$x и ${hit ? "попадает!" : "промахивается!"}");
          if (player1.allShipsDestroyed()) {
            print("Компьютер победил!");
            aiWins++;
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
          print(hit ? "Игрок 2 попал!" : "Игрок 2 промахнулся!");
          if (player1.allShipsDestroyed()) {
            print("Игрок 2 победил!");
            aiWins++; 
            break;
          }
        }
      }
      turn = !turn;
    }

    print("\nТекущий счёт: Игрок 1 – $playerWins | Соперник – $aiWins");

    print("\nХотите сыграть ещё раз? (y/n)");
    if (stdin.readLineSync()?.toLowerCase() == "y") {
      Game(vsAI).play(manual: manual);
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
