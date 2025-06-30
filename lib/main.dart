import 'package:flutter/material.dart';
import 'core/dependency_injection.dart';
import 'presentation/pages/travel_slot_machine_page.dart';

void main() {
  DependencyInjection.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한국 랜덤 여행지',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
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
      home: TravelSlotMachinePage(
        notifier: DependencyInjection.slotMachineNotifier,
      ),
    );
  }
}
