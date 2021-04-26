//
//  IssueViewModel.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

struct IssueViewModel {
    
    private let issue: Issue

    init(issue: Issue) {
        self.issue = issue
    }

    var htmlUrl: String {
        self.issue.htmlUrl ?? ""
    }

    var title: String {
        self.issue.title ?? ""
    }
    
    var body: String {
        self.issue.body ?? ""
    }
    
    var committer: String {
        self.issue.owner?.login ?? ""
    }
}
