//
//  GeneralTabViewModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//

import Foundation

final class ViewModel: ObservableObject{
    
    @Published var products: [Product] = []
    
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func getDataProducts(){
        guard let url = Bundle.main.url(forResource: "lookfantastic_products", withExtension: "json")else {
             print(ErrorType.invalidURL)
            return
        }
        
        do{
            let data = try Data(contentsOf: url)
            let productsData = try JSONDecoder().decode([Product].self, from: data)
            products = productsData
        }catch{
            print(ErrorType.decodingFailed)
        }
        
        
    }
    
    
}

enum ErrorType: Error {
    case invalidURL
    case decodingFailed
}
