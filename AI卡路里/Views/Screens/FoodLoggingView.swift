import SwiftUI

struct FoodLoggingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FoodLoggingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                mealTypeSelector
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Button(action: { viewModel.showingManualEntry = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(LocalizationManager.localized("record.manualAdd"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(10)
                        }
                        
                        if viewModel.selectedFood != nil {
                            selectedFoodCard
                        }
                        
                        if !viewModel.searchText.isEmpty {
                            searchResultsSection
                        } else {
                            recentFoodsSection
                            favoriteFoodsSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(LocalizationManager.localized("record.title"))
            .searchable(text: $viewModel.searchText, prompt: LocalizationManager.localized("record.searchFood"))
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.searchFoods()
            }
            .sheet(isPresented: $viewModel.showingManualEntry) {
                ManualFoodEntryView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
        }
    }
    
    private var mealTypeSelector: some View {
        Picker("", selection: $viewModel.selectedMealType) {
            ForEach(MealType.allCases, id: \.self) { type in
                Text(type.localizedName)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .background(Color(.systemBackground))
    }
    
    
    private var selectedFoodCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.selectedFood?.name ?? "")
                    .font(.headline)
                Spacer()
                Button(LocalizationManager.localized("action.cancel")) {
                    viewModel.selectedFood = nil
                }
                .foregroundColor(.red)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(LocalizationManager.localized("record.per"))\(Int(viewModel.selectedFood?.servingSize ?? 100))\(viewModel.selectedFood?.servingUnit ?? LocalizationManager.localized("unit.gram"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(viewModel.selectedFood?.calories ?? 0)) \(LocalizationManager.localized("unit.kcal"))")
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                HStack {
                    Button(action: { viewModel.quantity = max(0, viewModel.quantity - 10) }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.gray)
                    }
                    
                    TextField(LocalizationManager.localized("record.quantity"), value: $viewModel.quantity, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.selectedFood?.servingUnit ?? LocalizationManager.localized("unit.gram"))
                        .foregroundColor(.secondary)
                    
                    Button(action: { viewModel.quantity += 10 }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            
            Button(action: viewModel.logMeal) {
                Text("\(LocalizationManager.localized("record.addTo")) \(viewModel.selectedMealType.localizedName)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("search.results"))
                .font(.headline)
            
            ForEach(viewModel.searchResults) { food in
                FoodRowView(food: food, onTap: {
                    viewModel.selectedFood = food
                }, onToggleFavorite: { food in
                    viewModel.toggleFavorite(food)
                })
            }
        }
    }
    
    private var recentFoodsSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("record.recentFoods"))
                .font(.headline)
            
            if viewModel.recentFoods.isEmpty {
                Text(LocalizationManager.localized("record.noRecords"))
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(viewModel.recentFoods) { food in
                    FoodRowView(food: food, onTap: {
                        viewModel.selectedFood = food
                    }, onToggleFavorite: { food in
                        viewModel.toggleFavorite(food)
                    })
                }
            }
        }
    }
    
    private var favoriteFoodsSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("record.favoriteFoods"))
                .font(.headline)
            
            if viewModel.favoriteFoods.isEmpty {
                Text(LocalizationManager.localized("record.noFavorites"))
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ForEach(viewModel.favoriteFoods) { food in
                    FoodRowView(food: food, onTap: {
                        viewModel.selectedFood = food
                    }, onToggleFavorite: { food in
                        viewModel.toggleFavorite(food)
                    })
                }
            }
        }
    }
}