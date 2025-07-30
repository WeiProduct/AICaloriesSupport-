#!/bin/bash

echo "Checking Swift files for import and syntax issues..."

find AI卡路里 -name "*.swift" -type f | while read file; do
    echo "Checking: $file"
    
    swiftc -parse "$file" 2>&1 | grep -E "error:|warning:" | head -5
    
    grep -H "^import" "$file" | grep -v -E "SwiftUI|Foundation|SwiftData|Charts|PhotosUI|UIKit" && echo "  ⚠️  Unusual import found"
    
    grep -H "@Observable" "$file" > /dev/null && echo "  ✓ Uses @Observable"
    
    grep -H "@Model" "$file" > /dev/null && echo "  ✓ Uses @Model"
done