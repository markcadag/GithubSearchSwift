//
//  Commit.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Commit {
    var repository: Repository?
    var commitDetail: CommitDetail?
    var htmlUrl: String?
}

extension Commit: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        repository <- map["repository"]
        commitDetail <- map["commit"]
        htmlUrl <- map["html_url"]
    }
}
