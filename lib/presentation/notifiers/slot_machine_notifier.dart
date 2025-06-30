import 'package:flutter/material.dart';
import '../../domain/entities/division.dart';
import '../../domain/usecases/get_korea_divisions.dart';
import '../../domain/usecases/select_random_division.dart';

enum SlotMachineStep { initial, step1, step2, step3, completed }

class SlotMachineState {
  final List<Division> koreaDivisions;
  final Division? selectedProvince;
  final Division? selectedCity;
  final Division? selectedDistrict;
  final SlotMachineStep currentStep;
  final bool isSpinning1;
  final bool isSpinning2;
  final bool isSpinning3;
  final bool isStep1Completed;
  final bool isStep2Completed;
  final bool isStep3Completed;
  final bool showResultPopup;
  final bool isLoading;
  final String? error;

  const SlotMachineState({
    this.koreaDivisions = const [],
    this.selectedProvince,
    this.selectedCity,
    this.selectedDistrict,
    this.currentStep = SlotMachineStep.initial,
    this.isSpinning1 = false,
    this.isSpinning2 = false,
    this.isSpinning3 = false,
    this.isStep1Completed = false,
    this.isStep2Completed = false,
    this.isStep3Completed = false,
    this.showResultPopup = false,
    this.isLoading = false,
    this.error,
  });

  SlotMachineState copyWith({
    List<Division>? koreaDivisions,
    Division? selectedProvince,
    Division? selectedCity,
    Division? selectedDistrict,
    SlotMachineStep? currentStep,
    bool? isSpinning1,
    bool? isSpinning2,
    bool? isSpinning3,
    bool? isStep1Completed,
    bool? isStep2Completed,
    bool? isStep3Completed,
    bool? showResultPopup,
    bool? isLoading,
    String? error,
    bool clearSelectedProvince = false,
    bool clearSelectedCity = false,
    bool clearSelectedDistrict = false,
    bool clearError = false,
  }) {
    return SlotMachineState(
      koreaDivisions: koreaDivisions ?? this.koreaDivisions,
      selectedProvince: clearSelectedProvince ? null : (selectedProvince ?? this.selectedProvince),
      selectedCity: clearSelectedCity ? null : (selectedCity ?? this.selectedCity),
      selectedDistrict: clearSelectedDistrict ? null : (selectedDistrict ?? this.selectedDistrict),
      currentStep: currentStep ?? this.currentStep,
      isSpinning1: isSpinning1 ?? this.isSpinning1,
      isSpinning2: isSpinning2 ?? this.isSpinning2,
      isSpinning3: isSpinning3 ?? this.isSpinning3,
      isStep1Completed: isStep1Completed ?? this.isStep1Completed,
      isStep2Completed: isStep2Completed ?? this.isStep2Completed,
      isStep3Completed: isStep3Completed ?? this.isStep3Completed,
      showResultPopup: showResultPopup ?? this.showResultPopup,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // 전체 스핀 상태 확인
  bool get isAnySpinning => isSpinning1 || isSpinning2 || isSpinning3;
}

class SlotMachineNotifier extends ChangeNotifier {
  final GetKoreaDivisions _getKoreaDivisions;
  final SelectRandomDivision _selectRandomDivision;

  SlotMachineNotifier(this._getKoreaDivisions, this._selectRandomDivision);

  SlotMachineState _state = const SlotMachineState();
  SlotMachineState get state => _state;

  // 스핀 취소를 위한 플래그
  bool _shouldCancelSpin = false;

  void _updateState(SlotMachineState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadKoreaDivisions() async {
    _updateState(_state.copyWith(isLoading: true, clearError: true));

    try {
      final divisions = await _getKoreaDivisions();
      _updateState(_state.copyWith(
        koreaDivisions: divisions,
        isLoading: false,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> spinSlot(int slotNumber) async {
    switch (slotNumber) {
      case 1:
        await _spinSlot1();
        break;
      case 2:
        await _spinSlot2();
        break;
      case 3:
        await _spinSlot3();
        break;
    }
  }

  Future<void> _spinSlot1() async {
    if (_state.isSpinning1 || _state.isStep1Completed) return;

    _shouldCancelSpin = false;
    _updateState(_state.copyWith(
      isSpinning1: true,
      clearSelectedProvince: true,
      clearSelectedCity: true,
      clearSelectedDistrict: true,
      isStep2Completed: false,
      isStep3Completed: false,
      currentStep: SlotMachineStep.step1,
    ));

    // 애니메이션 시간 시뮬레이션 (취소 확인)
    await Future.delayed(const Duration(milliseconds: 2000));

    // 스핀이 취소되었으면 중단
    if (_shouldCancelSpin) return;

    final randomProvince = _selectRandomDivision(_state.koreaDivisions);

    _updateState(_state.copyWith(
      selectedProvince: randomProvince,
      isSpinning1: false,
      isStep1Completed: true,
    ));
  }

  Future<void> _spinSlot2() async {
    if (_state.isSpinning2 || _state.isStep2Completed || _state.selectedProvince == null) return;

    _shouldCancelSpin = false;
    _updateState(_state.copyWith(
      isSpinning2: true,
      clearSelectedCity: true,
      clearSelectedDistrict: true,
      isStep3Completed: false,
      currentStep: SlotMachineStep.step2,
    ));

    await Future.delayed(const Duration(milliseconds: 2500));

    // 스핀이 취소되었으면 중단
    if (_shouldCancelSpin) return;

    if (_state.selectedProvince!.children.isNotEmpty) {
      final randomCity = _selectRandomDivision(_state.selectedProvince!.children);
      _updateState(_state.copyWith(
        selectedCity: randomCity,
        isSpinning2: false,
        isStep2Completed: true,
      ));
    }
  }

  Future<void> _spinSlot3() async {
    if (_state.isSpinning3 || _state.isStep3Completed || _state.selectedCity == null) return;

    _shouldCancelSpin = false;
    _updateState(_state.copyWith(
      isSpinning3: true,
      currentStep: SlotMachineStep.step3,
    ));

    await Future.delayed(const Duration(milliseconds: 3000));

    // 스핀이 취소되었으면 중단
    if (_shouldCancelSpin) return;

    if (_state.selectedCity!.children.isNotEmpty) {
      final randomDistrict = _selectRandomDivision(_state.selectedCity!.children);
      _updateState(_state.copyWith(
        selectedDistrict: randomDistrict,
        isSpinning3: false,
        isStep3Completed: true,
        showResultPopup: true,
        currentStep: SlotMachineStep.completed,
      ));
    }
  }

  void resetAll() {
    // 진행 중인 스핀 취소
    _shouldCancelSpin = true;
    
    // 상태 초기화
    _updateState(const SlotMachineState().copyWith(
      koreaDivisions: _state.koreaDivisions,
    ));
  }

  // 리셋 가능 여부 확인 (UI에서 사용)
  bool get canReset => !_state.isLoading;

  void closeResultPopup() {
    _updateState(_state.copyWith(showResultPopup: false));
  }

  List<String> getSlotCandidates(int slotNumber) {
    switch (slotNumber) {
      case 1:
        return _state.koreaDivisions.map((e) => e.name).toList();
      case 2:
        return _state.selectedProvince?.children.map((e) => e.name).toList() ?? [];
      case 3:
        return _state.selectedCity?.children.map((e) => e.name).toList() ?? [];
      default:
        return [];
    }
  }
}
