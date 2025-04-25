//
//  GeneraltTabView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 18.04.2025.
//



import SwiftUI

struct GeneraltTabView: View {
    
    @ObservedObject var productModel: ViewModel
    @State var isShowProductDetail: Bool = false
    @State var selectedProduct: Product?
    @State private var searchText = ""
    @State private var selectedFilter: String = "All"

    
    var filteredProducts: [Product] {
        let lowercasedSearch = searchText.lowercased()
        return productModel.products.filter { product in
            (selectedFilter == "All" || product.brand == selectedFilter) &&
            (searchText.isEmpty || product.name.lowercased().contains(lowercasedSearch))
        }
    }

    
    init(productModel: ViewModel){
        self.productModel = productModel
    }
 
    var body: some View {
        ZStack{
            NavigationStack(){
                VStack{
                    HStack{
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.horizontal, .top])
                            
                        Picker("Filter", selection: $selectedFilter) {
                            Text("All").tag("All")
                            Text("Cetaphil").tag("Cetaphil")
                            Text("Perricone MD").tag("Perricone MD")
                            // Add more tags as needed
                        }
                    }
                    List(filteredProducts){ product in
                        ListCell(imageURL: product.image_url, name: product.name, price: product.price)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                selectedProduct = product
                                isShowProductDetail = true
                                
                            }
                        
                        Divider()

                        
                    }
                    .navigationTitle("General")
                    .disabled(isShowProductDetail)
                }
            }.onAppear{
                productModel.getDataProducts()
            }
            .blur(radius: isShowProductDetail ? 20 : 0)
            
            if isShowProductDetail{
                ProductPopUpView(isShowProductDetail: $isShowProductDetail, product: selectedProduct ?? productModel.products[0], router: productModel.router)
                    
            }
        }
    }
}

#Preview {
    GeneraltTabView(productModel: ViewModel(router: Router()))
}

struct ListCell: View {
    
    let imageURL: String
    let name: String
    let price: String
    
    var body: some View {
        HStack(){
            
            ImageLoader(imageURL: imageURL, width: 60, height: 60)

            VStack(alignment: .leading){
                Text("\(name)")
                    .font(.headline)
                Text("\(price)" )
                    .fontWeight(.light)
            }
            .padding(.leading)
        }
        .padding(.leading)
        .padding(.top)
    }
}
