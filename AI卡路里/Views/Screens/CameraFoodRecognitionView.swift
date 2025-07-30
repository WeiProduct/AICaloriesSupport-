import SwiftUI
import PhotosUI
import SwiftData
import Foundation

struct CameraFoodRecognitionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isAnalyzing = false
    @State private var recognitionResult: RecognitionResult?
    @State private var showingAddFood = false
    @State private var showingAddingAllFoods = false
    @State private var showingAddSuccess = false
    @State private var recognitionError: String?
    
    private let recognitionService = FoodRecognitionService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let image = selectedImage {
                    imagePreviewSection(image)
                } else {
                    emptyStateSection
                }
                
                actionButtonsSection
            }
            .navigationTitle(LocalizationManager.localized("camera.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                if selectedImage != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(LocalizationManager.localized("camera.retake")) {
                            resetSelection()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView { image in
                    selectedImage = image
                    analyzeImage(image)
                }
            }
            .photosPicker(
                isPresented: $showingPhotoPicker,
                selection: $selectedPhoto,
                matching: .images
            )
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        analyzeImage(image)
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                if let result = recognitionResult {
                    AddRecognizedFoodView(
                        recognitionResult: result,
                        image: selectedImage
                    )
                }
            }
        }
        .overlay(
            Group {
                if showingAddSuccess {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                            Text(LocalizationManager.localized("camera.addSuccess"))
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding(.bottom, 50)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: showingAddSuccess)
                }
            }
        )
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 100))
                .foregroundColor(.green.opacity(0.5))
            
            Text(LocalizationManager.localized("camera.takeOrSelectPhoto"))
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text(LocalizationManager.localized("camera.aiWillRecognize"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
    
    private func imagePreviewSection(_ image: UIImage) -> some View {
        VStack(spacing: 0) {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .cornerRadius(10)
                .padding()
            
            if isAnalyzing {
                
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    
                    Text(LocalizationManager.localized("camera.aiRecognizing"))
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(.systemGray6))
            } else if let error = recognitionError {
                
                errorSection(error)
            } else if let result = recognitionResult {
                
                recognitionResultSection(result)
            }
            
            Spacer()
        }
    }
    
    private func recognitionResultSection(_ result: RecognitionResult) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(LocalizationManager.localized("camera.recognitionResult"))
                        .font(.headline)
                    
                    Spacer()
                    
                    if result.isFromMockData {
                        
                        Label(LocalizationManager.localized("camera.mockData"), systemImage: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                
                CompactNutritionSourceLink()
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(result.foods) { food in
                        RecognizedFoodRow(food: food) {
                            
                            recognitionResult?.selectedFood = food
                            showingAddFood = true
                        }
                    }
                    
                    
                    Button(action: {
                        addAllFoodsToTodaysMeals()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text(LocalizationManager.localized("camera.addAllFoods"))
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(15)
                        .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, 10)
                    
                    
                    if result.isFromMockData {
                        VStack(spacing: 10) {
                            Text(LocalizationManager.localized("camera.aiUnavailable"))
                                .font(.subheadline)
                                .foregroundColor(.orange)
                            
                            Text(LocalizationManager.localized("camera.mockDataWarning"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                if let image = selectedImage {
                                    analyzeImage(image)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text(LocalizationManager.localized("camera.retry"))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            
            if result.confidence < 0.7 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text(LocalizationManager.localized("camera.lowConfidenceWarning"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGray6))
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 20) {
            Button(action: { showingCamera = true }) {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                    Text(LocalizationManager.localized("camera.takePhoto"))
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            
            Button(action: { showingPhotoPicker = true }) {
                VStack(spacing: 8) {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                    Text(LocalizationManager.localized("camera.photoLibrary"))
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
        }
        .padding()
    }
    
    private func resetSelection() {
        selectedImage = nil
        recognitionResult = nil
        isAnalyzing = false
        recognitionError = nil
    }
    
    private func errorSection(_ errorMessage: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text(LocalizationManager.localized("camera.recognitionFailed"))
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                if let image = selectedImage {
                    analyzeImage(image)
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("重新识别")
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Color(.systemGray6))
    }
    
    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true
        recognitionError = nil
        
        recognitionService.recognizeFood(from: image) { result in
            switch result {
            case .success(let recognitionResult):
                self.recognitionResult = recognitionResult
                self.recognitionError = nil
            case .failure(let error):
                self.recognitionResult = nil
                self.recognitionError = getErrorMessage(from: error)
            }
            self.isAnalyzing = false
        }
    }
    
    private func getErrorMessage(from error: Error) -> String {
        if let openAIError = error as? OpenAIError {
            switch openAIError {
            case .imageProcessingFailed:
                return LocalizationManager.localized("camera.error.imageProcessing")
            case .requestCreationFailed:
                return LocalizationManager.localized("camera.error.requestCreation")
            case .noData:
                return LocalizationManager.localized("camera.error.noData")
            case .invalidResponse:
                return LocalizationManager.localized("camera.error.invalidResponse")
            case .parsingFailed:
                return LocalizationManager.localized("camera.error.parsingFailed")
            }
        } else if (error as NSError).domain == NSURLErrorDomain {
            return LocalizationManager.localized("camera.error.networkFailed")
        }
        return LocalizationManager.localized("camera.error.generic") + error.localizedDescription
    }
    
    private func addAllFoodsToTodaysMeals() {
        guard let result = recognitionResult else { return }
        
        
        showingAddingAllFoods = true
        
        
        let todayLog = getOrCreateTodaysDailyLog()
        
        
        for food in result.foods {
            
            
            
            
            
            
            
            let standardServingSize = 100.0  
            let ratio = standardServingSize / food.estimatedWeight  
            
            let newFood = Food(
                name: food.name,
                calories: food.calories * ratio,     
                protein: food.protein * ratio,       
                carbs: food.carbs * ratio,           
                fat: food.fat * ratio,               
                servingSize: standardServingSize,
                servingUnit: food.servingUnit,
                category: categoryFromString(food.category)
            )
            
            
            newFood.fiber = food.fiber != nil ? food.fiber! * ratio : nil
            newFood.sugar = food.sugar != nil ? food.sugar! * ratio : nil
            newFood.sodium = food.sodium != nil ? food.sodium! * ratio : nil
            
            modelContext.insert(newFood)
            
            
            let meal = Meal(food: newFood, quantity: food.estimatedWeight, mealType: MealTimeManager.shared.getMealType(for: Date()))
            modelContext.insert(meal)
            
            
            todayLog.meals.append(meal)
        }
        
        do {
            try modelContext.save()
            
            showingAddSuccess = true
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showingAddSuccess = false
                resetSelection()
            }
        } catch {
            print("Failed to save foods: \(error)")
        }
        
        showingAddingAllFoods = false
    }
    
    private func categoryFromString(_ categoryString: String) -> FoodCategory {
        switch categoryString.lowercased() {
        case "protein": return .protein
        case "vegetable": return .vegetable
        case "fruit": return .fruit
        case "grain": return .grain
        case "dairy": return .dairy
        case "beverage": return .beverage
        case "snack": return .snack
        default: return .other
        }
    }
    
    private func getOrCreateTodaysDailyLog() -> DailyLog {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: #Predicate { log in
                log.date >= today && log.date < tomorrow
            }
        )
        
        do {
            let logs = try modelContext.fetch(descriptor)
            if let existingLog = logs.first {
                return existingLog
            }
        } catch {
            print("Error fetching today's log: \(error)")
        }
        
        
        
        let profileDescriptor = FetchDescriptor<UserProfile>()
        let profile = try? modelContext.fetch(profileDescriptor).first
        
        let targetCalories = profile?.targetCalories ?? profile?.recommendedCalories ?? Constants.defaultTargetCalories
        let newLog = DailyLog(date: today, targetCalories: targetCalories)
        
        
        if let profile = profile {
            newLog.targetProtein = profile.targetProtein ?? (targetCalories * Constants.defaultProteinRatio / 4)
            newLog.targetCarbs = profile.targetCarbs ?? (targetCalories * Constants.defaultCarbsRatio / 4)
            newLog.targetFat = profile.targetFat ?? (targetCalories * Constants.defaultFatRatio / 9)
        }
        
        modelContext.insert(newLog)
        return newLog
    }
    
}


struct RecognitionResult {
    let foods: [RecognizedFood]
    let confidence: Double
    var selectedFood: RecognizedFood?
    var isFromMockData: Bool = false  
}

struct RecognizedFood: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let estimatedWeight: Double
    let fiber: Double?
    let sugar: Double?
    let sodium: Double?
    let servingUnit: String
    let category: String
}


struct RecognizedFoodRow: View {
    let food: RecognizedFood
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(food.name)
                            .font(.headline)
                        Text("\(Int(food.confidence * 100))%")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(confidenceColor.opacity(0.2))
                            .foregroundColor(confidenceColor)
                            .cornerRadius(10)
                    }
                    
                    Text("\(LocalizationManager.localized("camera.about")) \(Int(food.estimatedWeight))\(LocalizationManager.localized("unit.gram"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(food.calories)) \(LocalizationManager.localized("unit.kcal"))")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    HStack(spacing: 10) {
                        NutrientBadge(value: food.protein, unit: LocalizationManager.localized("unit.gram"), color: .blue)
                        NutrientBadge(value: food.carbs, unit: LocalizationManager.localized("unit.gram"), color: .orange)
                        NutrientBadge(value: food.fat, unit: LocalizationManager.localized("unit.gram"), color: .purple)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var confidenceColor: Color {
        if food.confidence >= 0.8 {
            return .green
        } else if food.confidence >= 0.6 {
            return .orange
        } else {
            return .red
        }
    }
}

struct NutrientBadge: View {
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        Text("\(Int(value))\(unit)")
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}