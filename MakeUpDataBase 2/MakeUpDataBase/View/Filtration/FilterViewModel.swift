import SwiftUI
import Combine

class FilterViewModel: ObservableObject {
    @Published var filters = ProductFilters()
    @Published var availableBrands: [String] = []
    @Published var priceRanges: (min: Double, max: Double) = (0, 1000)
    @Published var availableSustainabilityTags: [String] = []
    
    // Track whether filter options have been initialized
    private var hasInitializedFilters = false
    
    // Initialize filter options from products
    func initializeFilterOptions(from products: [Product]) {
        // Prevent duplicate initialization
        guard !hasInitializedFilters else { return }
        
        // Move this computation to a background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Extract unique brands (non-nil only)
            let brands = products.compactMap { $0.brand }
            let uniqueBrands = Array(Set(brands)).sorted()
            
            // Find price range from valid prices
            let prices = products.compactMap {
                if let priceStr = $0.price {
                    return Double(priceStr.replacingOccurrences(of: "£", with: "").trimmingCharacters(in: .whitespacesAndNewlines))
                }
                return nil
            }
            
            var minPrice = 0.0
            var maxPrice = 1000.0
            
            if let minFound = prices.min(), let maxFound = prices.max() {
                // Round to nearest dollar
                minPrice = floor(minFound)
                maxPrice = ceil(maxFound)
            }
            
            // Extract sustainability tags
            let allTags = products.flatMap { $0.sustainability }
            let uniqueTags = Array(Set(allTags)).sorted()
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.availableBrands = uniqueBrands
                self.priceRanges = (minPrice, maxPrice)
                self.availableSustainabilityTags = uniqueTags
                
                // Set initial price range
                self.filters.priceRange = minPrice...maxPrice
                
                // Mark as initialized
                self.hasInitializedFilters = true
            }
        }
    }
    
    // Reset all filters
    func resetFilters() {
        // Create a new filter instance with only price range preserved
        filters = ProductFilters(
            priceRange: priceRanges.min...priceRanges.max
        )
        
        // Make sure rating range is nil
        filters.selectedBaseRating = nil
    }
}
