//
//  DeliveryTableViewCellViewModel.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

struct RepositoryCellViewModel {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    var title: String {
        self.repository.fullName ?? ""
    }
    
    var location: String {
        self.repository.repoDescription ?? ""
    }
    
    var price: String {
        self.repository.owner?.login ?? ""
    }
}
