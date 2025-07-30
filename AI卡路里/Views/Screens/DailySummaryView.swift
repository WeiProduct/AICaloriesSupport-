import SwiftUI

struct DailySummaryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DailySummaryViewModel()
    @State private var showingWaterInput = false
    @State private var showingWeightInput = false
    @State private var showingCamera = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    dateHeader
                    quickAddFoodCard
                    caloriesSummaryCard
                    nutritionProgressSection
                    waterIntakeCard
                    mealsSection
                    
                    
                    NutritionSourceView()
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle(LocalizationManager.localized("today.title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    LanguageSwitcher()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingWeightInput = true }) {
                        Image(systemName: "scalemass")
                    }
                }
            }
            .sheet(isPresented: $showingWaterInput) {
                WaterIntakeView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingWeightInput) {
                WeightInputView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingCamera) {
                CameraFoodRecognitionView()
                    .onDisappear {
                        
                        viewModel.loadTodayData()
                    }
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
            .onChange(of: showingCamera) { oldValue, newValue in
                
                if oldValue && !newValue {
                    viewModel.loadTodayData()
                }
            }
        }
    }
    
    private var dateHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(Date(), style: .date)
                    .font(.title2)
                    .bold()
                Text(LocalizationManager.localized("today.greeting"))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    private var quickAddFoodCard: some View {
        Button(action: { showingCamera = true }) {
            HStack(spacing: 15) {
                
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "camera.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizationManager.localized("camera.quickAdd"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(LocalizationManager.localized("camera.aiQuick"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.1), Color.green.opacity(0.05)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .shadow(color: .green.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var caloriesSummaryCard: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text(LocalizationManager.localized("today.remaining"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(viewModel.caloriesRemaining))")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(caloriesRemainingColor)
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: viewModel.calorieProgress,
                    color: progressCircleColor,
                    lineWidth: 10
                )
                .frame(width: 80, height: 80)
                .onTapGesture {
                    showingCamera = true
                }
            }
            
            HStack {
                VStack {
                    Text("\(Int(viewModel.todayLog?.targetCalories ?? 2000))")
                        .font(.headline)
                    Text(LocalizationManager.localized(viewModel.isWeightLossMode ? "today.limit" : "today.target"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("\(Int(viewModel.todayLog?.totalCalories ?? 0))")
                        .font(.headline)
                        .foregroundColor(consumedCaloriesColor)
                    Text(LocalizationManager.localized("today.consumed"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("0")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text(LocalizationManager.localized("today.exercise"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
    
    private var caloriesRemainingColor: Color {
        if viewModel.isWeightLossMode {
            return viewModel.isOverLimit ? .red : .green
        } else {
            return viewModel.caloriesRemaining > 0 ? .green : .red
        }
    }
    
    private var progressCircleColor: Color {
        if viewModel.isWeightLossMode {
            return viewModel.isOverLimit ? .red : .green
        } else {
            return .green
        }
    }
    
    private var consumedCaloriesColor: Color {
        if viewModel.isWeightLossMode {
            return viewModel.isOverLimit ? .red : .green
        } else {
            return .green
        }
    }
    
    private var nutritionProgressSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text(LocalizationManager.localized("nutrition.title"))
                    .font(.headline)
                Spacer()
            }
            
            NutritionProgressRow(
                name: LocalizationManager.localized("nutrition.protein"),
                current: viewModel.todayLog?.totalProtein ?? 0,
                target: viewModel.todayLog?.targetProtein ?? 50,
                unit: LocalizationManager.localized("unit.gram"),
                color: .blue
            )
            
            NutritionProgressRow(
                name: LocalizationManager.localized("nutrition.carbs"),
                current: viewModel.todayLog?.totalCarbs ?? 0,
                target: viewModel.todayLog?.targetCarbs ?? 250,
                unit: LocalizationManager.localized("unit.gram"),
                color: .orange
            )
            
            NutritionProgressRow(
                name: LocalizationManager.localized("nutrition.fat"),
                current: viewModel.todayLog?.totalFat ?? 0,
                target: viewModel.todayLog?.targetFat ?? 65,
                unit: LocalizationManager.localized("unit.gram"),
                color: .purple
            )
        }
    }
    
    private var waterIntakeCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizationManager.localized("today.water"))
                        .font(.headline)
                    Text("\(getWaterCupsText())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { showingWaterInput = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.2))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: geometry.size.width * min(viewModel.waterIntake / 2000, 1.0), height: 20)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.waterIntake)
                    
                    
                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { index in
                            if Double(index) / 8.0 <= viewModel.waterIntake / 2000 {
                                Image(systemName: "drop.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width / 8)
                            } else {
                                Color.clear
                                    .frame(width: geometry.size.width / 8)
                            }
                        }
                    }
                }
            }
            .frame(height: 20)
            
            HStack {
                Text("\(Int(viewModel.waterIntake)) \(LocalizationManager.localized("unit.ml"))")
                    .font(.subheadline)
                    .bold()
                Spacer()
                Text("2000 \(LocalizationManager.localized("unit.ml"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func getWaterCupsText() -> String {
        let cups = Int(viewModel.waterIntake / 250)
        let cupsText = LocalizationManager.localized("water.cup")
        return "\(cups) \(cupsText)"
    }
    
    private var mealsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(LocalizationManager.localized("today.meals"))
                .font(.headline)
            
            ForEach(MealType.allCases, id: \.self) { mealType in
                mealTypeSection(mealType)
            }
        }
    }
    
    private func mealTypeSection(_ mealType: MealType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(mealType.localizedName, systemImage: "")
                Text(mealType.icon)
                Spacer()
                Text(mealType.timeRange)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let meals = viewModel.mealsByType[mealType], !meals.isEmpty {
                ForEach(meals) { meal in
                    MealRowView(meal: meal) {
                        viewModel.deleteMeal(meal)
                    }
                }
            } else {
                Text(LocalizationManager.localized("today.notRecorded"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}