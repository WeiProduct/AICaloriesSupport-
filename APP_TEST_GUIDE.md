# AI卡路里 App Testing Guide

## Current Status
✅ App successfully launched
✅ Language selection screen displayed correctly
✅ No runtime errors or crashes

## Manual Testing Steps

### 1. Language Selection
The app is currently showing the language selection screen with:
- **Left button**: English (Select Your Language)
- **Right button**: Chinese (选择您的语言)

**Test**: Click either language option to proceed to the main app.

### 2. Main Features to Test

After selecting a language, test these key features:

#### A. Navigation Tabs (Bottom)
1. **Today (今日)** - Daily summary view
2. **Record (记录)** - Food logging
3. **Camera (拍照)** - Center tab for photo recognition
4. **History (历史)** - Historical data and charts
5. **Profile (我的)** - Settings and user profile

#### B. Core Functionality Tests

**Today Tab:**
- View daily calorie summary
- Check water intake tracking
- Add water intake
- View today's meals

**Record Tab:**
- Search for foods
- Add food manually
- View recent foods
- Mark foods as favorites

**Camera Tab (Main Feature):**
- Take photo of food
- View AI recognition results
- Adjust portion size
- Save recognized food to log

**History Tab:**
- View calorie trend chart
- Check weekly/monthly statistics
- View detailed meal history

**Profile Tab:**
- Set up personal information
- Configure daily goals
- Manage reminders
- Change app language

### 3. Error Handling Tests

Try these scenarios to test error handling:
- Enter invalid data in forms
- Try to save without required fields
- Test network-dependent features offline

### 4. Data Persistence Test
1. Add some foods to your daily log
2. Close the app completely
3. Reopen and verify data is preserved

### 5. Localization Test
1. Switch between English and Chinese in settings
2. Verify all UI elements update correctly
3. Check that number formats are appropriate

## Known Working Features
- ✅ App launch and initialization
- ✅ Language selection screen
- ✅ Error handling for data fetch issues
- ✅ SwiftData integration
- ✅ Localization system

## Optimization Results
- All hardcoded strings replaced with localized versions
- Constants centralized for easy maintenance
- Comprehensive error handling implemented
- Clean code structure with MVVM pattern

## Next Steps
1. Complete manual testing of all features
2. Test on different device sizes
3. Verify performance with larger datasets
4. Test reminder notifications
5. Validate data export functionality