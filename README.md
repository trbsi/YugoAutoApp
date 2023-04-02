# About

Mobile version for YugoAuto (free alternative to BlaBlaCar).

## Live site

https://www.yugoauto.com/

# Setup

## Firebase push

Firebase - https://firebase.google.com/docs/cloud-messaging/flutter/client

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on
mobile development, and a full API reference.

# Build for iOS and Android production

https://www.instabug.com/blog/how-to-release-your-flutter-app-for-ios-and-android

# iOS

## Pod install and update

Do it like this:  arch -x86_64 pod update

## Create APNS certificate

https://medium.com/zero-equals-false/generate-apns-certificate-for-ios-push-notifications-85e4a917d522

Don't forget to enable push in Xcode
![](/docs/images/iospush.png)

## Build app

In short I used "flutter build ipa" and then Transporter app to upload to App Store

# Android

## Build app

https://stackoverflow.com/questions/55536637/how-to-build-signed-apk-from-android-studio-for-flutter