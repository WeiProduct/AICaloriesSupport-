import SwiftUI

struct ManualFoodEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: FoodLoggingViewModel
    
    @State private var foodName = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var servingSize = "100"
    @State private var selectedCategory = FoodCategory.other
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("食物名称", text: $foodName)
                    
                    Picker("分类", selection: $selectedCategory) {
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: "")
                                .tag(category)
                        }
                    }
                }
                
                Section("营养成分 (每100g)") {
                    HStack {
                        TextField("卡路里", text: $calories)
                            .keyboardType(.decimalPad)
                        Text("千卡")
                    }
                    
                    HStack {
                        TextField("蛋白质", text: $protein)
                            .keyboardType(.decimalPad)
                        Text("克")
                    }
                    
                    HStack {
                        TextField("碳水化合物", text: $carbs)
                            .keyboardType(.decimalPad)
                        Text("克")
                    }
                    
                    HStack {
                        TextField("脂肪", text: $fat)
                            .keyboardType(.decimalPad)
                        Text("克")
                    }
                }
                
                if viewModel.capturedImage != nil {
                    Section("照片") {
                        Image(uiImage: viewModel.capturedImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                    }
                }
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
                    .disabled(foodName.isEmpty || calories.isEmpty)
                }
            }
        }
    }
    
    private func saveFood() {
        viewModel.createCustomFood(
            name: foodName,
            calories: Double(calories) ?? 0,
            protein: Double(protein) ?? 0,
            carbs: Double(carbs) ?? 0,
            fat: Double(fat) ?? 0
        )
        dismiss()
    }
}