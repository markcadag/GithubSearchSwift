//
//  FeatureAssemblu.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Swinject

class FeatureAssembly: Assembly {
    func assemble(container: Container) {
        assembleListing(container)
    }
}

// MARK: - Delivery Listing

extension FeatureAssembly {
    func assembleListing(_ container: Container) {
        container.autoregister(RepositoryViewModel.self,
                               initializer: RepositoryViewModel.init)
        container.autoregister(RepositoryViewController.self,
                               initializer: RepositoryViewController.init)
    }
}
