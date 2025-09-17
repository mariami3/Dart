

void main() {
  List<String> movies = ["Оно", "Матрица"];
  print(movies);

  movies.add("Мы");
  print(movies);

  movies.removeAt(1);
  print(movies);

  List<String> newMovies = movies.map((movie) => "$movie movie").toList();
  print(newMovies);

  int index = movies.indexOf("Оно");
  print(index);
}