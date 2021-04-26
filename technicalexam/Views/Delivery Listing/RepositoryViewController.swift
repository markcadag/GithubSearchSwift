//
//  RepositoryViewController.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

// MARK: - Lifecycle

class RepositoryViewController: UIViewController {
    
    private let repositoryViewModel: RepositoryViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<RepositorySectionModel> = {
        let dataSource = RxTableViewSectionedReloadDataSource<RepositorySectionModel>(configureCell: {  dataSource, tableView, indexPath, _  in
            switch dataSource[indexPath] {
            case let .repositorySectionItem(repository):
                let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryTableViewCell.identifier, for: indexPath) as? DeliveryTableViewCell
                cell?.setupCell(RepositoryCellViewModel(repository: repository))
                return cell!
            case let .commitSectionItem(commit):
                let cell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.identifier, for: indexPath) as? CommitTableViewCell
                cell?.setupCell(CommitViewModel(commit: commit))
                return cell!
            case let .issueSectionItem(issue):
                let cell = tableView.dequeueReusableCell(withIdentifier: IssueTableViewCell.identifier, for: indexPath) as? IssueTableViewCell
                cell?.setupCell(IssueViewModel(issue: issue))
                return cell!
            }
        })
        return dataSource
    }()
    
    internal lazy var tableViewDeliveries: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: DeliveryTableViewCell.identifier)
        tableView.register(CommitTableViewCell.self, forCellReuseIdentifier: CommitTableViewCell.identifier)
        tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.tableFooterView = loadingStateView
        return tableView
    }()
    
    private lazy var labelEmptyResult = UILabel().with {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var progressView = UIActivityIndicatorView().with {
        $0.center = view.center
        $0.startAnimating()
        $0.isHidden = true
    }
    
    let items = ["Repositories", "Commits", "Issues"]
      
    private lazy var segmentControl = UISegmentedControl(items: items).with {
        $0.selectedSegmentIndex = 0
    }
    
    private lazy var loadingStateView = UIActivityIndicatorView().with {
        $0.frame = CGRect.init(x: 0, y: 20, width: screenWidth, height: 25)
    }
    
    private let viewNavbar = ViewNavbar().with {
        $0.backButton.isHidden = true
        $0.labeTitle.text = "GitHub Search"
    }
    
    internal lazy var productSearchHeaderView = SearchInputView().with {
        $0.backgroundColor = UIColor.white
    }
    
    init(repositoryViewModel: RepositoryViewModel) {
        self.repositoryViewModel = repositoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpBindings()
    }
}

// MARK: Setup bindings

extension RepositoryViewController {
    
    private func setUpBindings() {
        
        repositoryViewModel.inputs.viewDidLoad()
  
        repositoryViewModel.outputs.repositories
            .asDriver(onErrorJustReturn: [])
            .asObservable()
            .bind(to: tableViewDeliveries.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        repositoryViewModel.outputs.messageResult
            .drive(labelEmptyResult.rx.text)
            .disposed(by: disposeBag)
        
        repositoryViewModel.outputs.error
            .drive(labelEmptyResult.rx.text)
            .disposed(by: disposeBag)
        
        repositoryViewModel.outputs.isLoading
            .drive(progressView.rx.isHidden)
            .disposed(by: disposeBag)
            
        tableViewDeliveries.rx.reachedBottom(offset: 40)
            .asObservable()
            .subscribe(onNext: {[weak self] _ in
                self?.repositoryViewModel.nextPage()
            }).disposed(by: disposeBag)
        
        tableViewDeliveries.rx.modelSelected(SectionItem.self)
            .subscribe(onNext: {[weak self] sectionItem in
                self?.presentWebView(sectionItem: sectionItem)
            }).disposed(by: disposeBag)
        
        segmentControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let searchType = SearchType(rawValue: index) else { return }
                self?.repositoryViewModel.inputs.didTapSearchType(type: searchType)
            }).disposed(by: disposeBag)
        
        productSearchHeaderView.searchTextField.rx
            .controlEvent(.editingChanged)
            .withLatestFrom(productSearchHeaderView.searchTextField.rx.text.orEmpty)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] value in
                self?.repositoryViewModel.inputs.didQuery(query: value)
            }).disposed(by: disposeBag)
    }
    
    private func presentWebView(sectionItem: SectionItem) {
        var url = ""
        switch sectionItem {
        case let .commitSectionItem(commit):
            url = commit.htmlUrl ?? ""
        case let .issueSectionItem(issue):
            url = issue.htmlUrl ?? ""
        case let .repositorySectionItem(repository):
            url = repository.htmlUrl ?? ""
        }
        guard let navigationController = navigationController else { return }
        let deliveryCoordinator = WebViewCoordinator(
            navigationController: navigationController,
            url: url
        )
        deliveryCoordinator.start()
    }
}

// MARK: - Setup views

extension RepositoryViewController {
    private func setUpViews() {
        view.backgroundColor = #colorLiteral(red: 0.92900002, green: 0.9330000281, blue: 0.9369999766, alpha: 1)
        
        view.addSubview(viewNavbar)
        viewNavbar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        view.addSubview(productSearchHeaderView)
        productSearchHeaderView.snp.makeConstraints {
            $0.top.equalTo(viewNavbar.snp.bottom).inset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(productSearchHeaderView.snp.bottom).offset(defaultPadding)
            $0.leading.trailing.equalToSuperview().inset(defaultPadding)
        }
        
        view.addSubview(tableViewDeliveries)
        tableViewDeliveries.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(defaultPadding * 2)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(labelEmptyResult)
        labelEmptyResult.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(defaultPadding)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
