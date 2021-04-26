//
//  Commiter.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Committer {
    var name: String?
    var date: String?
}

extension Committer: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        date <- map["date"]
    }
}
