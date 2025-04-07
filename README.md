# Grain - lightweight photo editor [![App Store](https://img.shields.io/badge/App_Store-0D96F6?logo=app-store&logoColor=white)](https://apps.apple.com/ru/app/grain-photo-editor/id6741040418)

![created at](https://img.shields.io/github/created-at/eternalcult/grain)
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/eternalcult/grain/main)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/eternalcult/grain/main)

<p align="center">
  <img src="https://github.com/eternalcult/grain/blob/main/Grain/Grain/Resources/Assets.xcassets/grain.imageset/grain-icon.png" alt="Icon" width="300" height="300">
</p>

![swift](https://img.shields.io/badge/Language-Swift-blue) ![mvvm+r](https://img.shields.io/badge/Architecture-MVVM+Router-blue) ![swiftUI](https://img.shields.io/badge/UI-SwiftUI-blue) ![ios17](https://img.shields.io/badge/Minimum_Deployment-iOS17-blue) ![DI](https://img.shields.io/badge/DI-Factory-blue) ![CI/CD](https://img.shields.io/badge/CI/CD-Xcode_Cloud-blue)

## Особенности
### Почему в проекте нет @Published, @StateObject и т.д?
Начиная с iOS 17 SwiftUI предоставляет поддержку Observation. [Migrating from the Observable Object protocol to the Observable macro](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)

## Документация

Cобрать документацию можно в Xcode с помощью: Shift + Control + Command + D

## Зависимости

- **[Firebase](https://github.com/firebase/firebase-ios-sdk)** – Analytics & Crashlytics. В Crashlytics отправляются не только краши, но и все ошибки, которые могут возникнуть в приложении.
- **[Factory](https://github.com/hmlongco/Factory)** – используется для Dependency Injection на проекте.

## Что такое .cubedata?

Файлы .cubedata — это .cube-файлы (стандартный LUT-формат, используемый во всех фото- и видеоредакторах для цветокоррекции), переконвертированные в формат, поддерживаемый CIColorCubeFilter. Для этого в отдельном репозитории есть небольшое приложение, которое позволяет создавать .cubedata файлы с помощью drag & drop.
<p align="center">
  <img src="https://s6.gifyu.com/images/bzgEg.gif" width="500"/>
</p>
