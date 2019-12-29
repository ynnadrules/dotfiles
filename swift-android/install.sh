#!/bin/bash

set -e

NDK=17c
SWIFT_ANDROID=$(curl -fsSL https://api.bintray.com/packages/readdle/swift-android-toolchain/swift-android-toolchain/versions/_latest | python -c 'import json,sys;print(json.load(sys.stdin))["name"]')
SWIFT_TOOLCHAIN=swift-5.0.3

install_location=$HOME/.android-swift

mkdir -p $install_location
pushd $install_location

  if ! [ -f "$SWIFT_TOOLCHAIN-RELEASE-osx.pkg" ]; then
    wget --progress=bar:force https://swift.org/builds/$SWIFT_TOOLCHAIN-release/xcode/$SWIFT_TOOLCHAIN-RELEASE/$SWIFT_TOOLCHAIN-RELEASE-osx.pkg
  fi

  # install Swift 5.0.3 Toolchain
  sudo installer -pkg $SWIFT_TOOLCHAIN-RELEASE-osx.pkg -target /

  if ! [ -d "android-ndk-r$NDK" ]; then
    # install ndk
    wget --progress=bar:force https://dl.google.com/android/repository/android-ndk-r$NDK-darwin-x86_64.zip
    unzip android-ndk-r$NDK-darwin-x86_64.zip
    rm -rf android-ndk-r$NDK-darwin-x86_64.zip
  fi


  if ! [ -d "swift-android-$SWIFT_ANDROID" ]; then
    # instal swift android toolchain
    wget https://dl.bintray.com/readdle/swift-android-toolchain/swift-android-$SWIFT_ANDROID.zip
    unzip swift-android-$SWIFT_ANDROID.zip
    rm -rf swift-android-$SWIFT_ANDROID.zip

    swift-android-$SWIFT_ANDROID/bin/swift-android tools --update
    ln -sfn swift-android-$SWIFT_ANDROID swift-android-current
  fi
popd
