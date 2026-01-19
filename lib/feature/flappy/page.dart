import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'domain.dart';
import 'state.dart';

class FlappyPage extends StatefulWidget {
  const FlappyPage({super.key});

  @override
  State<FlappyPage> createState() => _FlappyPageState();
}

class _FlappyPageState extends State<FlappyPage> {
  final _logic = FlappyLogic();
  FlappyState _state = const FlappyState();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tap() {
    final wasRunning = _state.running;
    setState(() {
      _state = _logic.tap(_state);
    });

    // ゲーム開始時にタイマーを起動
    if (!wasRunning && _state.running) {
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) {
          final newState = _logic.tick(_state);
          setState(() => _state = newState);

          // ゲームオーバー時にタイマー停止
          if (newState.gameOver) {
            _timer?.cancel();
            _timer = null;
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _tap,
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            double toPxX(double x) => x * w;
            double toPxY(double y) => y * h;

            final gapTop = _state.gapY - FlappyLogic.gapSize / 2;
            final gapBottom = _state.gapY + FlappyLogic.gapSize / 2;

            final base = min(w, h);
            final birdSize = base * (FlappyLogic.birdRadius * 2);
            final boxSize = birdSize * 2.0;

            return Stack(
              children: [
                // 背景の空
                Container(color: const Color(0xFF8ED6FF)),

                // 上側パイプ
                Positioned(
                  left: toPxX(_state.pipeX),
                  top: 0,
                  width: toPxX(FlappyLogic.pipeWidth),
                  height: toPxY(gapTop),
                  child: Container(color: const Color(0xFF2ECC71)),
                ),

                // 下側パイプ
                Positioned(
                  left: toPxX(_state.pipeX),
                  top: toPxY(gapBottom),
                  width: toPxX(FlappyLogic.pipeWidth),
                  height: toPxY(1 - gapBottom),
                  child: Container(color: const Color(0xFF2ECC71)),
                ),

                // 鳥（絵文字）
                Positioned(
                  left: toPxX(FlappyLogic.birdX) - boxSize / 2,
                  top: toPxY(_state.birdY) - boxSize / 2,
                  width: boxSize,
                  height: boxSize,
                  child: Center(
                    child: Transform.rotate(
                      angle: _logic.birdAngle(_state.birdV),
                      child: Transform.scale(
                        scaleX: -1,
                        child: const Text(
                          '🐤',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                ),

                // スコア
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${_state.score}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black45),
                        ],
                      ),
                    ),
                  ),
                ),

                // メッセージ
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _state.running
                        ? const SizedBox.shrink()
                        : Text(
                            _state.gameOver
                                ? 'GAME OVER !\nTap to Restart'
                                : 'Tap to Start',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
