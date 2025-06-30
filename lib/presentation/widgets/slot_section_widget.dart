import 'package:flutter/material.dart';
import '../notifiers/slot_machine_notifier.dart';
import 'rolling_slot_widget.dart';

class SlotSectionWidget extends StatelessWidget {
  final String title;
  final String? value;
  final bool isSpinning;
  final Animation<double> animation;
  final VoidCallback onSpin;
  final bool canSpin;
  final int stepNumber;
  final bool isCompleted;
  final SlotMachineStep currentStep;
  final List<String> candidates;

  const SlotSectionWidget({
    super.key,
    required this.title,
    this.value,
    required this.isSpinning,
    required this.animation,
    required this.onSpin,
    required this.canSpin,
    required this.stepNumber,
    required this.isCompleted,
    required this.currentStep,
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.blue.shade50
            : canSpin
                ? Colors.green.shade50
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCompleted
              ? Colors.blue.shade400
              : _isCurrentStep()
                  ? Colors.orange
                  : Colors.grey.shade300,
          width: (_isCurrentStep() || isCompleted) ? 3 : 1,
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
                      color: isCompleted
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: isSpinning
                    ? RollingSlotWidget(
                        candidates: candidates,
                        animation: animation,
                      )
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
              backgroundColor: isCompleted
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

  bool _isCurrentStep() {
    switch (stepNumber) {
      case 1:
        return currentStep == SlotMachineStep.step1;
      case 2:
        return currentStep == SlotMachineStep.step2;
      case 3:
        return currentStep == SlotMachineStep.step3;
      default:
        return false;
    }
  }
}
