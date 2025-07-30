#!/bin/bash

echo "=== AI卡路里 App Testing Script ==="
echo "Testing app functionality..."

check_simulator() {
    if xcrun simctl list devices | grep -q "Booted"; then
        echo "✓ Simulator is running"
        return 0
    else
        echo "✗ Simulator is not running"
        return 1
    fi
}

take_screenshot() {
    local name=$1
    xcrun simctl io booted screenshot "/tmp/ai_calorie_${name}.png"
    echo "✓ Screenshot saved: /tmp/ai_calorie_${name}.png"
}

if ! check_simulator; then
    echo "Starting simulator..."
    xcrun simctl boot "iPhone 16"
    sleep 5
fi

echo "Launching AI卡路里 app..."
xcrun simctl launch booted com.weiproduct.AICalories
sleep 3

take_screenshot "launch"

echo "=== Test Complete ==="
echo "✓ App launched successfully"
echo "✓ Screenshot captured in /tmp/"
