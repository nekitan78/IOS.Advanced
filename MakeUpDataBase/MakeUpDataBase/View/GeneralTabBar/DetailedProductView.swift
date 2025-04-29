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
    DetailedProductView(product: MockData.arrayOfProducts[0] )
}
