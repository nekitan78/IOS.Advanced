//
//  ProductPopUpView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//

import SwiftUI

struct ProductPopUpView: View {
    @Binding var isShowProductDetail: Bool
    let product: Product
    let router:Router
    @State var isFavorite = false
    @EnvironmentObject var favoritesProducts: favoritesEnviroment
    @State private var isLoading: Bool = false
    @State var alert: AlertItem?

    
    var body: some View {
        VStack{
            ImageLoader(imageURL: product.image_url, width: 300, height: 225, isLoading: $isLoading, alertItem: $alert)
            Divider()
        
            VStack{
                Text("\(product.name.replacingOccurrences(of: product.brand, with: "").trimmingCharacters(in: .whitespacesAndNewlines))")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                descriptionRow(name: "Brand", value: "\(product.brand)")
                descriptionRow(name: "Rating ", value: "\(extractFirstNumber(from: product.rating) ?? "no rating")")
                descriptionRow(name: "Price", value: "\(product.price)")
                
            }.padding()
            Spacer()
            Button(){
                router.gotoDetail(with: product)
            }label: {
                Text("Learn more")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 260, height: 40)
                    .foregroundStyle(Color(.white))
                    .background(.green)
                    .cornerRadius(12)
        
            }
            .padding(.bottom, 30)
            
        }
        .frame(width: 300, height: 525)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(Button(){
            isShowProductDetail = false
        }label: {
            ZStack{
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .opacity(0.6)
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .frame(width: 44,height: 44)
                    .foregroundStyle(.black)
            }
        }, alignment: .topTrailing)
        .overlay(Button(){
            if isFavorite{
                favoritesProducts.favorites.removeAll { $0.id == product.id }
                isFavorite = false
            }else{
                favoritesProducts.favorites.append(product)
                isFavorite = true
            }
        }label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(.yellow)
                .frame(width: 44, height: 44)
        }, alignment: .topLeading)
        .onAppear {
            isFavorite = favoritesProducts.favorites.contains(where: { $0.id == product.id })
        }
        
        
        if isLoading{
            LoadingView()
        }
        
    }
}

#Preview {
    ProductPopUpView(isShowProductDetail: .constant(true), product: Product(id: 0, brand: "Perricone MD", name: "Perricone MD Vitamin C Ester Brightening Serum 30ml", image_url: "https://www.lookfantastic.com/images?url=https://static.thcdn.com/productimg/original/13033787-8244875642933507.jpg&format=webp&auto=avif&width=985&height=985&fit=cover", price: "9.99", rating: "4", description: "dfdf", how_to_use: "fdfd", benefits: "fdf", full_ingredient_list: "fdf", sustainability: []), router: Router())
}

struct descriptionRow: View {
    let name: String
    let value: String
    var body: some View {
        HStack(){
            Text("\(name)")
                .padding(.leading, 30)
            
            Spacer()
            Text("\(value)")
                .padding(.trailing, 50)
        }
    }
}
func extractFirstNumber(from text: String?) -> String? {
    guard let text = text else { return nil }
    let pattern = #"[\d\.]+"#
    if let range = text.range(of: pattern, options: .regularExpression) {
        return String(text[range])
    }
    return nil
}
