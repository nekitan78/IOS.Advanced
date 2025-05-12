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
    
    @MainActor
    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let rootVC = base ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let nav = rootVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = rootVC as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = rootVC?.presentedViewController {
            return topViewController(base: presented)
        }
        return rootVC
    }


}
extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }
}
