import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reversed_minesweeper/bloc/game_bloc.dart';
import 'package:reversed_minesweeper/bloc/game_event.dart';
import 'package:reversed_minesweeper/bloc/game_state.dart';
import 'package:reversed_minesweeper/helpers/constants.dart';
import 'package:reversed_minesweeper/models/piece_data_model.dart';
import 'package:reversed_minesweeper/theme.dart';
import 'package:reversed_minesweeper/widgets/disclaimer_widget.dart';
import 'package:reversed_minesweeper/widgets/explosion_component.dart';
import 'package:reversed_minesweeper/widgets/game_over_animation.dart';
import 'package:reversed_minesweeper/widgets/piece_widget.dart';

import 'package:reversed_minesweeper/widgets/static_title_textWidget.dart';

class GameScreen extends StatefulWidget {
  final int boardSize;
  GameScreen({required this.boardSize});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  PieceData? draggingPiece;
  double _iconWidth = 25;

  @override
  void initState() {
    super.initState();
    _iconWidth = (Constants.screenWidth / widget.boardSize) - 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameLoadingState || state is GameInitializeState) {
            return const Center(
                child: CircularProgressIndicator(
              color: GameTheme.primaryColor,
            ));
          } else {
            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: Constants.statusBarHeight, bottom: 10),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Exit",
                                    style: GoogleFonts.russoOne(
                                        fontSize: 20,
                                        color: GameTheme.alertColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5),
                                  )),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<GameBloc>()
                                        .add(GameStartEvent());
                                  },
                                  child: Text(
                                    "Restart",
                                    style: GoogleFonts.russoOne(
                                      fontSize: 22,
                                      color: GameTheme.secondryColor,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          )),
                      StaticTitleTextWidget(
                        textColor: GameTheme.primaryColor,
                      ),
                      const Spacer(),
                      Container(
                          width: Constants.screenWidth,
                          height: Constants.screenWidth + 20,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: GameTheme.backboardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: GameTheme.backboardColor,
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          alignment: Alignment.bottomCenter,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: widget.boardSize,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.boardSize * widget.boardSize,
                            itemBuilder: (context, index) {
                              int row = index ~/ widget.boardSize;
                              int col = index % widget.boardSize;
                              final boardBoxItem = state.board[row][col];

                              return DragTarget<PieceData>(
                                onWillAcceptWithDetails: (data) => true,
                                onAcceptWithDetails: (dragData) => {
                                  context
                                      .read<GameBloc>()
                                      .add(PieceDroppedEvent(
                                        piece: dragData.data,
                                        startRow: draggingPiece!.row,
                                        startCol: draggingPiece!.col,
                                        targetRow: row,
                                        targetCol: col,
                                      ))
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: boardBoxItem.isExploded
                                          ? Colors.black
                                          : boardBoxItem.isRevealed
                                              ? Colors.orange
                                              : GameTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: GameTheme.backboardColor,
                                          width: 2),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.antiAlias,
                                      children: [
                                        Center(
                                          child: boardBoxItem.hasPiece
                                              ? boardBoxItem.isRevealed
                                                  ? PieceWidget(
                                                      size: Size(_iconWidth,
                                                          _iconWidth),
                                                    )
                                                  : Draggable<PieceData>(
                                                      data: PieceData(
                                                          row: row, col: col),
                                                      onDragStarted: () =>
                                                          draggingPiece =
                                                              PieceData(
                                                                  row: row,
                                                                  col: col),
                                                      onDragEnd: (details) {
                                                        if (draggingPiece !=
                                                            null) {
                                                          setState(() {
                                                            draggingPiece =
                                                                null;
                                                          });
                                                        }
                                                      },
                                                      feedback: PieceWidget(
                                                        size: Size(_iconWidth,
                                                            _iconWidth),
                                                      ),
                                                      childWhenDragging:
                                                          Container(),
                                                      child: PieceWidget(
                                                        size: Size(_iconWidth,
                                                            _iconWidth),
                                                      ),
                                                    )
                                              : null,
                                        ),
                                        if (boardBoxItem
                                                .hasExplodedAnimationPlayed &&
                                            !boardBoxItem.isExploded)
                                          Positioned.fill(
                                            child: GameWidget(
                                              game: ExplosionGame(
                                                  onAnimationComplete: () {
                                                    context.read<GameBloc>().add(
                                                        ExplosionAnimationEndedEvent(
                                                            row: row,
                                                            col: col));
                                                  },
                                                  position: Vector2(
                                                      (_iconWidth + 15) / 2,
                                                      (_iconWidth + 15) / 2)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )),
                      const Spacer(),
                      DisclaimerDialogWidget(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                if (state is GameOverState)
                  GameOverAnimation(
                    totalDiscoveredBombs: state.totalDiscoveredBombs,
                    onExit: () {
                      Navigator.pop(context);
                    },
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
