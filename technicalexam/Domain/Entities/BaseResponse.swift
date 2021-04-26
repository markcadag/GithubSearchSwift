//
//  BaseResponse.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse<T>: NSObject, Mappable where T: Mappable {
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [T]?

    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }

    func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}
