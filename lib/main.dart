import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한국 랜덤 여행지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light),
        useMaterial3: true,
        fontFamily: 'Noto Sans KR',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Noto Sans KR'),
          headlineMedium: TextStyle(fontFamily: 'Noto Sans KR'),
          headlineSmall: TextStyle(fontFamily: 'Noto Sans KR'),
          titleLarge: TextStyle(fontFamily: 'Noto Sans KR'),
          titleMedium: TextStyle(fontFamily: 'Noto Sans KR'),
          titleSmall: TextStyle(fontFamily: 'Noto Sans KR'),
          bodyLarge: TextStyle(fontFamily: 'Noto Sans KR'),
          bodyMedium: TextStyle(fontFamily: 'Noto Sans KR'),
          bodySmall: TextStyle(fontFamily: 'Noto Sans KR'),
        ),
      ),
      home: const TravelSlotMachine(),
    );
  }
}

class Division {
  final String name;
  final List<Division> children;

  Division({required this.name, this.children = const []});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      name: json['name'],
      children: (json['children'] as List<dynamic>?)?.map((child) => Division.fromJson(child)).toList() ?? [],
    );
  }
}

class TravelSlotMachine extends StatefulWidget {
  const TravelSlotMachine({super.key});

  @override
  State<TravelSlotMachine> createState() => _TravelSlotMachineState();
}

class _TravelSlotMachineState extends State<TravelSlotMachine> with TickerProviderStateMixin {
  List<Division> koreaDivisions = [];

  // 선택된 여행지 정보
  Division? selectedProvince;
  Division? selectedCity;
  Division? selectedDistrict;

  // 애니메이션 컨트롤러
  late AnimationController _slotController1;
  late AnimationController _slotController2;
  late AnimationController _slotController3;
  late AnimationController _backgroundController;

  // 애니메이션
  late Animation<double> _slotAnimation1;
  late Animation<double> _slotAnimation2;
  late Animation<double> _slotAnimation3;
  late Animation<double> _backgroundAnimation;

  // 스핀 상태
  bool isSpinning1 = false;
  bool isSpinning2 = false;
  bool isSpinning3 = false;

  // 스핀 완료 상태
  bool isStep1Completed = false;
  bool isStep2Completed = false;
  bool isStep3Completed = false;

  // 현재 단계
  int currentStep = 0;

  // 팝업 표시 상태
  bool showResultPopup = false;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadKoreaDivisions();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // 슬롯 애니메이션 컨트롤러들
    _slotController1 = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _slotController2 = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this);
    _slotController3 = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);
    _backgroundController = AnimationController(duration: const Duration(seconds: 1), vsync: this)
      ..repeat(reverse: true);

    // 애니메이션 설정
    _slotAnimation1 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slotController1, curve: Curves.easeOutCubic));
    _slotAnimation2 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slotController2, curve: Curves.easeOutCubic));
    _slotAnimation3 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slotController3, curve: Curves.easeOutCubic));
    _backgroundAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut));
  }

  Future<void> _loadKoreaDivisions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/korea_divisions.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        koreaDivisions = jsonData.map((data) => Division.fromJson(data)).toList();
      });
    } catch (e) {
      // Error loading Korea divisions data
      debugPrint('Error loading Korea divisions: $e');
    }
  }

  Future<void> _spinSlot(int slotNumber) async {
    if (slotNumber == 1 && !isSpinning1 && !isStep1Completed) {
      setState(() {
        isSpinning1 = true;
        selectedProvince = null;
        selectedCity = null;
        selectedDistrict = null;
        isStep2Completed = false;
        isStep3Completed = false;
        currentStep = 1;
      });

      await _slotController1.forward(from: 0);

      // 랜덤 시도 선택
      final randomProvince = koreaDivisions[_random.nextInt(koreaDivisions.length)];

      setState(() {
        selectedProvince = randomProvince;
        isSpinning1 = false;
        isStep1Completed = true;
      });
    } else if (slotNumber == 2 && !isSpinning2 && !isStep2Completed && selectedProvince != null) {
      setState(() {
        isSpinning2 = true;
        selectedCity = null;
        selectedDistrict = null;
        isStep3Completed = false;
        currentStep = 2;
      });

      await _slotController2.forward(from: 0);

      // 랜덤 시군구 선택
      if (selectedProvince!.children.isNotEmpty) {
        final randomCity = selectedProvince!.children[_random.nextInt(selectedProvince!.children.length)];
        setState(() {
          selectedCity = randomCity;
          isSpinning2 = false;
          isStep2Completed = true;
        });
      }
    } else if (slotNumber == 3 && !isSpinning3 && !isStep3Completed && selectedCity != null) {
      setState(() {
        isSpinning3 = true;
        currentStep = 3;
      });

      await _slotController3.forward(from: 0);

      // 랜덤 읍면동 선택
      if (selectedCity!.children.isNotEmpty) {
        final randomDistrict = selectedCity!.children[_random.nextInt(selectedCity!.children.length)];
        setState(() {
          selectedDistrict = randomDistrict;
          isSpinning3 = false;
          isStep3Completed = true;
          showResultPopup = true; // 모든 단계 완료 시 팝업 표시
        });
      }
    }
  }

  // 롤링 후보 목록 생성
  List<String> _getSlotCandidates(int slotNumber) {
    switch (slotNumber) {
      case 1:
        return koreaDivisions.map((e) => e.name).toList();
      case 2:
        return selectedProvince?.children.map((e) => e.name).toList() ?? [];
      case 3:
        return selectedCity?.children.map((e) => e.name).toList() ?? [];
      default:
        return [];
    }
  }

  // 롤링 슬롯 애니메이션 위젯
  Widget _buildRollingSlot(int slotNumber, Animation<double> animation) {
    final candidates = _getSlotCandidates(slotNumber);
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
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.teal.shade600),
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

  void _resetAll() {
    setState(() {
      selectedProvince = null;
      selectedCity = null;
      selectedDistrict = null;
      currentStep = 0;
      isStep1Completed = false;
      isStep2Completed = false;
      isStep3Completed = false;
      showResultPopup = false;
    });
    _slotController1.reset();
    _slotController2.reset();
    _slotController3.reset();
  }

  void _closeResultPopup() {
    setState(() {
      showResultPopup = false;
    });
  }

  @override
  void dispose() {
    _slotController1.dispose();
    _slotController2.dispose();
    _slotController3.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 메인 콘텐츠
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.teal.shade300.withValues(alpha: _backgroundAnimation.value),
                      Colors.blue.shade400.withValues(alpha: _backgroundAnimation.value),
                      Colors.purple.shade300.withValues(alpha: _backgroundAnimation.value),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // 타이틀
                          const SizedBox(height: 20),
                          Text(
                            '🎰 한국 랜덤 여행지 🎰',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(offset: const Offset(2, 2), blurRadius: 4, color: Colors.black.withValues(alpha: 0.5)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '순서대로 스핀하여 여행지를 정해보세요!',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 40),

                          // 슬롯머신 영역
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // 첫 번째 슬롯 - 시도
                                _buildSlotSection(
                                  title: '1단계: 시/도',
                                  value: selectedProvince?.name,
                                  isSpinning: isSpinning1,
                                  animation: _slotAnimation1,
                                  onSpin: () => _spinSlot(1),
                                  canSpin: !isSpinning1 && !isStep1Completed,
                                  stepNumber: 1,
                                  isCompleted: isStep1Completed,
                                ),

                                const SizedBox(height: 20),

                                // 두 번째 슬롯 - 시군구
                                _buildSlotSection(
                                  title: '2단계: 시/군/구',
                                  value: selectedCity?.name,
                                  isSpinning: isSpinning2,
                                  animation: _slotAnimation2,
                                  onSpin: () => _spinSlot(2),
                                  canSpin: !isSpinning2 && selectedProvince != null && !isStep2Completed,
                                  stepNumber: 2,
                                  isCompleted: isStep2Completed,
                                ),

                                const SizedBox(height: 20),

                                // 세 번째 슬롯 - 읍면동
                                _buildSlotSection(
                                  title: '3단계: 읍/면/동',
                                  value: selectedDistrict?.name,
                                  isSpinning: isSpinning3,
                                  animation: _slotAnimation3,
                                  onSpin: () => _spinSlot(3),
                                  canSpin: !isSpinning3 && selectedCity != null && !isStep3Completed,
                                  stepNumber: 3,
                                  isCompleted: isStep3Completed,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 결과 표시 (기존)
                          if (selectedDistrict != null) ...[
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.amber, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '🎉 당신의 여행지 🎉',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    '${selectedProvince!.name} ${selectedCity!.name} ${selectedDistrict!.name}',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // 리셋 버튼
                          ElevatedButton.icon(
                            onPressed: _resetAll,
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              '다시 선택하기',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // 결과 팝업
          if (showResultPopup && selectedDistrict != null) _buildResultPopup(),
        ],
      ),
    );
  }

  Widget _buildSlotSection({
    required String title,
    String? value,
    required bool isSpinning,
    required Animation<double> animation,
    required VoidCallback onSpin,
    required bool canSpin,
    required int stepNumber,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            isCompleted
                ? Colors.blue.shade50
                : canSpin
                ? Colors.green.shade50
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              isCompleted
                  ? Colors.blue.shade400
                  : currentStep == stepNumber
                  ? Colors.orange
                  : Colors.grey.shade300,
          width: (currentStep == stepNumber || isCompleted) ? 3 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      isCompleted
                          ? Colors.blue.shade700
                          : canSpin
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                ),
              ),
              if (isCompleted) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, color: Colors.blue.shade600, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 15),

          // 슬롯 표시 영역
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child:
                    isSpinning
                        ? _buildRollingSlot(stepNumber, animation)
                        : Text(
                          value ?? '?',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: value != null ? Colors.teal.shade700 : Colors.grey.shade400,
                          ),
                          textAlign: TextAlign.center,
                        ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // 스핀 버튼
          ElevatedButton.icon(
            onPressed: canSpin ? onSpin : null,
            icon: Icon(
              isSpinning
                  ? Icons.hourglass_empty
                  : isCompleted
                  ? Icons.check
                  : Icons.casino,
              color: Colors.white,
            ),
            label: Text(
              isSpinning
                  ? '스핀 중...'
                  : isCompleted
                  ? '완료!'
                  : 'SPIN!',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCompleted
                      ? Colors.blue.shade600
                      : canSpin
                      ? Colors.teal.shade600
                      : Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: canSpin ? 5 : 0,
            ),
          ),
        ],
      ),
    );
  }

  // 결과 팝업 위젯
  Widget _buildResultPopup() {
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
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 닫기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _closeResultPopup,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
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
                    return Transform.scale(scale: scale, child: const Text('🎊', style: TextStyle(fontSize: 50)));
                  },
                ),

                const SizedBox(height: 20),

                // 제목
                Text(
                  '축하합니다! 🎉',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),

                const SizedBox(height: 15),

                Text(
                  '당신의 랜덤 여행지가\n결정되었습니다!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // 여행지 결과
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.teal.shade50, Colors.blue.shade50]),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.teal.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.location_on, color: Colors.teal.shade600, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        selectedProvince!.name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedCity!.name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.teal.shade700),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedDistrict!.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.teal.shade600),
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
                          _closeResultPopup();
                          _resetAll();
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text('다시 뽑기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        onPressed: _closeResultPopup,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('확인', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
