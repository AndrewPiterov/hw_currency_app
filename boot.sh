flutter clean
rm -rf pubspec.lock

cd ios
pod deintegrate
rm -rf build
rm -rf Pods
rm -rf ios/Runner.xcworkspace
rm -rf Podfile.lock
rm -rf .symlinks
rm -Rf Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
pod cache clean --all
cd ..

flutter pub get

cd ios/
pod install
cd ..

dart run build_runner build --delete-conflicting-outputs