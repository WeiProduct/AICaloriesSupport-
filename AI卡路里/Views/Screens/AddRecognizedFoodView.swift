import SwiftUI
import SwiftData

struct AddRecognizedFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let recognitionResult: RecognitionResult
    let image: UIImage?
    
    @State private var selectedMealType: MealType = .lunch
    @State private var quantity: Double = 100
    @State private var notes = ""
    @State private var adjustedCalories: Double = 0
    @State private var adjustedProtein: Double = 0
    @State private var adjustedCarbs: Double = 0
    @State private var adjustedFat: Double = 0
    @State private var adjustedFiber: Double? = nil
    @State private var adjustedSugar: Double? = nil
    @State private var adjustedSodium: Double? = nil
    
    var selectedFood: RecognizedFood? {
        recognitionResult.selectedFood
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    
                    foodInfoSection
                    
                    
                    mealTypeSection
                    
                    
                    quantitySection
                    
                    
                    nutritionAdjustmentSection
                    
                    
                    notesSection
                }
                .padding(.vertical)
            }
            .navigationTitle("添加食物")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveFood()
                    }
                    .disabled(selectedFood == nil)
                }
            }
            .onAppear {
                setupInitialValues()
            }
        }
    }
    
    private var foodInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("识别的食物")
                .font(.headline)
            
            if let food = selectedFood {
                HStack {
                    VStack(alignment: .leading) {
                        Text(food.name)
                            .font(.title2)
                            .bold()
                        Text("置信度: \(Int(food.confidence * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if food.confidence < 0.7 {
                        Label("低置信度", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    
    private var mealTypeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("餐次")
                .font(.headline)
                .padding(.horizontal)
            
            Picker("餐次", selection: $selectedMealType) {
                ForEach(MealType.allCases, id: \.self) { type in
                    Label {
                        Text(type.rawValue)
                    } icon: {
                        Text(type.icon)
                    }
                    .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
        }
    }
    
    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("数量")
                .font(.headline)
            
            HStack {
                Button(action: { quantity = max(0, quantity - 10) }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    TextField("数量", value: $quantity, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                    
                    Text("克")
                        .foregroundColor(.secondary)
                }
                
                Button(action: { quantity += 10 }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .onChange(of: quantity) { _, _ in
            updateNutrition()
        }
    }
    
    private var nutritionAdjustmentSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("营养成分（每\(Int(quantity))g）")
                .font(.headline)
            
            VStack(spacing: 12) {
                NutritionEditRow(
                    name: "卡路里",
                    value: $adjustedCalories,
                    unit: "千卡",
                    color: .green
                )
                
                NutritionEditRow(
                    name: "蛋白质",
                    value: $adjustedProtein,
                    unit: "g",
                    color: .blue
                )
                
                NutritionEditRow(
                    name: "碳水化合物",
                    value: $adjustedCarbs,
                    unit: "g",
                    color: .orange
                )
                
                NutritionEditRow(
                    name: "脂肪",
                    value: $adjustedFat,
                    unit: "g",
                    color: .purple
                )
                
                if adjustedFiber != nil {
                    NutritionEditRow(
                        name: "纤维",
                        value: Binding(
                            get: { adjustedFiber ?? 0 },
                            set: { adjustedFiber = $0 }
                        ),
                        unit: "g",
                        color: .brown
                    )
                }
                
                if adjustedSugar != nil {
                    NutritionEditRow(
                        name: "糖分",
                        value: Binding(
                            get: { adjustedSugar ?? 0 },
                            set: { adjustedSugar = $0 }
                        ),
                        unit: "g",
                        color: .pink
                    )
                }
                
                if adjustedSodium != nil {
                    NutritionEditRow(
                        name: "钠",
                        value: Binding(
                            get: { adjustedSodium ?? 0 },
                            set: { adjustedSodium = $0 }
                        ),
                        unit: "mg",
                        color: .gray
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("备注")
                .font(.headline)
            
            TextField("添加备注（可选）", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3)
        }
        .padding(.horizontal)
    }
    
    private func setupInitialValues() {
        setupMealTypeBasedOnTime()
        updateNutrition()
    }
    
    private func setupMealTypeBasedOnTime() {
        
        selectedMealType = MealTimeManager.shared.getMealType(for: Date())
    }
    
    private func updateNutrition() {
        guard let food = selectedFood else { return }
        
        let ratio = quantity / food.estimatedWeight
        adjustedCalories = food.calories * ratio
        adjustedProtein = food.protein * ratio
        adjustedCarbs = food.carbs * ratio
        adjustedFat = food.fat * ratio
        
        
        if let fiber = food.fiber {
            adjustedFiber = fiber * ratio
        }
        if let sugar = food.sugar {
            adjustedSugar = sugar * ratio
        }
        if let sodium = food.sodium {
            adjustedSodium = sodium * ratio
        }
    }
    
    private func saveFood() {
        guard let selectedFood = selectedFood else { return }
        
        
        let food = Food(
            name: selectedFood.name,
            calories: adjustedCalories * 100 / quantity, 
            protein: adjustedProtein * 100 / quantity,
            carbs: adjustedCarbs * 100 / quantity,
            fat: adjustedFat * 100 / quantity,
            servingSize: 100,
            servingUnit: selectedFood.servingUnit,
            category: FoodCategory(rawValue: selectedFood.category) ?? .other
        )
        
        
        if let fiber = adjustedFiber {
            food.fiber = fiber * 100 / quantity
        }
        if let sugar = adjustedSugar {
            food.sugar = sugar * 100 / quantity
        }
        if let sodium = adjustedSodium {
            food.sodium = sodium * 100 / quantity
        }
        
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            food.imageData = imageData
        }
        
        modelContext.insert(food)
        
        
        let meal = Meal(
            food: food,
            quantity: quantity,
            mealType: selectedMealType
        )
        
        if !notes.isEmpty {
            meal.notes = notes
        }
        
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            meal.imageData = imageData
        }
        
        modelContext.insert(meal)
        
        
        let todayLog = getTodayLog() ?? createTodayLog()
        todayLog.meals.append(meal)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save recognized food: \(error)")
        }
    }
    
    private func getTodayLog() -> DailyLog? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<DailyLog> { log in
            log.date >= startOfDay && log.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<DailyLog>(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("Failed to fetch today's log: \(error)")
            return nil
        }
    }
    
    private func createTodayLog() -> DailyLog {
        let log = DailyLog()
        modelContext.insert(log)
        return log
    }
}

struct NutritionEditRow: View {
    let name: String
    @Binding var value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Label(name, systemImage: "")
                .foregroundColor(color)
            
            Spacer()
            
            HStack(spacing: 5) {
                TextField("", value: $value, format: .number.precision(.fractionLength(1)))
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
                Text(unit)
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .leading)
            }
        }
    }
}