//
//  Assembler.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import Foundation
import Swinject
import Moya

extension Assembler {
    static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([
            NetworkAssembly(),
            UseCaseAssembly(),
            FeatureAssembly()
        ], container: container)
        return assembler
    }()
}
