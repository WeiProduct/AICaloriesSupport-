import SwiftUI

struct NutritionProgressRow: View {
    let name: String
    let current: Double
    let target: Double
    let unit: String
    let color: Color
    
    private var progress: Double {
        min(current / target, 1.0)
    }
    
    private var percentage: Int {
        Int(progress * 100)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(current))/\(Int(target)) \(unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.3)
                        .foregroundColor(color)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(progress) * geometry.size.width, geometry.size.width), height: 8)
                        .foregroundColor(color)
                        .cornerRadius(4)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
}