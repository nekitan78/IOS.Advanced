import Foundation

struct ProductFilters {
    var searchText: String = ""
    var brands: Set<String> = []
    var priceRange: ClosedRange<Double>? = nil
    var selectedBaseRating: Int? = nil
    var sustainabilityFilters: Set<String> = []
    var sortOption: SortOption = .nameAsc

    enum SortOption: String, CaseIterable {
        case nameAsc = "Name (A-Z)"
        case nameDesc = "Name (Z-A)"
        case priceAsc = "Price (Low to High)"
        case priceDesc = "Price (High to Low)"
        case ratingDesc = "Highest Rated"
    }

    // Compute rating range based on selected base rating
    var ratingRange: ClosedRange<Double>? {
        guard let selectedBaseRating = selectedBaseRating else { return nil }
        
        // Special handling for the highest rating (5)
        if selectedBaseRating == 5 {
            return 5.0...5.0
        }
        
        let lower = Double(selectedBaseRating)
        let upper = min(lower + 0.9, Double(selectedBaseRating + 1) - 0.1)
        return lower...upper
    }
}

extension ProductFilters {
    // Set rating filter
    mutating func setRatingFilter(_ rating: Int?) {
        selectedBaseRating = rating
    }

    // Check if a specific rating is selected
    func isRatingSelected(_ rating: Int) -> Bool {
        return selectedBaseRating == rating
    }
}
