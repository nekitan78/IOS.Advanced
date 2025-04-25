//
//  Router.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 22.04.2025.
//

import Foundation
import SwiftUI
import UIKit

final class Router {
    var rootViewController: UINavigationController?
    
    func gotoDetail(with product: Product) {
        
        let detailVC = UIHostingController(rootView: DetailedProductView(product: product))
        rootViewController?.show(detailVC, sender: nil)
    }
    
    func goToElsewhere() {
        let someVC = UIViewController()
        someVC.view.backgroundColor = .blue
        rootViewController?.show(someVC, sender: nil)
    }
    
    
    
}
