//
//  SceneDelegate.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 18.04.2025.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene ) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        
        let TabBarController = UITabBarController()
        
        let router = Router()
        let productModel = ViewModel(router: router)
        let favorites = favoritesEnviroment()
        let rootView = GeneraltTabView(productModel: productModel).environmentObject(favorites)
        let controller = UIHostingController(rootView: rootView)
        let navCont = UINavigationController(rootViewController: controller)
        
        navCont.tabBarItem = UITabBarItem(title: "General", image:(UIImage(systemName: "house")), tag: 0)
        
        router.rootViewController = navCont
        
        
        
        // simulation of second tabbar
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .systemBlue
        let navVc1 = UINavigationController(rootViewController: vc1)
        navVc1.tabBarItem = UITabBarItem(title: "Brands", image:(UIImage(systemName: "square.grid.2x2")), tag: 1)
        
        // Favourities tabbar implementation
        let favRootView = FavouritesView().environmentObject(favorites)
        let favourites = UIHostingController(rootView: favRootView)
        let navFavourities = UINavigationController(rootViewController: favourites)
        navFavourities.tabBarItem = UITabBarItem(title: "Favourites", image:(UIImage(systemName: "star.square.on.square")), tag: 2)
        
        // simulation of fourth tabbar
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .yellow
        let navVc3 = UINavigationController(rootViewController: vc3)
        navVc3.tabBarItem = UITabBarItem(title: "Account", image:(UIImage(systemName: "person.circle")), tag: 3)
        
        TabBarController.viewControllers = [navCont, navVc1, navFavourities, navVc3]
        
        window?.rootViewController = TabBarController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

