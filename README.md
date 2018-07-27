<div align = "center">
    <h1>AgriDex</h1>
    <p>Connecting sheep to you</p>
    <a href="https://www.dartlang.org/" target="_blank"><img src="https://img.shields.io/badge/Dart-2.0.0-ff69b4.svg?longCache=true&style=for-the-badge" alt="Dart"></a>
    <a href="https://flutter.io/" target="_blank"><img src="https://img.shields.io/badge/Flutter-0.5.1-3BB9FF.svg?longCache=true&style=for-the-badge" alt="Flutter"></a>
    <a href="https://firebase.google.com/" target="_blank"><img src="https://img.shields.io/badge/Firebase-Cloud-orange.svg?longCache=true&style=for-the-badge" alt="Firebase"></a>
    <a href="https://gradle.org/" target="_blank"><img src="https://img.shields.io/badge/Gradle-4.1-green.svg?longCache=true&style=for-the-badge" alt="Gradle"></a>
</div>

## About

A Flutter app that helps manage farm livestock

## Building

You can follow these instructions to build the AgriDex app and install it onto your device.

### Prerequisites

If you are new to Flutter, please first follow the [Flutter Setup](https://flutter.io/setup/) guide.

#### Google API Configs

Obtain a copy of `GoogleService-Info.plist` and `google-services.json` from the firebase console and put them in the following directories if you need to build for release

```bash
./ios/Runner/GoogleService-Info.plist
./android/app/google-services.json
```

### Build/Debug App

If you are debugging the application on a simulator, run the following to launch the iOS simulator

```bash
open -a Simulator
```

Then run the following to debug with live reloading

```bash
flutter run --debug
```

### Deploying Firebase Configuration

First install the firebase-tools package

```bash
npm install -g firebase-tools
```

Run the following to login to `firebase` cli

```bash
firebase login
```

Run the following within your `./firebase/functions/` directory if you are deploying functions

```bash
npm install
```

Make all the necessary changes within `./firebase/` in this project repository and then push the configuration using the following.

```bash
$ firebase deploy

=== Deploying to 'agri-dex'...

i  deploying storage, firestore, functions, hosting

etc...

✔  Deploy complete!
```

### Generating the App Icons

Icon was created using: https://pub.dartlang.org/packages/flutter_launcher_icons

```bash
flutter pub get
flutter pub pub run flutter_launcher_icons:main
```

Due to a difference in the way that iOS and Android handle transparency, there's a separate icon file for iOS and a method for toggling on and off the icon changes in the `pubspec.yaml`

## Build Issues

#### `MissingPluginException`

If you are getting a missing plugin exception (likely due to Firestore Cloud) simply run the following to clear out the old builds

```bash
flutter clean
flutter packages get
```

#### Can't Compile Debug APK

If you are unable to compile a debug version of the APK go into `./android/app/build.gradle` and change the following line (comment out release and add the debug config)

```xml
buildTypes {
    release {
        //signingConfig signingConfigs.release
        signingConfig signingConfigs.debug
    }
}
```

#### iOS Build Fails around `BoringSSL/internal.h`

As Flutter is still in development and more importantly, the external packages that tie in to services like Google Play are still changing a lot, there's often some teething issues with breaking dependencies and build. Run the following in to hopefully resolve most of the issues

```bash
cd ios/
rm -rf Pods/ Podfile.lock ; pod install
```

## Authors

* Nathan Glover [@nathangloverAUS (Twitter)](https://twitter.com/nathangloverAUS), [@t04glovern (Github)](https://github.com/t04glovern)
* Rico Beti [@RicoBeti (Twitter)](https://twitter.com/RicoBeti), [@silentbyte (Github)](https://github.com/SilentByte)
