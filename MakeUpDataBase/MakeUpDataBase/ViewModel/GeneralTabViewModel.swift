//
//  GeneralTabViewModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//

import Foundation

final class ViewModel: ObservableObject{
    
    @Published var products: [Product] = []
    @Published var alertMessage: AlertItem?
    
    
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func getDataProducts(){
        guard let url = Bundle.main.url(forResource: "lookfantastic_products", withExtension: "json")else {
            alertMessage = ErrorContext.invalidURL
            return
        }
        
        do{
            let data = try Data(contentsOf: url)
            let productsData = try JSONDecoder().decode([Product].self, from: data)
            products = productsData
        }catch{
            alertMessage = ErrorContext.decodingFailed
        }
        
        
    }
    
    
}

enum ErrorType: Error {
    case invalidURL
    case decodingFailed
}
