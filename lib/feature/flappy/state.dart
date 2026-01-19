class FlappyState {
  final bool running;
  final bool gameOver;
  final double birdY;
  final double birdV;
  final double gapY;
  final double pipeX;
  final int score;
  final bool scoredThisPipe;

  const FlappyState({
    this.running = false,
    this.gameOver = false,
    this.birdY = 0.5,
    this.birdV = 0.0,
    this.gapY = 0.5,
    this.pipeX = 1.2,
    this.score = 0,
    this.scoredThisPipe = false,
  });

  FlappyState copyWith({
    bool? running,
    bool? gameOver,
    double? birdY,
    double? birdV,
    double? gapY,
    double? pipeX,
    int? score,
    bool? scoredThisPipe,
  }) {
    return FlappyState(
      running: running ?? this.running,
      gameOver: gameOver ?? this.gameOver,
      birdY: birdY ?? this.birdY,
      birdV: birdV ?? this.birdV,
      gapY: gapY ?? this.gapY,
      pipeX: pipeX ?? this.pipeX,
      score: score ?? this.score,
      scoredThisPipe: scoredThisPipe ?? this.scoredThisPipe,
    );
  }
}
