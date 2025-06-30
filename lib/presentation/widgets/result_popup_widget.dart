import 'package:flutter/material.dart';
import '../../domain/entities/division.dart';

class ResultPopupWidget extends StatelessWidget {
  final Division selectedProvince;
  final Division selectedCity;
  final Division selectedDistrict;
  final VoidCallback onClose;
  final VoidCallback onReset;

  const ResultPopupWidget({
    super.key,
    required this.selectedProvince,
    required this.selectedCity,
    required this.selectedDistrict,
    required this.onClose,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 닫기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.grey.shade600, size: 20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 축하 이모지와 애니메이션
                TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: Tween<double>(begin: 0.5, end: 1.2),
                  builder: (context, double scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: const Text('🎊', style: TextStyle(fontSize: 50)),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 제목
                Text(
                  '축하합니다! 🎉',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                ),

                const SizedBox(height: 15),

                Text(
                  '당신의 랜덤 여행지가\n결정되었습니다!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // 여행지 결과
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade50, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.teal.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.location_on, color: Colors.teal.shade600, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        selectedProvince.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedCity.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.teal.shade700,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedDistrict.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.teal.shade600,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 액션 버튼들
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onClose();
                          onReset();
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text(
                          '다시 뽑기',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onClose,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          '확인',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
