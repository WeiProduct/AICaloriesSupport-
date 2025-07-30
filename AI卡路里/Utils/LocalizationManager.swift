import SwiftUI

class LocalizationManager: ObservableObject {
    @Published var selectedLanguage: String = "zh" {
        didSet {
            
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            
            
            if selectedLanguage == "zh" {
                UserDefaults.standard.set("zh-Hans", forKey: "AppLanguage")
            } else {
                UserDefaults.standard.set("en", forKey: "AppLanguage")
            }
        }
    }
    
    static let shared = LocalizationManager()
    
    private init() {
        
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            self.selectedLanguage = savedLanguage
        }
    }
    
    
    private let localizedStrings: [String: [String: String]] = [
        
        "tab.today": ["en": "Today", "zh": "今日"],
        "tab.record": ["en": "Record", "zh": "记录"],
        "tab.camera": ["en": "Camera", "zh": "拍照"],
        "tab.history": ["en": "History", "zh": "历史"],
        "tab.profile": ["en": "Profile", "zh": "我的"],
        
        
        "today.title": ["en": "Daily Summary", "zh": "今日概览"],
        "today.greeting": ["en": "Have a great day", "zh": "今天是美好的一天"],
        "today.remaining": ["en": "Remaining Calories", "zh": "剩余卡路里"],
        "today.target": ["en": "Target", "zh": "目标"],
        "today.limit": ["en": "Limit", "zh": "限制"],
        "today.consumed": ["en": "Consumed", "zh": "已摄入"],
        "today.exercise": ["en": "Exercise", "zh": "运动消耗"],
        "today.water": ["en": "Water Intake", "zh": "今日饮水"],
        "today.meals": ["en": "Today's Meals", "zh": "今日餐食"],
        "today.notRecorded": ["en": "Not recorded yet", "zh": "还未记录"],
        
        
        "camera.title": ["en": "AI Food Recognition", "zh": "AI识别食物"],
        "camera.take": ["en": "Take Photo", "zh": "拍照"],
        "camera.album": ["en": "Photo Library", "zh": "相册"],
        "camera.prompt": ["en": "Take or select a food photo", "zh": "拍摄或选择食物照片"],
        "camera.aiPrompt": ["en": "AI will automatically recognize food and calculate nutrition", "zh": "AI将自动识别食物并计算营养成分"],
        "camera.analyzing": ["en": "AI is recognizing food...", "zh": "AI正在识别食物..."],
        "camera.result": ["en": "Recognition Result", "zh": "识别结果"],
        "camera.confidence": ["en": "Confidence", "zh": "置信度"],
        "camera.lowConfidence": ["en": "Low confidence, please confirm manually", "zh": "识别置信度较低，建议手动确认"],
        "camera.quickAdd": ["en": "Record Food with Camera", "zh": "拍照记录食物"],
        "camera.aiQuick": ["en": "AI Recognition, Quick Record", "zh": "AI 智能识别，快速记录"],
        "camera.retake": ["en": "Retake", "zh": "重拍"],
        "camera.takeOrSelectPhoto": ["en": "Take or Select Food Photo", "zh": "拍摄或选择食物照片"],
        "camera.aiWillRecognize": ["en": "AI will automatically recognize food and calculate nutrients", "zh": "AI将自动识别食物并计算营养成分"],
        "camera.aiRecognizing": ["en": "AI is recognizing food...", "zh": "AI正在识别食物..."],
        "camera.recognitionResult": ["en": "Recognition Result", "zh": "识别结果"],
        "camera.lowConfidenceWarning": ["en": "Low confidence, please verify manually", "zh": "识别置信度较低，建议手动确认"],
        "camera.takePhoto": ["en": "Take Photo", "zh": "拍照"],
        "camera.photoLibrary": ["en": "Photo Library", "zh": "相册"],
        "camera.about": ["en": "About", "zh": "约"],
        "camera.addSuccess": ["en": "Successfully added to today's meals", "zh": "成功添加到今日饮食"],
        "camera.mockData": ["en": "Mock Data", "zh": "模拟数据"],
        "camera.addAllFoods": ["en": "Add all foods to today's meals", "zh": "添加所有食物到今日饮食"],
        "camera.aiUnavailable": ["en": "⚠️ AI recognition service temporarily unavailable", "zh": "⚠️ AI识别服务暂时不可用"],
        "camera.mockDataWarning": ["en": "Currently showing mock data, please check network connection and retry", "zh": "当前显示的是模拟数据，请检查网络连接后重试"],
        "camera.retry": ["en": "Retry", "zh": "重新识别"],
        "camera.recognitionFailed": ["en": "Recognition Failed", "zh": "识别失败"],
        "camera.error.imageProcessing": ["en": "Image processing failed, please retry", "zh": "图片处理失败，请重试"],
        "camera.error.requestCreation": ["en": "Request creation failed, please retry", "zh": "请求创建失败，请重试"],
        "camera.error.noData": ["en": "No response data received, please check network connection", "zh": "未收到响应数据，请检查网络连接"],
        "camera.error.invalidResponse": ["en": "Invalid server response, please retry", "zh": "服务器响应无效，请重试"],
        "camera.error.parsingFailed": ["en": "Data parsing failed, please retry", "zh": "数据解析失败，请重试"],
        "camera.error.networkFailed": ["en": "Network connection failed, please check network settings and retry", "zh": "网络连接失败，请检查网络设置后重试"],
        "camera.error.generic": ["en": "Recognition failed: ", "zh": "识别失败："],
        
        
        "nutrition.title": ["en": "Nutrients", "zh": "营养素"],
        "nutrition.calories": ["en": "Calories", "zh": "卡路里"],
        "nutrition.protein": ["en": "Protein", "zh": "蛋白质"],
        "nutrition.carbs": ["en": "Carbohydrates", "zh": "碳水化合物"],
        "nutrition.fat": ["en": "Fat", "zh": "脂肪"],
        "nutrition.fiber": ["en": "Fiber", "zh": "纤维"],
        "nutrition.sugar": ["en": "Sugar", "zh": "糖"],
        "nutrition.sodium": ["en": "Sodium", "zh": "钠"],
        
        
        "meal.breakfast": ["en": "Breakfast", "zh": "早餐"],
        "meal.lunch": ["en": "Lunch", "zh": "午餐"],
        "meal.dinner": ["en": "Dinner", "zh": "晚餐"],
        "meal.snack": ["en": "Snack", "zh": "零食"],
        "meal.allDay": ["en": "All day", "zh": "全天"],
        
        
        "record.title": ["en": "Record Food", "zh": "记录饮食"],
        "record.searchFood": ["en": "Search food", "zh": "搜索食物"],
        "record.manualAdd": ["en": "Add Food Manually", "zh": "手动添加食物"],
        "record.recentFoods": ["en": "Recent Foods", "zh": "最近食用"],
        "record.favoriteFoods": ["en": "Favorite Foods", "zh": "常用食物"],
        "record.noRecords": ["en": "No records", "zh": "暂无记录"],
        "record.noFavorites": ["en": "No favorites", "zh": "暂无收藏"],
        "record.addTo": ["en": "Add to", "zh": "添加到"],
        "record.quantity": ["en": "Quantity", "zh": "数量"],
        "record.per": ["en": "per", "zh": "每"],
        
        
        "history.title": ["en": "History", "zh": "历史记录"],
        "history.trend": ["en": "Calorie Trend", "zh": "卡路里趋势"],
        "history.average": ["en": "Average Intake", "zh": "平均摄入"],
        "history.goalDays": ["en": "Goal Days", "zh": "达标天数"],
        "history.streak": ["en": "Streak", "zh": "连续记录"],
        "history.details": ["en": "Details", "zh": "详细记录"],
        "history.perDay": ["en": "/day", "zh": "/天"],
        "history.days": ["en": "days", "zh": "天"],
        "history.period": ["en": "Period", "zh": "时间段"],
        "history.period.week": ["en": "Week", "zh": "周"],
        "history.period.month": ["en": "Month", "zh": "月"],
        "history.period.year": ["en": "Year", "zh": "年"],
        "history.chartType": ["en": "Chart Type", "zh": "图表类型"],
        "history.caloriesTrend": ["en": "Calories Trend", "zh": "卡路里趋势"],
        "history.nutrientsTrend": ["en": "Nutrients Trend", "zh": "营养素趋势"],
        "history.status.achieved": ["en": "Achieved", "zh": "达标"],
        "history.status.exceeded": ["en": "Exceeded", "zh": "超标"],
        "history.status.insufficient": ["en": "Insufficient", "zh": "不足"],
        "history.meals": ["en": "meals", "zh": "餐"],
        
        
        "search.results": ["en": "Search Results", "zh": "搜索结果"],
        
        
        "action.save": ["en": "Save", "zh": "保存"],
        "action.cancel": ["en": "Cancel", "zh": "取消"],
        "action.delete": ["en": "Delete", "zh": "删除"],
        "action.edit": ["en": "Edit", "zh": "编辑"],
        "action.add": ["en": "Add", "zh": "添加"],
        "action.search": ["en": "Search", "zh": "搜索"],
        "action.done": ["en": "Done", "zh": "完成"],
        "action.retake": ["en": "Retake", "zh": "重拍"],
        "action.continue": ["en": "Continue", "zh": "继续"],
        "action.complete": ["en": "Complete Setup", "zh": "完成设置"],
        "action.ok": ["en": "OK", "zh": "确定"],
        
        
        "food.unknown": ["en": "Unknown Food", "zh": "未知食物"],
        
        
        "weekday.sunday": ["en": "Sunday", "zh": "周日"],
        "weekday.monday": ["en": "Monday", "zh": "周一"],
        "weekday.tuesday": ["en": "Tuesday", "zh": "周二"],
        "weekday.wednesday": ["en": "Wednesday", "zh": "周三"],
        "weekday.thursday": ["en": "Thursday", "zh": "周四"],
        "weekday.friday": ["en": "Friday", "zh": "周五"],
        "weekday.saturday": ["en": "Saturday", "zh": "周六"],
        
        
        "unit.kcal": ["en": "kcal", "zh": "千卡"],
        "unit.gram": ["en": "g", "zh": "克"],
        "unit.ml": ["en": "ml", "zh": "毫升"],
        "unit.kg": ["en": "kg", "zh": "公斤"],
        "unit.lb": ["en": "lb", "zh": "磅"],
        "unit.cm": ["en": "cm", "zh": "厘米"],
        
        
        "water.intake": ["en": "Water Intake", "zh": "饮水量"],
        "water.daily": ["en": "Daily Water", "zh": "每日饮水"],
        "water.target": ["en": "Water Target", "zh": "饮水目标"],
        "water.add": ["en": "Add Water", "zh": "添加饮水"],
        "water.ml": ["en": "ml", "zh": "毫升"],
        "water.cup": ["en": "Cup", "zh": "杯"],
        "water.bottle": ["en": "Bottle", "zh": "瓶"],
        "water.todayIntake": ["en": "Today's Water Intake", "zh": "今日已饮水"],
        "water.quickAdd": ["en": "Quick Add", "zh": "快速添加"],
        "water.custom": ["en": "Custom", "zh": "自定义"],
        "water.unit": ["en": "Unit", "zh": "单位"],
        "water.history": ["en": "History", "zh": "历史记录"],
        "water.recordTitle": ["en": "Record Water", "zh": "记录饮水"],
        "water.weeklyAverage": ["en": "Weekly Average", "zh": "周平均"],
        "water.goalAchievement": ["en": "Goal Achievement", "zh": "目标达成率"],
        "water.weeklyTrend": ["en": "Weekly Trend", "zh": "周趋势"],
        "water.dailyRecords": ["en": "Daily Records", "zh": "每日记录"],
        "date": ["en": "Date", "zh": "日期"],
        
        
        "settings.profile": ["en": "Personal Information", "zh": "个人信息"],
        "profile.defaultName": ["en": "User", "zh": "用户"],
        "profile.setup.title": ["en": "Complete Your Profile", "zh": "完善您的信息"],
        "profile.setup.subtitle": ["en": "This helps us calculate your personalized calorie needs", "zh": "这有助于我们计算您的个性化卡路里需求"],
        "profile.basicInfo": ["en": "Basic Information", "zh": "基本信息"],
        "profile.name": ["en": "Name", "zh": "姓名"],
        "profile.namePlaceholder": ["en": "Enter your name", "zh": "请输入您的姓名"],
        "profile.age": ["en": "Age", "zh": "年龄"],
        "profile.agePlaceholder": ["en": "Enter your age", "zh": "请输入您的年龄"],
        "profile.gender": ["en": "Gender", "zh": "性别"],
        "profile.bodyMeasurements": ["en": "Body Measurements", "zh": "身体数据"],
        "profile.currentWeight": ["en": "Current Weight", "zh": "当前体重"],
        "profile.weightPlaceholder": ["en": "70", "zh": "70"],
        "profile.height": ["en": "Height", "zh": "身高"],
        "profile.heightPlaceholder": ["en": "170", "zh": "170"],
        "profile.goalWeight": ["en": "Goal Weight", "zh": "目标体重"],
        "profile.goalWeightPlaceholder": ["en": "65", "zh": "65"],
        "profile.activityLevel": ["en": "Activity Level", "zh": "活动水平"],
        "profile.error.nameRequired": ["en": "Please enter your name", "zh": "请输入您的姓名"],
        "profile.error.invalidAge": ["en": "Please enter a valid age", "zh": "请输入有效的年龄"],
        "profile.error.invalidWeight": ["en": "Please enter a valid weight", "zh": "请输入有效的体重"],
        "profile.error.invalidHeight": ["en": "Please enter a valid height", "zh": "请输入有效的身高"],
        "profile.error.invalidGoalWeight": ["en": "Please enter a valid goal weight", "zh": "请输入有效的目标体重"],
        "profile.error.goalWeightTooHigh": ["en": "Goal weight should be less than current weight for weight loss", "zh": "减重目标体重应小于当前体重"],
        "profile.error.goalWeightTooLow": ["en": "Goal weight should be greater than current weight for weight gain", "zh": "增重目标体重应大于当前体重"],
        "profile.error.saveFailed": ["en": "Failed to save profile. Please try again.", "zh": "保存失败，请重试。"],
        "settings.goal": ["en": "Goal Settings", "zh": "目标设置"],
        "settings.reminder": ["en": "Reminder Settings", "zh": "提醒设置"],
        "settings.units": ["en": "Unit Settings", "zh": "单位设置"],
        "settings.language": ["en": "Language", "zh": "语言"],
        "settings.about": ["en": "About", "zh": "关于"],
        "settings.version": ["en": "Version", "zh": "版本"],
        "settings.help": ["en": "Help", "zh": "使用帮助"],
        "settings.feedback": ["en": "Feedback", "zh": "意见反馈"],
        "settings.preferences": ["en": "Preferences", "zh": "偏好设置"],
        "settings.setupProfile": ["en": "Set up profile", "zh": "设置个人信息"],
        "settings.setupProfileDesc": ["en": "Complete your profile for more accurate recommendations", "zh": "完善信息以获得更准确的建议"],
        "settings.weightGoal": ["en": "Weight Goal", "zh": "减重目标"],
        "settings.activityLevel": ["en": "Activity Level", "zh": "活动水平"],
        "settings.dataExport": ["en": "Data Export", "zh": "数据导出"],
        "units.metric": ["en": "Metric", "zh": "公制"],
        "goal.maintain": ["en": "Maintain Weight", "zh": "维持体重"],
        "activity.moderate": ["en": "Moderate Activity", "zh": "中度活动"],
        "activity.sedentary": ["en": "Sedentary", "zh": "久坐"],
        "activity.light": ["en": "Light Activity", "zh": "轻度活动"],
        "activity.active": ["en": "Active", "zh": "高度活动"],
        "activity.veryActive": ["en": "Very Active", "zh": "非常活跃"],
        "activity.sedentary.desc": ["en": "Little or no exercise", "zh": "很少或没有运动"],
        "activity.light.desc": ["en": "Light exercise 1-3 days/week", "zh": "每周1-3天轻度运动"],
        "activity.moderate.desc": ["en": "Moderate exercise 3-5 days/week", "zh": "每周3-5天中度运动"],
        "activity.active.desc": ["en": "Hard exercise 6-7 days/week", "zh": "每周6-7天高强度运动"],
        "activity.veryActive.desc": ["en": "Hard daily exercise or physical job", "zh": "每天高强度运动或体力工作"],
        "goal.lose": ["en": "Lose Weight", "zh": "减重"],
        "goal.gain": ["en": "Gain Weight", "zh": "增重"],
        "goal.loseDesc": ["en": "Create a calorie deficit to reduce body weight", "zh": "制造卡路里缺口以减少体重"],
        "goal.maintainDesc": ["en": "Balance calories to maintain current weight", "zh": "平衡卡路里以维持当前体重"],
        "goal.gainDesc": ["en": "Create a calorie surplus to increase body weight", "zh": "制造卡路里盈余以增加体重"],
        "goal.selection.title": ["en": "What's Your Goal?", "zh": "您的目标是什么？"],
        "goal.selection.subtitle": ["en": "This helps us personalize your calorie recommendations", "zh": "这有助于我们为您定制卡路里建议"],
        "gender.male": ["en": "Male", "zh": "男性"],
        "gender.female": ["en": "Female", "zh": "女性"],
        
        
        "export.title": ["en": "Export Data", "zh": "导出数据"],
        "export.format": ["en": "Format", "zh": "格式"],
        "export.period": ["en": "Period", "zh": "时间段"],
        "export.period.week": ["en": "Last 7 Days", "zh": "最近7天"],
        "export.period.month": ["en": "Last 30 Days", "zh": "最近30天"],
        "export.period.all": ["en": "All Data", "zh": "全部数据"],
        "export.includeData": ["en": "Include Data", "zh": "包含数据"],
        "export.includeWater": ["en": "Water Intake", "zh": "饮水记录"],
        "export.includeMeals": ["en": "Meal Details", "zh": "餐食详情"],
        "export.includeNutrients": ["en": "Nutrients", "zh": "营养素"],
        "export.export": ["en": "Export", "zh": "导出"],
        
        
        "weight.weight": ["en": "Weight", "zh": "体重"],
        "weight.current": ["en": "Current Weight", "zh": "当前体重"],
        "weight.goal": ["en": "Goal Weight", "zh": "目标体重"],
        "weight.history": ["en": "Weight History", "zh": "体重历史"],
        "weight.record": ["en": "Record Weight", "zh": "记录体重"],
        "weight.recordTitle": ["en": "Weight Record", "zh": "体重记录"],
        "weight.lastRecord": ["en": "Last Record", "zh": "上次记录"],
        "weight.viewHistory": ["en": "View History", "zh": "查看历史"],
        "weight.unit": ["en": "Unit", "zh": "单位"],
        "weight.trend": ["en": "Weight Trend", "zh": "体重趋势"],
        "weight.weeklyChange": ["en": "Weekly", "zh": "周变化"],
        "weight.monthlyChange": ["en": "Monthly", "zh": "月变化"],
        "weight.bmi": ["en": "BMI", "zh": "BMI"],
        "weight.records": ["en": "Weight Records", "zh": "体重记录"],
        "weight.noRecords": ["en": "No weight records yet", "zh": "暂无体重记录"],
        "weight.add": ["en": "Add Weight", "zh": "添加体重"],
        "weight.atGoal": ["en": "At goal weight!", "zh": "已达到目标体重！"],
        "weight.aboveGoal": ["en": "above goal", "zh": "高于目标"],
        "weight.belowGoal": ["en": "below goal", "zh": "低于目标"],
        
        
        "date.today": ["en": "Today", "zh": "今天"],
        "date.yesterday": ["en": "Yesterday", "zh": "昨天"],
        "date.daysAgo": ["en": "days ago", "zh": "天前"],
        
        
        "food.category.fruit": ["en": "Fruit", "zh": "水果"],
        "food.category.vegetable": ["en": "Vegetable", "zh": "蔬菜"],
        "food.category.grain": ["en": "Grain", "zh": "谷物"],
        "food.category.protein": ["en": "Protein", "zh": "蛋白质"],
        "food.category.dairy": ["en": "Dairy", "zh": "乳制品"],
        "food.category.beverage": ["en": "Beverage", "zh": "饮料"],
        "food.category.snack": ["en": "Snack", "zh": "零食"],
        "food.category.other": ["en": "Other", "zh": "其他"],
        
        
        "reminder.permission": ["en": "Permission", "zh": "权限"],
        "reminder.notificationPermission": ["en": "Notification Permission", "zh": "通知权限"],
        "reminder.permissionDenied": ["en": "Permission Denied", "zh": "权限被拒绝"],
        "reminder.permissionDeniedMessage": ["en": "Please enable notifications in Settings to use reminders", "zh": "请在设置中启用通知以使用提醒功能"],
        "reminder.goToSettings": ["en": "Go to Settings", "zh": "前往设置"],
        "reminder.quickActions": ["en": "Quick Actions", "zh": "快速操作"],
        "reminder.enableDefault": ["en": "Enable Default Reminders", "zh": "启用默认提醒"],
        "reminder.disableAll": ["en": "Disable All Reminders", "zh": "关闭所有提醒"],
        "reminder.water": ["en": "Water Reminders", "zh": "饮水提醒"],
        "reminder.water.description": ["en": "Get reminded to drink water throughout the day", "zh": "全天定时提醒您喝水"],
        "reminder.meal": ["en": "Meal Reminders", "zh": "用餐提醒"],
        "reminder.meal.description": ["en": "Get reminded to log your meals", "zh": "提醒您记录每餐饮食"],
        "reminder.weight": ["en": "Weight Reminder", "zh": "体重提醒"],
        "reminder.weight.description": ["en": "Get reminded to track your weight", "zh": "提醒您记录体重"],
        "reminder.addWater": ["en": "Add Water Reminder", "zh": "添加饮水提醒"],
        "reminder.addMeal": ["en": "Add Meal Reminder", "zh": "添加用餐提醒"],
        "reminder.setWeight": ["en": "Set Weight Reminder", "zh": "设置体重提醒"],
        "reminder.time": ["en": "Time", "zh": "时间"],
        "reminder.repeatDays": ["en": "Repeat Days", "zh": "重复日期"],
        "reminder.mealType": ["en": "Meal Type", "zh": "餐次类型"],
        "reminder.frequency": ["en": "Frequency", "zh": "频率"],
        "reminder.frequency.daily": ["en": "Daily", "zh": "每天"],
        "reminder.frequency.weekly": ["en": "Weekly", "zh": "每周"],
        "reminder.frequency.monthly": ["en": "Monthly", "zh": "每月"],
        "reminder.everyday": ["en": "Every day", "zh": "每天"],
        "reminder.never": ["en": "Never", "zh": "从不"],
        "reminder.weight.daily.description": ["en": "Remind every day at the specified time", "zh": "每天在指定时间提醒"],
        "reminder.weight.weekly.description": ["en": "Remind every Sunday at the specified time", "zh": "每周日在指定时间提醒"],
        "reminder.weight.monthly.description": ["en": "Remind on the 1st of each month at the specified time", "zh": "每月1日在指定时间提醒"],
        
        
        "notification.water.title": ["en": "Time to Hydrate! 💧", "zh": "该喝水了！💧"],
        "notification.water.body": ["en": "Remember to drink water to stay healthy", "zh": "记得喝水，保持健康"],
        "notification.meal.title": ["en": "Meal Time! 🍽️", "zh": "用餐时间！🍽️"],
        "notification.meal.body": ["en": "Don't forget to log your %@", "zh": "别忘了记录您的%@"],
        "notification.weight.title": ["en": "Weight Check! ⚖️", "zh": "体重检查！⚖️"],
        "notification.weight.body": ["en": "Time to record your weight progress", "zh": "是时候记录您的体重进展了"],
        
        
        
        "error.title": ["en": "Error", "zh": "错误"],
        "error.database": ["en": "Database Error", "zh": "数据库错误"],
        "error.network": ["en": "Network Error", "zh": "网络错误"],
        "error.validation": ["en": "Validation Error", "zh": "验证错误"],
        "error.permission": ["en": "Permission Error", "zh": "权限错误"],
        "error.unknown": ["en": "Unknown Error", "zh": "未知错误"],
        "error.database.recovery": ["en": "Please try again. If the problem persists, restart the app.", "zh": "请重试。如果问题持续存在，请重启应用。"],
        "error.network.recovery": ["en": "Please check your internet connection and try again.", "zh": "请检查您的网络连接并重试。"],
        "error.validation.recovery": ["en": "Please check your input and try again.", "zh": "请检查您的输入并重试。"],
        "error.permission.recovery": ["en": "Please grant the required permissions in Settings.", "zh": "请在设置中授予所需权限。"],
        "error.unknown.recovery": ["en": "An unexpected error occurred. Please try again.", "zh": "发生了意外错误。请重试。"],
        "error.retry": ["en": "Retry", "zh": "重试"],
        "success.title": ["en": "Success", "zh": "成功"],
        
        
        "mealTime.settings": ["en": "Meal Time Settings", "zh": "餐食时间设置"],
        "mealTime.description": ["en": "Set your meal time periods. Food will be automatically categorized based on when you add it.", "zh": "设置您的用餐时间段，应用会根据添加食物的时间自动分类到对应的餐食。"],
        "mealTime.startTime": ["en": "Start Time", "zh": "开始时间"],
        "mealTime.endTime": ["en": "End Time", "zh": "结束时间"],
        "mealTime.preview": ["en": "Time Range Preview", "zh": "时间段预览"],
        "mealTime.reset": ["en": "Reset to Default", "zh": "重置为默认时间"],
        "mealTime.resetConfirm": ["en": "Reset Time Settings", "zh": "重置时间设置"],
        "mealTime.resetMessage": ["en": "Are you sure you want to reset to default meal times?", "zh": "确定要重置为默认的餐食时间吗？"],
        "mealTime.otherTime": ["en": "Other times", "zh": "其他时间"],
        
        
        "disclaimer.title": ["en": "Health Information & Disclaimer", "zh": "健康信息与免责声明"],
        "disclaimer.important": ["en": "Important Notice", "zh": "重要提示"],
        "disclaimer.text": ["en": "This app provides nutritional information for general educational purposes only. It is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition or dietary needs.", "zh": "本应用提供的营养信息仅供一般教育参考。不能替代专业医疗建议、诊断或治疗。如有任何医疗状况或饮食需求相关问题，请咨询您的医生或其他合格的健康专业人士。"],
        "disclaimer.accept": ["en": "I Understand and Accept", "zh": "我理解并接受"],
        
        "citations.title": ["en": "Medical & Nutritional References", "zh": "医学与营养参考资料"],
        "citations.viewSource": ["en": "View Source", "zh": "查看来源"],
        "citations.usda.title": ["en": "USDA FoodData Central", "zh": "美国农业部食品数据中心"],
        "citations.usda.description": ["en": "Primary source for food composition data", "zh": "食物成分数据的主要来源"],
        "citations.who.title": ["en": "WHO Healthy Diet Guidelines", "zh": "世界卫生组织健康饮食指南"],
        "citations.who.description": ["en": "International dietary recommendations", "zh": "国际饮食建议标准"],
        "citations.dri.title": ["en": "Dietary Reference Intakes (DRIs)", "zh": "膳食营养素参考摄入量"],
        "citations.dri.description": ["en": "Recommended nutrient intake values", "zh": "推荐的营养素摄入量标准"],
        "citations.cdc.title": ["en": "CDC Nutrition Guidelines", "zh": "美国疾控中心营养指南"],
        "citations.cdc.description": ["en": "Public health nutrition recommendations", "zh": "公共健康营养建议"],
        
        "dataSources.title": ["en": "Data Sources", "zh": "数据来源"],
        "dataSources.calories": ["en": "Calorie calculations based on USDA FoodData Central", "zh": "卡路里计算基于美国农业部食品数据中心"],
        "dataSources.macros": ["en": "Macronutrient values from standardized food composition databases", "zh": "宏量营养素数值来自标准化食品成分数据库"],
        "dataSources.recommendations": ["en": "Daily intake recommendations from WHO and national health organizations", "zh": "每日摄入建议来自世界卫生组织和各国卫生机构"],
        "dataSources.bmi": ["en": "BMI calculations follow WHO international standards", "zh": "BMI计算遵循世界卫生组织国际标准"],
        "dataSources.water": ["en": "Hydration recommendations from Institute of Medicine guidelines", "zh": "饮水建议来自医学研究所指南"],
        
        "limitations.title": ["en": "Limitations & Warnings", "zh": "限制与警告"],
        "limitations.text": ["en": "Individual nutritional needs vary. This app should not be used as the sole basis for medical decisions. Consult healthcare professionals for personalized advice, especially if you have medical conditions, are pregnant, or are under 18 years old.", "zh": "个人营养需求因人而异。本应用不应作为医疗决策的唯一依据。请咨询医疗专业人士获取个性化建议，特别是如果您有疾病、怀孕或未满18岁。"],
        
        "settings.disclaimer": ["en": "Health Disclaimer", "zh": "健康免责声明"],
        "settings.citations": ["en": "View Citations", "zh": "查看引用资料"],
        
        "nutrition.source.info": ["en": "Nutritional data from USDA FoodData Central", "zh": "营养数据来自美国农业部食品数据中心"],
        "nutrition.dataSource": ["en": "Data Sources", "zh": "数据来源"]
    ]
    
    func localized(_ key: String) -> String {
        return localizedStrings[key]?[selectedLanguage] ?? key
    }
    
    
    static func localized(_ key: String) -> String {
        return shared.localized(key)
    }
}


extension View {
    func localized(_ key: String) -> String {
        return LocalizationManager.localized(key)
    }
}