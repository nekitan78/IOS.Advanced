//
//  Router.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 22.04.2025.
//

import Foundation
import SwiftUI
import UIKit

final class Router: ProductRouting{
    
    var rootViewController: UINavigationController?
    
    func goToDetail(with product: Product) {
        let detailVC = UIHostingController(rootView: DetailedProductView(product: product))
        rootViewController?.show(detailVC, sender: nil)
    }
    
    
    
}
