//
//  FavoriteRouter.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 26.04.2025.
//

import Foundation
import SwiftUI
import UIKit

final class FavoriteRouter {
    var rootViewController: UINavigationController?
    
    func gotoDetail(with product: Product) {
        
        let detailVC = UIHostingController(rootView: DetailedProductView(product: product))
        rootViewController?.show(detailVC, sender: nil)
    }
    
   
    
    
}
