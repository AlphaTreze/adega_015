# ADEGA 015 ORIGINALES (Flutter)

## Como rodar
1. `flutter create adega_015 --platforms=web,android,ios`
2. Copie a pasta `lib/` e o `pubspec.yaml` deste projeto para dentro de `adega_015/` (substituindo os existentes).
3. Apague `test/widget_test.dart` (o teste padrão aponta para um app que não existe mais).
4. `flutter pub get`
5. Web: `flutter run -d chrome` | Celular: `flutter run`
6. Publicar web: `flutter build web`

## Android: permissão para abrir links (WhatsApp, telefone, Maps)
Em `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>` (fora de `<application>`):
```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="tel"/></intent>
</queries>
```

## iOS: em `ios/Runner/Info.plist` adicione
```xml
<key>LSApplicationQueriesSchemes</key>
<array><string>https</string><string>tel</string></array>
```
