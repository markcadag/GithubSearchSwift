//
//  SearchInputVuew.swift
//  technicalexam
//
//  Created by iOS on 4/23/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

// MARK: - Properties/Overrides
class SearchInputView: UIView {
    
    internal lazy var searchTextField = UITextField().with {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.placeholder = "Search Repositories"
        $0.sendActions(for: .valueChanged)
        $0.addCornerRadius(12.0)
    }
    
    /// The search icon on header view
    private lazy var searchImage: UIView = {
        let uiView = UIView()
        let searchIcon = UIImageView(image: #imageLiteral(resourceName: "icSearchTabFilled"))
        uiView.backgroundColor = #colorLiteral(red: 0.92900002, green: 0.9330000281, blue: 0.9369999766, alpha: 1)
        uiView.addCornerRadius(12)
        uiView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(18)
        }
        return uiView
    }()
    
    private lazy var searchButton: BounceButton = {
        let pButton = BounceButton()
        pButton.addSubview(searchImage)
        searchImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return pButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SearchInputView is not NSCoding compliant")
    }
    
    private func setupViews() {
        self.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(40)
        }
        
        self.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.height.width.equalTo(40)
        }
    }
}
