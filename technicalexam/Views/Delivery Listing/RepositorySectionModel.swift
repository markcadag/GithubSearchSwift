//
//  RepositorySectionModel.swift
//  technicalexam
//
//  Created by iOS on 4/26/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import RxDataSources

enum RepositorySectionModel {
    case repositorySection(title: String, items: [SectionItem])
    case commitSection(title: String, items: [SectionItem])
    case issueSection(title: String, items: [SectionItem])
}

enum SectionItem {
    case repositorySectionItem(repository: Repository)
    case commitSectionItem(commit: Commit)
    case issueSectionItem(issue: Issue)
}

extension RepositorySectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .repositorySection(title: _, items: let items):
            return items.map { $0 }
        case .commitSection(title: _, items: let items):
            return items.map { $0 }
        case .issueSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: RepositorySectionModel, items: [Item]) {
        switch original {
        case let .repositorySection(title, _):
            self = .repositorySection(title: title, items: items)
        case let .commitSection(title, _):
            self = .commitSection(title: title, items: items)
        case let .issueSection(title, _):
            self = .issueSection(title: title, items: items)
        }
    }
}

extension RepositorySectionModel {
    var title: String {
        switch self {
        case .repositorySection(title: let title, items: _):
            return title
        case .commitSection(title: let title, items: _):
            return title
        case .issueSection(title: let title, items: _):
            return title
        }
    }
}
