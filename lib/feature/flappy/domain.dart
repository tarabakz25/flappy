import 'dart:math';

import 'state.dart';

class FlappyLogic {
  // パラメータ
  static const double gravity = 0.0012;
  static const double jumpV = -0.024;
  static const double pipeSpeed = 0.0066;
  static const double gapSize = 0.50;
  static const double birdRadius = 0.04;
  static const double pipeWidth = 0.16;
  static const double birdX = 0.3;

  final Random _rng = Random();

  double _randomGapY() {
    return 0.25 + _rng.nextDouble() * 0.5;
  }

  /// ゲーム開始時の初期状態を返す
  FlappyState start() {
    return FlappyState(
      running: true,
      gameOver: false,
      birdY: 0.5,
      birdV: 0.0,
      pipeX: 1.2,
      gapY: _randomGapY(),
      score: 0,
      scoredThisPipe: false,
    );
  }

  /// タップ時の処理
  FlappyState tap(FlappyState state) {
    if (state.gameOver || !state.running) {
      return start();
    }
    return state.copyWith(birdV: jumpV);
  }

  /// 毎フレームの更新処理
  FlappyState tick(FlappyState state) {
    if (!state.running || state.gameOver) return state;

    var birdV = state.birdV + gravity;
    var birdY = state.birdY + birdV;
    var pipeX = state.pipeX - pipeSpeed;
    var gapY = state.gapY;
    var score = state.score;
    var scoredThisPipe = state.scoredThisPipe;

    // パイプが画面外に出たらリセット
    if (pipeX < -pipeWidth) {
      pipeX = 1.2;
      gapY = _randomGapY();
      scoredThisPipe = false;
    }

    // スコア加算
    if (!scoredThisPipe && pipeX + pipeWidth < birdX) {
      score++;
      scoredThisPipe = true;
    }

    // 衝突判定
    if (_hitWall(birdY) || _hitPipe(birdY, pipeX, gapY)) {
      return state.copyWith(
        gameOver: true,
        running: false,
        birdY: birdY,
        birdV: birdV,
      );
    }

    return state.copyWith(
      birdY: birdY,
      birdV: birdV,
      pipeX: pipeX,
      gapY: gapY,
      score: score,
      scoredThisPipe: scoredThisPipe,
    );
  }

  bool _hitWall(double birdY) {
    return (birdY - birdRadius) < 0.0 || (birdY + birdRadius) > 1.0;
  }

  bool _hitPipe(double birdY, double pipeX, double gapY) {
    final inX = birdX + birdRadius > pipeX &&
        birdX - birdRadius < pipeX + pipeWidth;
    if (!inX) return false;

    final gapTop = gapY - gapSize / 2;
    final gapBottom = gapY + gapSize / 2;
    final inGap =
        (birdY - birdRadius) >= gapTop && (birdY + birdRadius) <= gapBottom;
    return !inGap;
  }

  /// 速度に応じた回転角（ラジアン）
  double birdAngle(double birdV) {
    final v = birdV.clamp(-0.05, 0.08);
    return (v / 0.08) * (pi / 3); // 最大 ±60度
  }
}
