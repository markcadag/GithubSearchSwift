//
//  SceneDelegate.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit
import SwiftUI
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let sceneCoordinator = SceneCoordinator(window: self.window!)
            sceneCoordinator.start()
        }
    }
}
