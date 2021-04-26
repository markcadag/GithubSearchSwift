//
//  Owner.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import Foundation
import ObjectMapper

struct Owner {
    var login: String?
    var email: String?
    var avatarURL: String?
}

extension Owner: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        login <- map["login"]
        email <- map["email"]
        avatarURL <- map["avatar_url"]
    }
}
