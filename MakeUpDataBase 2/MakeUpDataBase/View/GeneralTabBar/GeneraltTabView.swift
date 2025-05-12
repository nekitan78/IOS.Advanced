import SwiftUI
import GoogleSignIn

struct GeneraltTabView: View {
    
    @ObservedObject var productModel: ViewModel
    @StateObject private var filterViewModel = FilterViewModel()
    
    @State var isShowProductDetail: Bool = false
    @State var isShowingFilters: Bool = false
    @State var selectedProduct: Product?
    @State private var searchText = ""
    @State var isShowSignIn: Bool = false

    var filteredProducts: [Product] {
        // Apply all filters (searchText is already synced in onChange)
        return productModel.filteredProducts(with: filterViewModel.filters)
    }

    init(productModel: ViewModel){
        self.productModel = productModel
    }

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal, .top])
                            .autocorrectionDisabled()
                            .onChange(of: searchText) { oldValue, newValue in
                                // Sync search text to filters when it changes
                                filterViewModel.filters.searchText = newValue
                            }

                        Button(action: {
                            isShowingFilters = true
                        }) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                        .padding(.top)
                    }
                    
                    // Active filters display with enhanced rating display
                    if !filterViewModel.filters.brands.isEmpty ||
                       filterViewModel.filters.selectedBaseRating != nil ||
                       !filterViewModel.filters.sustainabilityFilters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(filterViewModel.filters.brands), id: \.self) { brand in
                                    FilterChip(text: brand) {
                                        filterViewModel.filters.brands.remove(brand)
                                    }
                                }
                                
                                // Display rating with more context
                                if let selectedRating = filterViewModel.filters.selectedBaseRating {
                                    FilterChip(text: "\(selectedRating)★ (\(selectedRating).0-\(selectedRating).9)") {
                                        filterViewModel.filters.setRatingFilter(nil)
                                    }
                                }
                                
                                ForEach(Array(filterViewModel.filters.sustainabilityFilters), id: \.self) { tag in
                                    FilterChip(text: tag) {
                                        filterViewModel.filters.sustainabilityFilters.remove(tag)
                                    }
                                }
                                
                                if !filterViewModel.filters.brands.isEmpty ||
                                   filterViewModel.filters.selectedBaseRating != nil ||
                                   !filterViewModel.filters.sustainabilityFilters.isEmpty {
                                    Button("Clear All") {
                                        filterViewModel.filters.brands.removeAll()
                                        filterViewModel.filters.setRatingFilter(nil)
                                        filterViewModel.filters.sustainabilityFilters.removeAll()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 4)
                    }
                    
                    // Product count
                    Text("\(filteredProducts.count) products")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 4)

                    List(filteredProducts) { product in
                        ListCell(
                            imageURL: product.image_url ?? "",
                            name: product.name ?? "Unnamed Product",
                            price: product.price ?? "N/A",
                            alertItem: $productModel.alertMessage
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            hideKeyboard()
                            selectedProduct = product
                            isShowProductDetail = true
                        }

                        Divider()
                    }
                    .navigationTitle("General")
                    .listStyle(.plain)
                    .disabled(isShowProductDetail)
                    .overlay {
                        if filteredProducts.isEmpty {
                            ContentUnavailableView(
                                label: {
                                    Label("No Products Found", systemImage: "magnifyingglass")
                                },
                                description: {
                                    Text("Try adjusting your filters")
                                }
                            )
                        }
                    }
                }
            }
            .task {
                // Initialize search text in filters when the view appears
                filterViewModel.filters.searchText = searchText
                
                // Load data - this will trigger the onReceive below
                productModel.getDataProducts()
            }
            .onReceive(productModel.$products) { products in
                // Only initialize filters when products array has items
                if !products.isEmpty {
                    // Initialize filter options from the loaded products
                    filterViewModel.initializeFilterOptions(from: products)
                }
            }
            .alert(item: $productModel.alertMessage) { alert in
                Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
            }
            .blur(radius: isShowProductDetail ? 20 : 0)
            .sheet(isPresented: $isShowingFilters) {
                FilterView(filterViewModel: filterViewModel, isShowingFilters: $isShowingFilters)
            }

            if isShowProductDetail {
                ProductPopUpView(
                    isShowProductDetail: $isShowProductDetail,
                    product: selectedProduct ?? productModel.products.first ?? Product(id: -1, brand: nil, name: nil, image_url: nil, url: nil, price: nil, rating: nil, description: nil, how_to_use: nil, benefits: nil, full_ingredient_list: nil, sustainability: []),
                    router: productModel.router
                )
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
