# flutter_uv_blind_refactor

A base source code for application.

## Useful tips

### App flavor for configure multi platform

<https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b>

- flutter build apk -t lib/main_dev.dart --flavor dev
- flutter build ipa -t lib/main_dev.dart --flavor dev
- flutter build apk -t lib/main_dev.dart --flavor prod
- flutter build ipa -t lib/main_dev.dart --flavor prod

### State management

<https://pub.dev/packages/get>

### Build runner generator

```flutter pub run build_runner build --delete-conflicting-outputs```

Need to run the above command after updating the following files:

- `lib/common/translations/*.lang.json`
- `lib/data/apis/rest_client.dart` [(docs)](https://pub.dev/packages/retrofit)
- `lib/data/database_hive/entities/*_entity.dart` [(docs)](https://pub.dev/packages/hive)
- `lib/data/dtos/*/*_dto.dart` [(docs)](https://pub.dev/packages/json_serializable)

### i18n generator

```flutter pub run easy_localization:generate -f keys -S ./assets/translations -O ./lib/common/translations -o locale_keys.g.dart```

File output: `lib/common/translations/locale_keys.g.dart`

### Get app build version

<https://pub.dev/packages/package_info>

### Launcher icons

<https://pub.dev/packages/flutter_launcher_icons>

- flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-dev.yaml
- flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-prod.yaml

### Native splash

<https://pub.dev/packages/flutter_native_splash>

- flutter pub pub run flutter_native_splash:create

### Image resolution

<https://pub.dev/packages/image_res>
flutter packages pub run image_res:main

- imgres

## Basic coding rules

##Generate

- Use final variable as much as you can
- For private variable use _ prefix
- For private function use _ prefix
- Turn on auto format code and use "," for better indent
- Apply analysis_options.yaml
- **NO WARNING BEFORE COMMIT**

# flutter_uv_blind_refactor
