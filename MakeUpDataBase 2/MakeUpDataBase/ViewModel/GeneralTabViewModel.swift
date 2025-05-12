import Foundation

final class ViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var alertMessage: AlertItem?
    
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func getDataProducts() {
        // Use background thread for file I/O operations
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let url = Bundle.main.url(forResource: "lookfantastic_products", withExtension: "json") else {
                DispatchQueue.main.async {
                    self.alertMessage = ErrorContext.invalidURL
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let productsData = try JSONDecoder().decode([Product].self, from: data)
                
                // Update UI on main thread
                DispatchQueue.main.async {
                    self.products = productsData
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = ErrorContext.decodingFailed
                }
            }
        }
    }
}
