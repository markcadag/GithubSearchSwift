//
//  Issues.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Issue {
    var title: String?
    var body: String?
    var owner: Owner?
    var htmlUrl: String?
}

extension Issue: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        title <- map["title"]
        body <- map["body"]
        owner <- map["user"]
        htmlUrl <- map["html_url"]
    }
}
