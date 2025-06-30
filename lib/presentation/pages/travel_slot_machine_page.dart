import 'package:flutter/material.dart';

import '../notifiers/slot_machine_notifier.dart';
import '../widgets/result_popup_widget.dart';
import '../widgets/slot_section_widget.dart';

class TravelSlotMachinePage extends StatefulWidget {
  final SlotMachineNotifier notifier;

  const TravelSlotMachinePage({
    super.key,
    required this.notifier,
  });

  @override
  State<TravelSlotMachinePage> createState() => _TravelSlotMachinePageState();
}

class _TravelSlotMachinePageState extends State<TravelSlotMachinePage> with TickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    widget.notifier.addListener(_onStateChanged);
    // 지연 로딩: 데이터를 바로 로딩하지 않고 UI가 준비된 후 로딩
  }

  void _initializeAnimations() {
    // 슬롯 애니메이션 컨트롤러들
    _slotController1 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slotController2 = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _slotController3 = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2), // 더 느리게 해서 CPU 사용량 절약
      vsync: this,
    );
    // 초기 상태에서는 배경 애니메이션을 시작하지 않음 (성능 최적화)

    // 애니메이션 설정
    _slotAnimation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slotController1, curve: Curves.easeOutCubic),
    );
    _slotAnimation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slotController2, curve: Curves.easeOutCubic),
    );
    _slotAnimation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slotController3, curve: Curves.easeOutCubic),
    );
    _backgroundAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );
  }

  void _onStateChanged() {
    final state = widget.notifier.state;

    // 데이터 로딩이 완료되면 배경 애니메이션 시작
    if (state.koreaDivisions.isNotEmpty && !_backgroundController.isAnimating) {
      _backgroundController.repeat(reverse: true);
    }

    // 애니메이션 트리거
    if (state.isSpinning1) {
      _slotController1.forward(from: 0);
    }
    if (state.isSpinning2) {
      _slotController2.forward(from: 0);
    }
    if (state.isSpinning3) {
      _slotController3.forward(from: 0);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_onStateChanged);
    _slotController1.dispose();
    _slotController2.dispose();
    _slotController3.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: widget.notifier,
        builder: (context, child) {
          final state = widget.notifier.state;

          if (state.isLoading) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal.shade400, Colors.teal.shade600],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '🎰 한국 랜덤 여행지 🎰',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '여행지 데이터를 로딩 중...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.error != null) {
            return Container(
              color: Colors.red.shade50,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade600),
                    const SizedBox(height: 20),
                    Text(
                      '오류 발생',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.error!,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: widget.notifier.loadKoreaDivisions,
                      icon: const Icon(Icons.refresh),
                      label: const Text('다시 시도'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 데이터가 로딩되지 않은 초기 상태 - 빠른 UI 표시
          if (state.koreaDivisions.isEmpty && !state.isLoading) {
            return _buildInitialScreen();
          }

          return Stack(
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
                              _buildHeader(context),
                              const SizedBox(height: 40),
                              _buildSlotMachine(context, state),
                              const SizedBox(height: 30),
                              if (state.selectedDistrict != null) _buildResult(context, state),
                              _buildResetButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 결과 팝업
              if (state.showResultPopup && state.selectedDistrict != null)
                ResultPopupWidget(
                  selectedProvince: state.selectedProvince!,
                  selectedCity: state.selectedCity!,
                  selectedDistrict: state.selectedDistrict!,
                  onClose: widget.notifier.closeResultPopup,
                  onReset: widget.notifier.resetAll,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          '🎰 한국 랜덤 여행지 🎰',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 4,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '순서대로 스핀하여 여행지를 정해보세요!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  Widget _buildSlotMachine(BuildContext context, SlotMachineState state) {
    return Container(
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
          SlotSectionWidget(
            title: '1단계: 시/도',
            value: state.selectedProvince?.name,
            isSpinning: state.isSpinning1,
            animation: _slotAnimation1,
            onSpin: () => widget.notifier.spinSlot(1),
            canSpin: !state.isSpinning1 && !state.isStep1Completed,
            stepNumber: 1,
            isCompleted: state.isStep1Completed,
            currentStep: state.currentStep,
            candidates: widget.notifier.getSlotCandidates(1),
          ),

          const SizedBox(height: 20),

          // 두 번째 슬롯 - 시군구
          SlotSectionWidget(
            title: '2단계: 시/군/구',
            value: state.selectedCity?.name,
            isSpinning: state.isSpinning2,
            animation: _slotAnimation2,
            onSpin: () => widget.notifier.spinSlot(2),
            canSpin: !state.isSpinning2 && state.selectedProvince != null && !state.isStep2Completed,
            stepNumber: 2,
            isCompleted: state.isStep2Completed,
            currentStep: state.currentStep,
            candidates: widget.notifier.getSlotCandidates(2),
          ),

          const SizedBox(height: 20),

          // 세 번째 슬롯 - 읍면동
          SlotSectionWidget(
            title: '3단계: 읍/면/동',
            value: state.selectedDistrict?.name,
            isSpinning: state.isSpinning3,
            animation: _slotAnimation3,
            onSpin: () => widget.notifier.spinSlot(3),
            canSpin: !state.isSpinning3 && state.selectedCity != null && !state.isStep3Completed,
            stepNumber: 3,
            isCompleted: state.isStep3Completed,
            currentStep: state.currentStep,
            candidates: widget.notifier.getSlotCandidates(3),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, SlotMachineState state) {
    return Column(
      children: [
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
                '${state.selectedProvince!.name} ${state.selectedCity!.name} ${state.selectedDistrict!.name}',
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
    );
  }

  Widget _buildResetButton() {
    return AnimatedBuilder(
      animation: widget.notifier,
      builder: (context, child) {
        final canReset = widget.notifier.canReset;
        final isAnySpinning = widget.notifier.state.isAnySpinning;

        return ElevatedButton.icon(
          onPressed: canReset ? widget.notifier.resetAll : null,
          icon: Icon(
            isAnySpinning ? Icons.stop : Icons.refresh,
            color: Colors.white,
          ),
          label: Text(
            isAnySpinning ? '스핀 중지' : '다시 선택하기',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isAnySpinning ? Colors.orange.shade600 : Colors.red.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: canReset ? 5 : 0,
          ),
        );
      },
    );
  }

  // 빠른 초기 화면 - 데이터 로딩 전
  Widget _buildInitialScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade300,
            Colors.blue.shade400,
            Colors.purple.shade300,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎰',
                style: TextStyle(fontSize: 120),
              ),
              const SizedBox(height: 30),
              const Text(
                '한국 랜덤 여행지',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '슬롯머신으로 여행지를 정해보세요!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () {
                  // 사용자가 시작 버튼을 눌렀을 때만 데이터 로딩
                  widget.notifier.loadKoreaDivisions();
                },
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text(
                  '여행지 탐험 시작!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
