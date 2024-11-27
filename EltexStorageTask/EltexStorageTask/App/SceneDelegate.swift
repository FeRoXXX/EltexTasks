//
//  SceneDelegate.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ImageListViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

