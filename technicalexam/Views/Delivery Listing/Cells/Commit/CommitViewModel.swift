//
//  CommitViewModel.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

struct CommitViewModel {
    
    private let commit: Commit
    
    init(commit: Commit) {
        self.commit = commit
    }
    
    var repoName: String {
        self.commit.repository?.fullName ?? ""
    }
    
    var committer: String {
        self.commit.commitDetail?.committer?.name ?? ""
    }
    
    var date: String {
        self.commit.commitDetail?.committer?.date ?? ""
    }
    
    var message: String {
        self.commit.commitDetail?.message ?? ""
    }
}
