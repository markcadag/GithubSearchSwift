//
//  UseCaseAssembly.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(DefaultSearchRepositoryUseCase.self,
                               initializer: DefaultSearchRepositoryUseCase.init)
        container.autoregister(DefaultSearchCommitUseCase.self,
                                initializer: DefaultSearchCommitUseCase.init)
        container.autoregister(DefaultSearchIssuesUseCase.self,
                                initializer: DefaultSearchIssuesUseCase.init)
    }
}
