// 한국 랜덤 여행지 앱 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:korea_random_trip/core/dependency_injection.dart';
import 'package:korea_random_trip/main.dart';

void main() {
  setUpAll(() {
    // 테스트 시작 전 의존성 주입 설정
    DependencyInjection.setup();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // 앱을 빌드하고 첫 프레임 렌더링
    await tester.pumpWidget(const MyApp());

    // 새로운 초기 화면 확인
    expect(find.text('한국 랜덤 여행지'), findsOneWidget);
    expect(find.text('여행지 탐험 시작!'), findsOneWidget);

    // 몇 번의 펌프로 상태 변화 확인
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('App builds without errors', (WidgetTester tester) async {
    // 앱이 오류 없이 빌드되는지만 확인
    await tester.pumpWidget(const MyApp());

    // MaterialApp이 올바르게 생성되는지 확인
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
