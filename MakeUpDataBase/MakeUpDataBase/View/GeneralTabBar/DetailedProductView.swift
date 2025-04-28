//
//  DetailedProductView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 23.04.2025.
//

import SwiftUI

struct DetailedProductView: View {
    let product: Product
    @State private var isLoading: Bool = false
    @State var alert: AlertItem?

    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    ImageLoader(imageURL: product.image_url, width: 300, height: 300, isLoading: $isLoading, alertItem: $alert)
                    
                    HStack{
                        Text("Brand")
                        Text("\(product.brand)")
                    }
                    HStack{
                        Text("Name")
                        Text("\(product.name)")
                    }
                    HStack{
                        Text("rating")
                        Text("\(product.rating ?? "")")
                            
                    }
                    HStack{
                        Text("Price")
                        Text("\(product.price)")
                    }
                    HStack{
                        Text("Description")
                        Text("\(product.description)")
                    }
                    HStack{
                        Text("HowToUse")
                        Text("\(product.how_to_use)")
                    }
                    HStack{
                        Text("Benefits")
                        Text("\(product.benefits)")
                    }
                    HStack{
                        Text("full ingredients list")
                        Text("\(product.full_ingredient_list ?? "")")
                    }
                    HStack{
                        Text("sustainability")
                        Text("\(product.sustainability)")
                    }
                    
                    
                }
            }
            
            if isLoading{
                LoadingView()
            }
            
        }
        
    }
}

#Preview {
    DetailedProductView(product: Product(id: 0, brand: "Perricone MD", name: "Perricone MD Vitamin C Ester Brightening Serum 30ml", image_url: "https://www.lookfantastic.com/images?url=https://static.thcdn.com/productimg/original/13033787-8244875642933507.jpg&format=webp&auto=avif&width=985&height=985&fit=cover", price: "9.99", rating: "4", description: "dfdf", how_to_use: "fdfd", benefits: "fdf", full_ingredient_list: "fdf", sustainability: []) )
}
