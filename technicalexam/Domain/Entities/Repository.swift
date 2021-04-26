//
//  Repository.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Repository {
    var fullName: String?
    var repoDescription: String?
    var language: String?
    var owner: Owner?
    var htmlUrl: String?
}

extension Repository: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        fullName <- map["full_name"]
        repoDescription <- map["description"]
        language <- map["language"]
        owner <- map["owner"]
        htmlUrl <- map["html_url"]
    }
}
