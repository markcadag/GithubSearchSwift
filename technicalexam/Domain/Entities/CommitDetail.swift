//
//  CommitDetails.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommitDetail {
    var message: String?
    var committer: Committer?
}

extension CommitDetail: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        committer <- map["committer"]
    }
}
