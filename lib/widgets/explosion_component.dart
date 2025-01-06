import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

class ExplosionGame extends FlameGame {
  final Vector2 position;
  final VoidCallback onAnimationComplete;
  ExplosionGame({
    required this.position,
    required this.onAnimationComplete,
  });

  @override
  Future<void> onLoad() async {
    add(ExplosionComponent(
        position: position, onAnimationComplete: onAnimationComplete));
  }
}

class ExplosionComponent extends SpriteAnimationComponent with HasGameRef {
  final VoidCallback onAnimationComplete;
  ExplosionComponent({
    super.position,
    required this.onAnimationComplete,
  }) : super(
          size: Vector2.all(50),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    FlameAudio.audioCache.load('explosion_sound.mp3');
    FlameAudio.play('explosion_sound.mp3', volume: 0.6);
    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.1,
        amount: 6,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker?.done() ?? false) {
      onAnimationComplete();
    }
  }
}
