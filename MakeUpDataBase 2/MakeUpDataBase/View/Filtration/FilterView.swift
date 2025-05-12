import SwiftUI

// Updated FilterView with enhanced rating filter
struct FilterView: View {
    @ObservedObject var filterViewModel: FilterViewModel
    @Binding var isShowingFilters: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Brands")) {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(filterViewModel.availableBrands, id: \.self) { brand in
                                BrandToggleView(brand: brand, isSelected: filterViewModel.filters.brands.contains(brand)) {
                                    if filterViewModel.filters.brands.contains(brand) {
                                        filterViewModel.filters.brands.remove(brand)
                                    } else {
                                        filterViewModel.filters.brands.insert(brand)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 200)
                }
                
                Section(header: Text("Price Range")) {
                    VStack {
                        Text("\(filterViewModel.currencySymbol)\(Int(filterViewModel.filters.priceRange?.lowerBound ?? 0)) - \(filterViewModel.currencySymbol)\(Int(filterViewModel.filters.priceRange?.upperBound ?? 1000))")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        RangeSlider(
                            value: Binding(
                                get: { filterViewModel.filters.priceRange ?? 0...1000 },
                                set: { filterViewModel.filters.priceRange = $0 }
                            ),
                            in: filterViewModel.priceRanges.min...filterViewModel.priceRanges.max
                        )
                    }
                }
                
                Section(header: Text("Minimum Rating"), footer: Text("Products with selected rating or higher will be shown")) {
                    HStack {
                        ForEach(1...5, id: \.self) { rating in
                            EnhancedRatingToggle(rating: rating, isSelected: isRatingSelected(rating)) {
                                handleRatingToggle(rating)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Sustainability")) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filterViewModel.availableSustainabilityTags, id: \.self) { tag in
                                TagToggleView(tag: tag, isSelected: filterViewModel.filters.sustainabilityFilters.contains(tag)) {
                                    if filterViewModel.filters.sustainabilityFilters.contains(tag) {
                                        filterViewModel.filters.sustainabilityFilters.remove(tag)
                                    } else {
                                        filterViewModel.filters.sustainabilityFilters.insert(tag)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
                
                Section(header: Text("Sort By")) {
                    Picker("Sort By", selection: $filterViewModel.filters.sortOption) {
                        ForEach(ProductFilters.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("Reset All Filters") {
                        filterViewModel.resetFilters()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Filter Products")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isShowingFilters = false
                },
                trailing: Button("Apply") {
                    isShowingFilters = false
                }
            )
        }
    }
    
    // Helper to check if a rating is selected
    private func isRatingSelected(_ rating: Int) -> Bool {
        return filterViewModel.filters.isRatingSelected(rating)
    }
   
    // Handle rating toggle with clear logic
    private func handleRatingToggle(_ rating: Int) {
        if isRatingSelected(rating) {
            // If the same rating is selected again, clear the filter
            filterViewModel.filters.setRatingFilter(nil)
        } else {
            // Set specific rating filter
            filterViewModel.filters.setRatingFilter(rating)
        }
    }
}

// Enhanced Rating Toggle with clearer visual indication
struct EnhancedRatingToggle: View {
    let rating: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(isSelected ? .yellow : .gray)
                    Text("\(rating)")
                        .font(.caption)
                        .fontWeight(isSelected ? .bold : .regular)
                }
                
                // Show range when selected
                if isSelected {
                    Text("\(rating).0-\(rating).9")
                        .font(.system(size: 8))
                        .foregroundColor(.blue)
                }
            }
            .padding(8)
            .background(isSelected ? Color.yellow.opacity(0.2) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension FilterViewModel {
    // Currency symbol property to use in the UI
    var currencySymbol: String {
        // You can change this to match your app's locale or preferred currency
        return "£"
    }
}
