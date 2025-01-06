class Cell {
  bool hasBomb;
  bool hasPiece;
  bool isRevealed;
  bool hasExplodedAnimationPlayed;
  bool isExploded;

  Cell({
    this.hasBomb = false,
    this.hasPiece = false,
    this.isRevealed = false,
    this.hasExplodedAnimationPlayed = false,
    this.isExploded = false,
  });
}
