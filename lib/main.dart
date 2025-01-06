import 'package:flutter/material.dart';

import 'package:reversed_minesweeper/theme.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(ReversedMinesweeperApp());
}

class ReversedMinesweeperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        title: 'Reversed Minesweeper',
        theme: GameTheme.lightTheme,
        home: SetupScreen(),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';

// void main() {
//   runApp(ReversedMinesweeperApp());
// }

// class ReversedMinesweeperApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reversed Minesweeper',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SetupScreen(),
//     );
//   }
// }

// class SetupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Setup Game')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Select Board Size', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => navigateToGame(context, 8),
//               child: Text('8x8'),
//             ),
//             ElevatedButton(
//               onPressed: () => navigateToGame(context, 10),
//               child: Text('10x10'),
//             ),
//             ElevatedButton(
//               onPressed: () => navigateToGame(context, 12),
//               child: Text('12x12'),
//             ),
//             ElevatedButton(
//               onPressed: () => navigateToGame(context, 14),
//               child: Text('14x14'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void navigateToGame(BuildContext context, int boardSize) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GameScreen(boardSize: boardSize),
//       ),
//     );
//   }
// }

// class GameScreen extends StatefulWidget {
//   final int boardSize;

//   GameScreen({required this.boardSize});

//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   late List<List<Cell>> board;
//   int discoveredBombs = 0;
//   int timerInterval = 10; // seconds
//   Timer? gameTimer;
//   int elapsedSeconds = 0;
//   PieceData? draggingPiece;

//   @override
//   void initState() {
//     super.initState();
//     initializeBoard();
//     startTimer();
//   }

//   @override
//   void dispose() {
//     gameTimer?.cancel();
//     super.dispose();
//   }

//   void initializeBoard() {
//     final random = Random();
//     int totalCells = widget.boardSize * widget.boardSize;
//     int randomBombs = random.nextInt(totalCells ~/ 4) +
//         totalCells ~/ 10; // Random between 10% and 25% of total cells
//     int piecesToPlace = totalCells -
//         randomBombs -
//         1 -
//         (random.nextInt(totalCells - randomBombs - 1) +
//             randomBombs); // At least one empty cell

//     board = List.generate(
//       widget.boardSize,
//       (row) => List.generate(
//         widget.boardSize,
//         (col) => Cell(),
//       ),
//     );

//     // Place bombs
//     while (randomBombs > 0) {
//       int row = random.nextInt(widget.boardSize);
//       int col = random.nextInt(widget.boardSize);
//       if (!board[row][col].hasBomb) {
//         board[row][col].hasBomb = true;
//         randomBombs--;
//       }
//     }

//     // Place pieces on empty cells
//     while (piecesToPlace > 0) {
//       int row = random.nextInt(widget.boardSize);
//       int col = random.nextInt(widget.boardSize);
//       if (!board[row][col].hasBomb && !board[row][col].hasPiece) {
//         board[row][col].hasPiece = true;
//         piecesToPlace--;
//       }
//     }
//   }

//   void startTimer() {
//     gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         elapsedSeconds++;
//         if (elapsedSeconds % timerInterval == 0) {
//           explodeRandomBomb();
//         }
//         checkGameOver();
//       });
//     });
//   }

//   void explodeRandomBomb() {
//     final random = Random();
//     final bombCells = board
//         .expand((row) => row)
//         .where((cell) => cell.hasBomb && !cell.isRevealed && !cell.isExploded)
//         .toList();

//     if (bombCells.isNotEmpty) {
//       final cell = bombCells[random.nextInt(bombCells.length)];
//       cell.hasBomb = false;
//       cell.isExploded = true;
//     }
//   }

//   void checkGameOver() {
//     final allBombsHandled = board.expand((row) => row).every(
//           (cell) => !cell.hasBomb || cell.isRevealed || cell.isExploded,
//         );

//     if (allBombsHandled) {
//       gameTimer?.cancel();
//       showGameOverDialog();
//     }
//   }

//   void showGameOverDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Game Over'),
//           content: Text('Total Discovered Bombs: $discoveredBombs'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 resetGame();
//               },
//               child: Text('Restart'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void resetGame() {
//     setState(() {
//       discoveredBombs = 0;
//       elapsedSeconds = 0;
//       initializeBoard();
//       startTimer();
//     });
//   }

//   void handleCellDrop(PieceData piece, int startRow, int startCol,
//       int targetRow, int targetCol) {
//     setState(() {
//       if (board[targetRow][targetCol].hasBomb &&
//           !board[targetRow][targetCol].isRevealed) {
//         // Bomb discovered
//         board[targetRow][targetCol].isRevealed = true;
//         discoveredBombs++;
//       }

//       if (!board[targetRow][targetCol].hasPiece &&
//           (!board[targetRow][targetCol].hasBomb ||
//               board[targetRow][targetCol].isRevealed)) {
//         // Move piece to target
//         board[targetRow][targetCol].hasPiece = true;
//         board[startRow][startCol].hasPiece = false;
//       } else {
//         // Return to original position with animation
//         Future.delayed(Duration(milliseconds: 200), () {
//           setState(() {
//             draggingPiece = null;
//           });
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Reversed Minesweeper')),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: widget.boardSize,
//               ),
//               itemCount: widget.boardSize * widget.boardSize,
//               itemBuilder: (context, index) {
//                 int row = index ~/ widget.boardSize;
//                 int col = index % widget.boardSize;
//                 return DragTarget<PieceData>(
//                   onWillAcceptWithDetails: (data) => true,
//                   onAcceptWithDetails: (dragData) => handleCellDrop(
//                       dragData.data,
//                       draggingPiece!.row,
//                       draggingPiece!.col,
//                       row,
//                       col),
//                   builder: (context, candidateData, rejectedData) {
//                     return Container(
//                       margin: EdgeInsets.all(2),
//                       color: board[row][col].isExploded
//                           ? Colors.red
//                           : board[row][col].isRevealed
//                               ? Colors.green
//                               : Colors.grey,
//                       child: Center(
//                         child: board[row][col].hasPiece
//                             ? Draggable<PieceData>(
//                                 data: PieceData(row: row, col: col),
//                                 feedback: Icon(Icons.circle,
//                                     size: 30,
//                                     color: Colors.blue.withOpacity(0.7)),
//                                 childWhenDragging: Container(),
//                                 child: Icon(Icons.circle,
//                                     size: 30, color: Colors.blue),
//                                 onDragStarted: () => draggingPiece =
//                                     PieceData(row: row, col: col),
//                                 onDragEnd: (details) {
//                                   if (draggingPiece != null) {
//                                     setState(() {
//                                       draggingPiece = null;
//                                     });
//                                   }
//                                 },
//                               )
//                             : null,
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Discovered Bombs: $discoveredBombs',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     Text(
//                       'Time: $elapsedSeconds seconds',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PieceData {
//   final int row;
//   final int col;

//   PieceData({required this.row, required this.col});
// }

// class Cell {
//   bool hasBomb;
//   bool hasPiece;
//   bool isRevealed;
//   bool isExploded;

//   Cell({
//     this.hasBomb = false,
//     this.hasPiece = false,
//     this.isRevealed = false,
//     this.isExploded = false,
//   });
// }
