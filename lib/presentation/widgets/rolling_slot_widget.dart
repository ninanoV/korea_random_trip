import 'package:flutter/material.dart';

class RollingSlotWidget extends StatelessWidget {
  final List<String> candidates;
  final Animation<double> animation;

  const RollingSlotWidget({
    super.key,
    required this.candidates,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) {
      return const Text('🎰', style: TextStyle(fontSize: 30));
    }

    // 후보들을 여러 번 반복해서 충분한 롤링 효과 생성
    final extendedCandidates = <String>[];
    for (int i = 0; i < 10; i++) {
      extendedCandidates.addAll(candidates);
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // 롤링 속도 조절 (처음엔 빠르게, 끝에선 천천히)
        final rollOffset = animation.value * extendedCandidates.length * 0.8;

        return SizedBox(
          height: 80,
          child: Stack(
            children: [
              // 롤링되는 텍스트들
              for (int i = 0; i < extendedCandidates.length; i++)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 50),
                  top: (i * 40.0) - (rollOffset * 40.0) + 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      extendedCandidates[i],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              // 상하 그라데이션 효과로 롤링 영역 경계 표시
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white.withValues(alpha: 0.3)],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 20,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withValues(alpha: 0.3), Colors.white],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
