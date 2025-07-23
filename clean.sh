#!/bin/bash
# clean_android.sh

echo "Cleaning Android build artifacts..."

# Xóa các thư mục build
rm -rf .tmp/
rm -rf android/.tmp/
rm -rf android/app/build/
rm -rf android/ffmpeg-kit-android-lib/build/
rm -rf prebuilt/android-aar/
rm -rf src/

# Xóa gradle cache
rm -rf android/.gradle/
rm -rf ~/.gradle/caches/

echo "Clean completed!"