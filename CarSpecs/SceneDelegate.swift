//
//  SceneDelegate.swift
//  CarSpecs
//
//  Created by Felipe Lima on 18/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let initalViewController = TabBarController()
        let navigationController = UINavigationController(rootViewController: initalViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
