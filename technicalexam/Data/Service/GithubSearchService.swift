//
//  GithubSearchService.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Moya

enum GithubSearchService {
    case search(page: Int, offset: Int, searchType: String, query: String)
}

extension GithubSearchService: BaseService {
    var baseURL: URL {
        return URL(string: baseEndpoint)!
    }
    
    var path: String {
        switch self {
        case .search( _, _, let searchType, _): return "/search/\(searchType)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:  return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.github.cloak-preview+json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .search(page, offset, _, query):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "per_page": offset,
                    "q": query.urlEscapedString
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}
