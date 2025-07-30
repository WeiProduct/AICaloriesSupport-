import SwiftUI


enum AppError: LocalizedError {
    case databaseError(String)
    case networkError(String)
    case validationError(String)
    case permissionDenied(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .databaseError(let message):
            return "\(LocalizationManager.localized("error.database")): \(message)"
        case .networkError(let message):
            return "\(LocalizationManager.localized("error.network")): \(message)"
        case .validationError(let message):
            return "\(LocalizationManager.localized("error.validation")): \(message)"
        case .permissionDenied(let message):
            return "\(LocalizationManager.localized("error.permission")): \(message)"
        case .unknown(let message):
            return "\(LocalizationManager.localized("error.unknown")): \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .databaseError:
            return LocalizationManager.localized("error.database.recovery")
        case .networkError:
            return LocalizationManager.localized("error.network.recovery")
        case .validationError:
            return LocalizationManager.localized("error.validation.recovery")
        case .permissionDenied:
            return LocalizationManager.localized("error.permission.recovery")
        case .unknown:
            return LocalizationManager.localized("error.unknown.recovery")
        }
    }
}


struct ErrorAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryAction: ErrorAction?
    let secondaryAction: ErrorAction?
    
    struct ErrorAction {
        let title: String
        let action: () -> Void
    }
    
    init(error: Error, primaryAction: ErrorAction? = nil, secondaryAction: ErrorAction? = nil) {
        self.title = LocalizationManager.localized("error.title")
        self.message = error.localizedDescription
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    init(title: String, message: String, primaryAction: ErrorAction? = nil, secondaryAction: ErrorAction? = nil) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}


class ErrorHandlingService: ObservableObject {
    static let shared = ErrorHandlingService()
    
    @Published var currentError: ErrorAlert?
    @Published var showingError = false
    
    private init() {}
    
    func handle(_ error: Error, context: String? = nil, retry: (() -> Void)? = nil) {
        print("Error in \(context ?? "Unknown"): \(error)")
        
        let errorAlert: ErrorAlert
        
        if let retry = retry {
            errorAlert = ErrorAlert(
                error: error,
                primaryAction: ErrorAlert.ErrorAction(
                    title: LocalizationManager.localized("error.retry"),
                    action: retry
                ),
                secondaryAction: ErrorAlert.ErrorAction(
                    title: LocalizationManager.localized("action.cancel"),
                    action: { }
                )
            )
        } else {
            errorAlert = ErrorAlert(
                error: error,
                primaryAction: ErrorAlert.ErrorAction(
                    title: LocalizationManager.localized("action.done"),
                    action: { }
                )
            )
        }
        
        DispatchQueue.main.async {
            self.currentError = errorAlert
            self.showingError = true
        }
    }
    
    func showSuccess(message: String) {
        let alert = ErrorAlert(
            title: LocalizationManager.localized("success.title"),
            message: message,
            primaryAction: ErrorAlert.ErrorAction(
                title: LocalizationManager.localized("action.done"),
                action: { }
            )
        )
        
        DispatchQueue.main.async {
            self.currentError = alert
            self.showingError = true
            HapticFeedback.success()
        }
    }
}


struct ErrorHandlingModifier: ViewModifier {
    @StateObject private var errorService = ErrorHandlingService.shared
    
    func body(content: Content) -> some View {
        content
            .alert(
                errorService.currentError?.title ?? "",
                isPresented: $errorService.showingError,
                presenting: errorService.currentError
            ) { error in
                if let primaryAction = error.primaryAction {
                    Button(primaryAction.title, action: primaryAction.action)
                }
                if let secondaryAction = error.secondaryAction {
                    Button(secondaryAction.title, role: .cancel, action: secondaryAction.action)
                }
            } message: { error in
                Text(error.message)
            }
    }
}

extension View {
    func withErrorHandling() -> some View {
        modifier(ErrorHandlingModifier())
    }
}