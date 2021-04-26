//
//  IssueTableViewCell.swift
//  technicalexam
//
//  Created by iOS on 4/26/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class IssueTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    static var identifier: String = "IssueTableViewCell"
    
    var disposeBag = DisposeBag()
    
    internal lazy var imageViewItem = UIImageView().with {
        $0.image = #imageLiteral(resourceName: "icCommit")
        $0.contentMode = .scaleAspectFill
        $0.addCornerRadius(8.0)
        $0.clipsToBounds = true
    }
    
    private lazy var labelTitle = UILabel().with {
        $0.text = ""
        $0.font = UIFont(name: fontRobotoRegular, size: 14)
        $0.textColor = #colorLiteral(red: 0.5059999824, green: 0.5329999924, blue: 0.5490000248, alpha: 1)
        $0.numberOfLines = 2
    }
    
    private lazy var labelLocation = UILabel().with {
        $0.font = UIFont(name: fontRobotoRegular, size: 16)
        $0.numberOfLines = 0
        $0.textColor = .blue
    }
    
    private lazy var labelBody = UILabel().with {
        $0.font = UIFont(name: fontRobotoRegular, size: 15)
        $0.numberOfLines = 0
        $0.textColor = #colorLiteral(red: 0.5059999824, green: 0.5329999924, blue: 0.5490000248, alpha: 1)
    }
    
    private lazy var labelPrice = UILabel().with {
        $0.text = ""
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var imageViewPoints = UIImageView().with {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var container: UIView = UIView().with {
        $0.backgroundColor = UIColor.white
        $0.addCornerRadius(16.0)
    }
    
    // MARK: - Functions
    
    internal func setupCell(_ viewModel: IssueViewModel) {
        labelTitle.text = viewModel.htmlUrl
        labelLocation.text = viewModel.title
        labelBody.text = viewModel.body
        labelPrice.text = viewModel.committer
    }
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setupViews() {
        
        backgroundColor = #colorLiteral(red: 0.92900002, green: 0.9330000281, blue: 0.9369999766, alpha: 1)
        
        addSubview(container)
        container.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(defaultPadding)
            $0.top.bottom.equalToSuperview().inset(defaultPadding/2)
        }
        
        container.addSubview(imageViewItem)
        imageViewItem.snp.makeConstraints {
            $0.top.equalToSuperview().inset(defaultPadding)
            $0.leading.equalToSuperview().inset(defaultPadding)
            $0.height.width.equalTo(25.0)
        }
        
        container.addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.top.equalTo(imageViewItem)
            $0.leading.equalTo(imageViewItem.snp.trailing).offset(defaultPadding)
            $0.trailing.equalToSuperview().inset(defaultPadding)
        }
        
        container.addSubview(labelLocation)
        labelLocation.snp.makeConstraints {
            $0.top.equalTo(labelTitle.snp.bottom).offset(defaultPadding)
            $0.leading.equalTo(imageViewItem.snp.trailing).offset(defaultPadding)
            $0.trailing.equalToSuperview().inset(defaultPadding)
        }
        
        container.addSubview(labelBody)
        labelBody.snp.makeConstraints {
            $0.top.equalTo(labelLocation.snp.bottom).offset(defaultPadding)
            $0.leading.equalTo(imageViewItem.snp.trailing).offset(defaultPadding)
            $0.trailing.equalToSuperview().inset(defaultPadding)
        }
        
        container.addSubview(imageViewPoints)
        imageViewPoints.snp.makeConstraints {
            $0.leading.equalTo(imageViewItem.snp.trailing).offset(defaultPadding)
            $0.bottom.equalToSuperview().inset(defaultPadding)
            $0.height.width.equalTo(1)
        }
        
        container.addSubview(labelPrice)
        labelPrice.snp.makeConstraints {
            $0.top.equalTo(labelBody.snp.bottom).offset(defaultPadding)
            $0.bottom.equalToSuperview().inset(defaultPadding)
            $0.leading.equalTo(imageViewItem.snp.trailing).offset(defaultPadding)
            $0.trailing.equalToSuperview().inset(defaultPadding)
        }
    }
}
