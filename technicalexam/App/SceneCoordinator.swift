//
//  SceneCoordinator.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class SceneCoordinator: BaseCoordinator {
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        let deliveryListingViewController = Assembler.shared
            .resolver
            .resolve(RepositoryViewController.self)!
        
        let navigationController = UINavigationController(rootViewController: deliveryListingViewController)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
