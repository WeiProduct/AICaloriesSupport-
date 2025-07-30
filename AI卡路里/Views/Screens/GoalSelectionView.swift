import SwiftUI
import SwiftData

struct GoalSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasSelectedGoal") private var hasSelectedGoal: Bool = false
    @AppStorage("selectedGoal") private var storedGoal: String = Goal.maintain.rawValue
    @State private var selectedGoal: Goal = .maintain
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.98, blue: 0.95),
                        Color(red: 0.90, green: 0.96, blue: 0.90)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 20) {
                        Image(systemName: "target")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Text(LocalizationManager.localized("goal.selection.title"))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(LocalizationManager.localized("goal.selection.subtitle"))
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, geometry.size.height * 0.1)
                    
                    Spacer()
                    
                    
                    VStack(spacing: 20) {
                        
                        GoalOptionCard(
                            goal: .lose,
                            isSelected: selectedGoal == .lose,
                            iconName: "arrow.down.circle.fill",
                            gradientColors: [.red.opacity(0.8), .red],
                            onTap: { selectedGoal = .lose }
                        )
                        
                        
                        GoalOptionCard(
                            goal: .maintain,
                            isSelected: selectedGoal == .maintain,
                            iconName: "equal.circle.fill",
                            gradientColors: [.blue.opacity(0.8), .blue],
                            onTap: { selectedGoal = .maintain }
                        )
                        
                        
                        GoalOptionCard(
                            goal: .gain,
                            isSelected: selectedGoal == .gain,
                            iconName: "arrow.up.circle.fill",
                            gradientColors: [.green.opacity(0.8), .green],
                            onTap: { selectedGoal = .gain }
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        saveGoalAndContinue()
                    }) {
                        Text(LocalizationManager.localized("action.continue"))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .green.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func saveGoalAndContinue() {
        
        storedGoal = selectedGoal.rawValue
        hasSelectedGoal = true
    }
}

struct GoalOptionCard: View {
    let goal: Goal
    let isSelected: Bool
    let iconName: String
    let gradientColors: [Color]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                Image(systemName: iconName)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(goal.localizedName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(goal.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isSelected ? gradientColors : [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: isSelected ? gradientColors[0].opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GoalSelectionView()
        .modelContainer(for: [UserProfile.self], inMemory: true)
}