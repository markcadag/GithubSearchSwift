//
//  NetworkAssembly.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Swinject
import Moya

class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkLoggerPlugin.self) { _ in
            NetworkLoggerPlugin.init()
        }
        
        container.register(MoyaProvider<GithubSearchService>.self) { resolver in
            MoyaProvider<GithubSearchService>(plugins: [resolver.resolve(NetworkLoggerPlugin.self)!])
        }
    }
}
