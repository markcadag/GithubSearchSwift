//
//  BaseTableViewCell.swift
//  technicalexam
//
//  Created by iOS on 4/26/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    // MARK: - Data Properties
    var defaultSelectionStyle: UITableViewCell.SelectionStyle = .none
    
    // MARK: - Functions
    
    func setupViews() {
        
    }
    
    // MARK: - Overrides
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = defaultSelectionStyle
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
