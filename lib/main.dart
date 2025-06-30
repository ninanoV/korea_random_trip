import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/dependency_injection.dart';
import 'presentation/pages/travel_slot_machine_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 화면 방향 고정 (세로모드)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
        fontFamilyFallback: const [
          'Malgun Gothic',
          '맑은 고딕',
          'Apple SD Gothic Neo',
          'Apple Gothic',
          'Dotum',
          '돋움',
          'Helvetica Neue',
          'Helvetica',
          'Arial',
          'sans-serif'
        ],
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          titleLarge: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          titleMedium: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          titleSmall: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
          bodySmall: TextStyle(
            fontFamily: 'Noto Sans KR',
            fontFamilyFallback: ['Malgun Gothic', '맑은 고딕', 'Arial'],
          ),
        ),
      ),
      home: TravelSlotMachinePage(
        notifier: DependencyInjection.slotMachineNotifier,
      ),
    );
  }
}
