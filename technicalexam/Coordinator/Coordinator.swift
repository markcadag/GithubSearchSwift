//
//  Coordinator.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import Foundation
import RxSwift

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    var disposeBag = DisposeBag()
    var childCoordinators: [Coordinator] = []
   
    func start() {
        fatalError("Children should implement `start`.")
    }
}

extension Coordinator {
    func storeChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func freeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
