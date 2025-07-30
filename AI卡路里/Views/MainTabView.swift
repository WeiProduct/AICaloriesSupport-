import SwiftUI
import PhotosUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCamera = false
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DailySummaryView()
                .tabItem {
                    Label(localizationManager.localized("tab.today"), systemImage: "calendar.day.timeline.left")
                }
                .tag(0)
            
            FoodLoggingView()
                .tabItem {
                    Label(localizationManager.localized("tab.record"), systemImage: "square.and.pencil")
                }
                .tag(1)
            
            
            Color.clear
                .tabItem {
                    Label(localizationManager.localized("tab.camera"), systemImage: "camera.circle.fill")
                }
                .tag(2)
            
            HistoryView()
                .tabItem {
                    Label(localizationManager.localized("tab.history"), systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label(localizationManager.localized("tab.profile"), systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(.green)
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                
                selectedTab = oldValue
                showingCamera = true
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraFoodRecognitionView()
        }
    }
}