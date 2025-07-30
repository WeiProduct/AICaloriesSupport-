#!/bin/bash

echo "Building AI卡路里 app..."

xcodebuild clean -project AI卡路里.xcodeproj -scheme AI卡路里

xcodebuild build \
    -project AI卡路里.xcodeproj \
    -scheme AI卡路里 \
    -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
    -configuration Debug \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    | grep -E "(error:|warning:|SUCCEEDED|FAILED)"

echo "Build complete!"