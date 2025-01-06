import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reversed_minesweeper/helpers/utilites.dart';
import 'game_event.dart';
import 'game_state.dart';
import 'dart:async';
import 'dart:math';
import 'package:reversed_minesweeper/models/cell_data_model.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.boardSize,
    required this.timerInterval,
  }) : super(GameInitializeState(board: [])) {
    on<GameStartEvent>(startGame);
    on<PieceDroppedEvent>(handlePieceDropped);
    on<BombExplodedEvent>(bombExploded);
    on<ExplosionAnimationEndedEvent>(explosionEndedEvent);
    on<CheckGameOverEvent>(checkGameOver);
  }
  final int boardSize;
  final int timerInterval;
  late List<List<Cell>> board;
  int discoveredBombs = 0;
  Timer? gameTimer;

  @override
  Future<void> close() {
    gameTimer?.cancel();
    return super.close();
  }

  Future<void> startGame(GameStartEvent event, Emitter<GameState> emit) async {
    emit(GameLoadingState(board: []));
    discoveredBombs = 0;
    board = [];
    if (gameTimer != null && gameTimer!.isActive) {
      gameTimer?.cancel();
    }
    final random = Random();
    int totalCells = boardSize * boardSize;
    int randomBombs = random.nextInt(totalCells ~/ 4) +
        totalCells ~/ 10; // Random between 10% and 25% of total cells
    int piecesToPlace = totalCells - randomBombs - 1;
    lg.d('NEW GAME : \nTotal Cells : $totalCells \nBombs : $randomBombs');

    board = List.generate(
      boardSize,
      (row) => List.generate(
        boardSize,
        (col) => Cell(),
      ),
    );

    // Place bombs
    while (randomBombs > 0) {
      int row = random.nextInt(boardSize);
      int col = random.nextInt(boardSize);
      if (!board[row][col].hasBomb) {
        board[row][col].hasBomb = true;
        randomBombs--;
      }
    }

    // Place pieces on empty cells
    while (piecesToPlace > 0) {
      int row = random.nextInt(boardSize);
      int col = random.nextInt(boardSize);
      if (!board[row][col].hasBomb && !board[row][col].hasPiece) {
        board[row][col].hasPiece = true;
        piecesToPlace--;
      }
    }
    startTimer(emit);
    emit(GameUpdatedState(board: board, discoveredBombs: discoveredBombs));
  }

  void startTimer(Emitter<GameState> emit) {
    gameTimer?.cancel();
    int elapsedSeconds = timerInterval;
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      elapsedSeconds--;
      if (elapsedSeconds <= 0) {
        add(BombExplodedEvent());
        elapsedSeconds = timerInterval;
      }
    });
  }

  Future<void> bombExploded(
      BombExplodedEvent event, Emitter<GameState> emit) async {
    final random = Random();
    final bombCells = board
        .expand((row) => row)
        .where((cell) => cell.hasBomb && !cell.isRevealed && !cell.isExploded)
        .toList();

    if (bombCells.isNotEmpty) {
      final cell = bombCells[random.nextInt(bombCells.length)];
      cell.hasBomb = false;
      cell.hasExplodedAnimationPlayed = true;
    }

    emit(GameUpdatedState(board: board, discoveredBombs: discoveredBombs));
  }

  Future<void> explosionEndedEvent(
      ExplosionAnimationEndedEvent event, Emitter<GameState> emit) async {
    final cell = board[event.row][event.col];
    cell.hasBomb = false;
    cell.isExploded = true;
    lg.d('Bomb exploded at : (${event.row},${event.col})');
    emit(GameUpdatedState(board: board, discoveredBombs: discoveredBombs));
    add(CheckGameOverEvent());
  }

  Future<void> checkGameOver(
      CheckGameOverEvent event, Emitter<GameState> emit) async {
    final allBombsHandled = board.expand((row) => row).every(
          (cell) => !cell.hasBomb || cell.isRevealed || cell.isExploded,
        );

    if (allBombsHandled) {
      lg.d(
          'GAME OVER : \nBombs discovered : $discoveredBombs \nBombs Exploded : ${board.expand((row) => row).where((cell) => cell.isExploded).length}');
      gameTimer?.cancel(); // Cancel the timer
      emit(GameOverState(totalDiscoveredBombs: discoveredBombs, board: board));
    }
  }

  Future<void> handlePieceDropped(
      PieceDroppedEvent event, Emitter<GameState> emit) async {
    if (board[event.targetRow][event.targetCol].hasBomb &&
        !board[event.targetRow][event.targetCol].isRevealed) {
      // Bomb discovered
      board[event.targetRow][event.targetCol].isRevealed = true;
      discoveredBombs++;
      lg.d(
          'Bomb discovered at : ${event.targetRow},${event.targetCol} \nBombs discovered : $discoveredBombs');
      add(CheckGameOverEvent());
    }

    if (!board[event.targetRow][event.targetCol].hasPiece &&
        (!board[event.targetRow][event.targetCol].hasBomb ||
            board[event.targetRow][event.targetCol].isRevealed)) {
      // Move piece to new position
      board[event.targetRow][event.targetCol].hasPiece = true;
      board[event.startRow][event.startCol].hasPiece = false;
    }
    emit(GameUpdatedState(board: board, discoveredBombs: discoveredBombs));
  }
}
