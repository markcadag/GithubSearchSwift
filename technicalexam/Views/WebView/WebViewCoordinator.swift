//
//  WebViewCoordinator.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import Foundation
import UIKit
import Swinject
import SafariServices

class WebViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private var url: String
    
    init(navigationController: UINavigationController, url: String) {
        self.navigationController = navigationController
        self.url = url
        super.init()
    }
    
    override func start() {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            self.navigationController.present(vc, animated: true)
        }
    }
}
