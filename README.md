# 한국 랜덤 여행지 🎰

[![Deploy Flutter Web to GitHub Pages](https://github.com/username/korea_random_trip/actions/workflows/deploy.yml/badge.svg)](https://github.com/username/korea_random_trip/actions/workflows/deploy.yml)

Flutter로 제작된 슬롯머신 스타일의 한국 여행지 랜덤 선택 웹 애플리케이션입니다.

## 🌟 주요 기능

- **3단계 순차 선택**: 시/도 → 시/군/구 → 읍/면/동
- **슬롯머신 애니메이션**: 실제 지역명들이 세로로 롤링되는 애니메이션
- **완료 상태 관리**: 각 단계별 완료 상태 추적 및 재스핀 방지
- **화려한 팝업**: 여행지 선택 완료 시 축하 팝업
- **반응형 디자인**: 다양한 화면 크기 지원

## 🎮 사용 방법

1. **1단계**: "시/도" 스핀 버튼을 클릭하여 시도를 선택
2. **2단계**: "시/군/구" 스핀 버튼을 클릭하여 시군구를 선택
3. **3단계**: "읍/면/동" 스핀 버튼을 클릭하여 읍면동을 선택
4. **결과 확인**: 팝업으로 최종 여행지 확인
5. **다시 시작**: "다시 뽑기" 또는 "다시 선택하기" 버튼으로 재시작

## 🛠 기술 스택

- **Framework**: Flutter 3.24+
- **Language**: Dart
- **Deployment**: GitHub Pages
- **CI/CD**: GitHub Actions

## 🎨 특징

- **한글 최적화**: Noto Sans KR 폰트 사용
- **FOIT 방지**: 폰트 로딩 최적화로 텍스트 깜빡임 방지
- **로딩 화면**: 앱 로딩 중 커스텀 스피너 표시
- **애니메이션**: 부드러운 전환 효과와 롤링 애니메이션

## 🚀 로컬 실행

```bash
# 의존성 설치
flutter pub get

# 웹 서버 실행
flutter run -d chrome
```

## 📱 데모

[여기에서 실제 앱을 체험해보세요!](https://username.github.io/korea_random_trip/)

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.

---

Made with ❤️ using Flutter
