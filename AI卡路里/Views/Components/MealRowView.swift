import SwiftUI

struct MealRowView: View {
    let meal: Meal
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.food?.name ?? LocalizationManager.localized("food.unknown"))
                    .font(.subheadline)
                    .lineLimit(1)
                Text("\(Int(meal.quantity)) \(meal.food?.servingUnit ?? "g")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(meal.totalCalories)) \(LocalizationManager.localized("unit.kcal"))")
                    .font(.subheadline)
                    .bold()
                HStack(spacing: 8) {
                    NutrientLabel(value: meal.totalProtein, unit: LocalizationManager.localized("unit.gram"), color: .blue)
                    NutrientLabel(value: meal.totalCarbs, unit: LocalizationManager.localized("unit.gram"), color: .orange)
                    NutrientLabel(value: meal.totalFat, unit: LocalizationManager.localized("unit.gram"), color: .purple)
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label(LocalizationManager.localized("action.delete"), systemImage: "trash")
            }
        }
    }
}

struct NutrientLabel: View {
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