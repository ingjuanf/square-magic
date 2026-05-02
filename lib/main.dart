import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SquareMagicApp());
}

class SquareMagicApp extends StatelessWidget {
  const SquareMagicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Square Magic',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          centerTitle: true,
        ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  final List<List<int>> solution = [
    [8, 1, 6],
    [3, 5, 7],
    [4, 9, 2],
  ];

  late List<List<int?>> board;

  late List<List<bool>> fixedCells;

  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    generateBoard();
  }

  void generateBoard() {

    board = [
      [8, 1, 6],
      [3, 5, 7],
      [4, 9, 2],
    ];

    fixedCells = [
      [true, true, true],
      [true, true, true],
      [true, true, true],
    ];

    Random random = Random();

    int hiddenCount = 0;

    while (hiddenCount < 5) {

      int row = random.nextInt(3);
      int col = random.nextInt(3);

      if (board[row][col] != null) {

        board[row][col] = null;

        fixedCells[row][col] = false;

        hiddenCount++;
      }
    }
  }

  void selectCell(int row, int col) {

    if (fixedCells[row][col]) {
      return;
    }

    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void insertNumber(int number) {

    if (selectedRow == null || selectedCol == null) {
      return;
    }

    setState(() {
      board[selectedRow!][selectedCol!] = number;
    });
  }

  void clearCell() {

    if (selectedRow == null || selectedCol == null) {
      return;
    }

    if (fixedCells[selectedRow!][selectedCol!]) {
      return;
    }

    setState(() {
      board[selectedRow!][selectedCol!] = null;
    });
  }

  bool isMagicSquare() {

    for (int i = 0; i < 3; i++) {

      int sum = 0;

      for (int j = 0; j < 3; j++) {

        if (board[i][j] == null) {
          return false;
        }

        sum += board[i][j]!;
      }

      if (sum != 15) {
        return false;
      }
    }

    for (int j = 0; j < 3; j++) {

      int sum = 0;

      for (int i = 0; i < 3; i++) {
        sum += board[i][j]!;
      }

      if (sum != 15) {
        return false;
      }
    }

    int diagonal1 =
        board[0][0]! +
        board[1][1]! +
        board[2][2]!;

    int diagonal2 =
        board[0][2]! +
        board[1][1]! +
        board[2][0]!;

    if (diagonal1 != 15 || diagonal2 != 15) {
      return false;
    }

    return true;
  }

  void checkResult() {

    bool result = isMagicSquare();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),

          title: Text(
            result
                ? 'Correcto 🎉'
                : 'Incorrecto ❌',
          ),

          content: Text(
            result
                ? 'El cuadrado mágico está correcto.'
                : 'El cuadrado mágico no es correcto.',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void restartGame() {

    setState(() {

      generateBoard();

      selectedRow = null;
      selectedCol = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Square Magic 3x3'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // TABLERO
            Column(
              children: [

                for (int row = 0; row < 3; row++)

                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      for (int col = 0; col < 3; col++)

                        buildCell(row, col),

                    ],
                  ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Selecciona un número',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // BOTONES NUMÉRICOS
            Wrap(

              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,

              children: [

                for (int i = 0; i <= 9; i++)

                  ElevatedButton(

                    onPressed: () {
                      insertNumber(i);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2A2A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 60),
                    ),

                    child: Text(
                      i.toString(),
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // BOTÓN BORRAR
            ElevatedButton(

              onPressed: clearCell,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),

              child: const Text(
                'Borrar Casilla',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN VERIFICAR
            ElevatedButton(

              onPressed: checkResult,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),

              child: const Text(
                'Verificar',
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN NUEVO JUEGO
            ElevatedButton(

              onPressed: restartGame,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),

              child: const Text(
                'Nuevo Juego',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCell(int row, int col) {

    bool isSelected =
        selectedRow == row &&
        selectedCol == col;

    bool isFixed = fixedCells[row][col];

    return GestureDetector(

      onTap: () {
        selectCell(row, col);
      },

      child: Container(

        width: 90,
        height: 90,

        margin: const EdgeInsets.all(4),

        decoration: BoxDecoration(

          color: isSelected
              ? Colors.blueGrey.shade700
              : isFixed
                  ? const Color(0xFF2C2C2C)
                  : const Color(0xFF1A1A1A),

          border: Border.all(
            color: Colors.grey.shade700,
            width: 2,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        child: Center(

          child: Text(

            board[row][col]?.toString() ?? '',

            style: TextStyle(

              fontSize: 30,
              fontWeight: FontWeight.bold,

              color: isFixed
                  ? Colors.white
                  : Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
    );
  }
}