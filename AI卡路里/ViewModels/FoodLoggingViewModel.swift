import SwiftUI
import SwiftData
import PhotosUI
import Observation

@Observable
class FoodLoggingViewModel {
    private var modelContext: ModelContext?
    
    var searchText = ""
    var selectedMealType: MealType = .lunch
    var selectedFood: Food?
    var quantity: Double = 100
    var showingFoodPicker = false
    var showingCamera = false
    var showingManualEntry = false
    var selectedPhoto: PhotosPickerItem?
    var capturedImage: UIImage?
    
    var searchResults: [Food] = []
    var recentFoods: [Food] = []
    var favoriteFoods: [Food] = []
    
    init() {
        setupMealTypeBasedOnTime()
    }
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadFoods()
    }
    
    private func setupMealTypeBasedOnTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6...10:
            selectedMealType = .breakfast
        case 11...14:
            selectedMealType = .lunch
        case 17...20:
            selectedMealType = .dinner
        default:
            selectedMealType = .snack
        }
    }
    
    func loadFoods() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<Food>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            let allFoods = try modelContext.fetch(descriptor)
            recentFoods = Array(allFoods.prefix(Constants.recentFoodsLimit))
            favoriteFoods = allFoods.filter { $0.isFavorite }
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Loading foods")
        }
    }
    
    func searchFoods() {
        guard let modelContext = modelContext, !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        
        let descriptor = FetchDescriptor<Food>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            let allFoods = try modelContext.fetch(descriptor)
            
            
            searchResults = SearchService.shared.rankedSearch(
                query: searchText,
                in: allFoods
            ) as? [Food] ?? []
            
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Searching foods")
        }
    }
    
    func logMeal() {
        guard let modelContext = modelContext,
              let selectedFood = selectedFood else { return }
        
        let meal = Meal(
            food: selectedFood,
            quantity: quantity,
            mealType: selectedMealType
        )
        
        if let capturedImage = capturedImage {
            meal.imageData = capturedImage.jpegData(compressionQuality: 0.8)
        }
        
        modelContext.insert(meal)
        
        let todayLog = getTodayLog() ?? createTodayLog()
        todayLog.meals.append(meal)
        
        do {
            try modelContext.save()
            resetForm()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving meal", retry: {
                self.logMeal()
            })
        }
    }
    
    private func getTodayLog() -> DailyLog? {
        guard let modelContext = modelContext else { return nil }
        
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
            ErrorHandlingService.shared.handle(error, context: "Fetching today's log")
            return nil
        }
    }
    
    private func createTodayLog() -> DailyLog {
        let log = DailyLog()
        
        
        if let modelContext = modelContext {
            let descriptor = FetchDescriptor<UserProfile>()
            if let profile = try? modelContext.fetch(descriptor).first,
               let targetCalories = profile.targetCalories {
                log.targetCalories = targetCalories
                log.targetProtein = profile.targetProtein ?? (targetCalories * Constants.defaultProteinRatio / 4)
                log.targetCarbs = profile.targetCarbs ?? (targetCalories * Constants.defaultCarbsRatio / 4)
                log.targetFat = profile.targetFat ?? (targetCalories * Constants.defaultFatRatio / 9)
            }
        }
        
        modelContext?.insert(log)
        return log
    }
    
    func resetForm() {
        selectedFood = nil
        quantity = 100
        searchText = ""
        capturedImage = nil
        showingFoodPicker = false
    }
    
    func processImage(_ image: UIImage) {
        capturedImage = image
        showingManualEntry = true
    }
    
    func createCustomFood(name: String, calories: Double, protein: Double, carbs: Double, fat: Double) {
        guard let modelContext = modelContext else { return }
        
        let food = Food(
            name: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
        
        modelContext.insert(food)
        selectedFood = food
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving custom food")
        }
    }
    
    func toggleFavorite(_ food: Food) {
        guard let modelContext = modelContext else { return }
        
        food.isFavorite.toggle()
        
        do {
            try modelContext.save()
            
            loadFoods()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Toggling favorite")
        }
    }
}