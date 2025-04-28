//
//  Utilities.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import Foundation
import SwiftUI

final class Utilities{
    static var shared = Utilities()
    private init () {}
    
    
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }


}
