import Foundation

extension ViewModel {
    func filteredProducts(with filters: ProductFilters) -> [Product] {
        let filtered = products.filter { product in
            // Text search
            if !filters.searchText.isEmpty {
                let searchTerms = filters.searchText.lowercased().split(separator: " ")
                let name = product.name?.lowercased() ?? ""
                let brand = product.brand?.lowercased() ?? ""
                let desc = product.description?.lowercased() ?? ""
                guard searchTerms.allSatisfy({ name.contains($0) || brand.contains($0) || desc.contains($0) }) else {
                    return false
                }
            }

            // Brand filter
            if !filters.brands.isEmpty {
                guard let brand = product.brand, filters.brands.contains(brand) else {
                    return false
                }
            }

            // Price filter
            if let priceRange = filters.priceRange,
               let price = extractPrice(from: product.price ?? "") {
                guard priceRange.contains(price) else { return false }
            }

            // Rating filter - with no rating exclusion
            if let ratingRange = filters.ratingRange {
                // Explicitly check for rating, excluding products with no rating
                guard let ratingString = product.rating,
                      !ratingString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      let rating = extractRating(from: ratingString) else {
                    return false
                }

                // For the highest rating (5), include products with 5.0 or higher
                if filters.selectedBaseRating == 5 {
                    guard rating >= 5.0 else {
                        return false
                    }
                } else {
                    // For other ratings, use the original range check
                    guard ratingRange.contains(rating) ||
                          Int(rating) == filters.selectedBaseRating else {
                        return false
                    }
                }
            }

            // Sustainability
            if !filters.sustainabilityFilters.isEmpty {
                let tags = Set(product.sustainability)
                guard !filters.sustainabilityFilters.isDisjoint(with: tags) else {
                    return false
                }
            }

            return true
        }

        return filtered.count > 1 ? sortProducts(filtered, by: filters.sortOption) : filtered
    }

    private func sortProducts(_ products: [Product], by sort: ProductFilters.SortOption) -> [Product] {
        switch sort {
        case .nameAsc:
            return products.sorted { ($0.name ?? "") < ($1.name ?? "") }
        case .nameDesc:
            return products.sorted { ($0.name ?? "") > ($1.name ?? "") }
        case .priceAsc:
            return products.sorted {
                (extractPrice(from: $0.price ?? "") ?? 0) < (extractPrice(from: $1.price ?? "") ?? 0)
            }
        case .priceDesc:
            return products.sorted {
                (extractPrice(from: $0.price ?? "") ?? 0) > (extractPrice(from: $1.price ?? "") ?? 0)
            }
        case .ratingDesc:
            return products.sorted {
                (extractRating(from: $0.rating ?? "") ?? 0) > (extractRating(from: $1.rating ?? "") ?? 0)
            }
        }
    }

    private func extractPrice(from priceString: String) -> Double? {
        let cleaned = priceString.filter("0123456789.".contains)
        return Double(cleaned)
    }

    private func extractRating(from ratingString: String) -> Double? {
        let cleaned = ratingString.filter("0123456789.".contains)
        return Double(cleaned)
    }
}
