# clifting_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── exceptions/
│   │   ├── api_exceptions.dart
│   │   └── app_exceptions.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_provider.dart
│   │   └── dio_interceptor.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
│   └── utils/
│       └── error_handler.dart
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/
│       │   │   └── auth_models.dart
│       │   └── repositories/
│       │       └── auth_repository.dart
│       └── presentation/
│           ├── providers/
│           │   └── auth_provider.dart
│           ├── screens/
│           │   ├── login_screen.dart
│           │   ├── home_screen.dart
│           │   └── ...
│           └── widgets/
│               └── error_widgets.dart
└── main.dart