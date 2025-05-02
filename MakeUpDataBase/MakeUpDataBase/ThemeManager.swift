import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

/// Theme manager to control app appearance with smooth transitions
final class ThemeManager: ObservableObject {
    // Singleton instance
    static let shared = ThemeManager()
    
    // Published property to track dark mode preference
    @Published var isDarkMode: Bool = false {
        didSet {
            // Only apply theme when the value actually changes
            if oldValue != isDarkMode {
                // Apply theme immediately with animation
                applyTheme(animated: true)
                // Only save if we're not currently loading
                if !isLoading {
                    saveThemeToFirestore()
                }
            }
        }
    }
    
    // Animation duration for theme transitions
    let transitionDuration: Double = 0.6
    
    // Flag to prevent saving while loading
    private var isLoading = false
    
    private var db = Firestore.firestore()
    
    // Initialize with system default
    private init() {
        // Apply default theme at launch (no animation on initial load)
        applyTheme(animated: false)
    }
    
    // Apply theme to entire app using UIKit's appearance API
    private func applyTheme(animated: Bool) {
        // Set the user interface style for the entire app
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        
        // Apply the theme change with animation
        if animated {
            UIView.transition(with: window,
                              duration: transitionDuration,
                              options: [.transitionCrossDissolve, .allowUserInteraction],
                              animations: {
                                  window.overrideUserInterfaceStyle = self.isDarkMode ? .dark : .light
                              },
                              completion: nil)
        } else {
            // Apply immediately without animation
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
        
        // Update status bar appearance for smoother transition
        UIApplication.shared.windows.forEach { window in
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // Save theme preference to Firestore
    func saveThemeToFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("💾 Saving theme preference to Firestore")
        db.collection("users").document(uid).setData(
            ["isDarkMode": isDarkMode],
            merge: true
        ) { error in
            if let error = error {
                print("❌ Error saving theme preference: \(error.localizedDescription)")
            } else {
                print("✅ Theme preference saved successfully")
            }
        }
    }
    
    // Load theme preference from Firestore
    func loadThemeFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error loading theme: \(error)")
                return
            }

            guard let document = document, document.exists,
                  let data = document.data(),
                  let isDark = data["isDarkModeEnabled"] as? Bool else {
                print("No theme data found. Using default (light).")
                DispatchQueue.main.async {
                    self?.isDarkMode = false
                }
                return
            }

            DispatchQueue.main.async {
                self?.isDarkMode = isDark
            }
        }
    }

    
    // Method to toggle theme with animation
    func toggleTheme() {
        withAnimation(.easeInOut(duration: transitionDuration)) {
            isDarkMode.toggle()
        }
    }
    
    // Method to refresh theme after login
    func refreshTheme() async {
        loadThemeFromFirestore()
        
    }
}

// SwiftUI Environment Key for theme
struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: ThemeManager = .shared
}

// Environment Values extension
extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// Animation modifier for SwiftUI views that respond to theme changes
extension View {
    func themeTransition() -> some View {
        self.animation(.easeInOut(duration: ThemeManager.shared.transitionDuration),
                       value: ThemeManager.shared.isDarkMode)
    }
}
