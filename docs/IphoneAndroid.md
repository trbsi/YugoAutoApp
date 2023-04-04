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
