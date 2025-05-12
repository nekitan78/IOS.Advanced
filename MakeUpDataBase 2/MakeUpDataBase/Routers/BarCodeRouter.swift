//
//  BarCodeRouter.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 06.05.2025.
//

import Foundation
import SwiftUI

final class BarcodeRouter: ProductRouting{
    var rootViewController: UINavigationController?
    
    func goToDetail(with product: Product){
        let detailVC = UIHostingController(rootView: DetailedProductView(product: product))
        rootViewController?.show(detailVC, sender: nil)
    }
}
