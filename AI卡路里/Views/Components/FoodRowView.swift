import SwiftUI

struct FoodRowView: View {
    let food: Food
    let onTap: () -> Void
    @State private var isFavorite: Bool
    let onToggleFavorite: ((Food) -> Void)?
    
    init(food: Food, onTap: @escaping () -> Void, onToggleFavorite: ((Food) -> Void)? = nil) {
        self.food = food
        self.onTap = onTap
        self.onToggleFavorite = onToggleFavorite
        self._isFavorite = State(initialValue: food.isFavorite)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(food.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    HStack {
                        Text("\(Int(food.calories)) \(LocalizationManager.localized("unit.kcal"))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("/ \(Int(food.servingSize))\(food.servingUnit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isFavorite.toggle()
                    onToggleFavorite?(food)
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
                .onTapGesture {
                    isFavorite.toggle()
                    onToggleFavorite?(food)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}