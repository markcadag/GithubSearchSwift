//
//  String+Ext.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
