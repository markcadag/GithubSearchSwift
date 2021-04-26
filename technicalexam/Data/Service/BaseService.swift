//
//  BaseService.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Moya

protocol BaseService: TargetType { }

extension BaseService {
    var headers: [String: String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
