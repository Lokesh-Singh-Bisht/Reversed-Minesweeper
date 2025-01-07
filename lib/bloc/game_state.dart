import 'package:reversed_minesweeper/models/cell_data_model.dart';

abstract class GameState {
  final List<List<Cell>> board;

  GameState({required this.board});
}

final class GameInitializeState extends GameState {
  GameInitializeState({required super.board});
}

final class GameLoadingState extends GameState {
  GameLoadingState({required super.board});
}

final class GameUpdatedState extends GameState {
  @override
  final List<List<Cell>> board;

  GameUpdatedState({
    required this.board,
  }) : super(board: board);
}

final class BombExplodedState extends GameState {
  @override
  final List<List<Cell>> board;

  BombExplodedState({
    required this.board,
  }) : super(board: board);
}

final class GameOverState extends GameState {
  final int totalDiscoveredBombs;
  GameOverState({required this.totalDiscoveredBombs, required super.board});
}

final class GameErrorState extends GameState {
  final String errorMessage;
  GameErrorState({required this.errorMessage, required super.board});
}
