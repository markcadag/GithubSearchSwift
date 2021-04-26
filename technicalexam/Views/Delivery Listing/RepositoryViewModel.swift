//
//  RepositoryViewModel.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import RxCocoa
import RxSwift
import RxOptional
import Moya
import RxDataSources

enum SearchType: Int {
     case repositories = 0, commits = 1, issues = 2
}

protocol RepositoryViewModelInputs {
    func viewDidLoad()
    func nextPage()
    func refresh()
    func didQuery(query: String)
    func didTapSearchType(type: SearchType)
}

protocol RepositoryViewModelOutputs {
    var error: Driver<String>! { get }
    var repositories: Driver<[RepositorySectionModel]>! { get }
    var isLoading: Driver<Bool>! { get }
    var messageResult: Driver<String>! { get }
}

protocol RepositoryViewModelType {
    var inputs: RepositoryViewModelInputs { get }
    var outputs: RepositoryViewModelOutputs { get }
}

final class RepositoryViewModel: RepositoryViewModelType, RepositoryViewModelInputs, RepositoryViewModelOutputs {

    var inputs: RepositoryViewModelInputs { return self }
    var outputs: RepositoryViewModelOutputs { return self }
    
    // MARK: - Inputs
  
    var viewDidLoadProperty = PublishSubject<Void?>()
    func viewDidLoad() {
        self.viewDidLoadProperty.onNext(())
    }
    
    var nextPageProperty = PublishSubject<Void>()
    func nextPage() {
        self.nextPageProperty.onNext(())
    }
    
    private var refreshProperty = PublishSubject<Void>()
    func refresh() {
        self.refreshProperty.onNext(())
    }
    
    private var didQueryProperty = BehaviorRelay<String?>(value: nil)
    func didQuery(query: String) {
        self.didQueryProperty.accept(query)
    }
    
    private var didTapSearchTypeProperty = BehaviorRelay<SearchType>(value: .repositories)
    func didTapSearchType(type: SearchType) {
        self.didTapSearchTypeProperty.accept(type)
    }
    
    // MARK: - Outputs
    
    internal var error: Driver<String>!
    internal var repositories: Driver<[RepositorySectionModel]>!
    internal var isLoading: Driver<Bool>!
    internal var messageResult: Driver<String>!
    
    // MARK: - Attributes
    
    private let disposeBag = DisposeBag()
    private let limit = 10
    private let offsetLimit = 50
    private let defaultSearchRepositoryUseCase: DefaultSearchRepositoryUseCase
    private let defaultSearchCommitUseCase: DefaultSearchCommitUseCase
    private let defaultSearchIssuesUseCase: DefaultSearchIssuesUseCase
    
    init(defaultSearchRepositoryUseCase: DefaultSearchRepositoryUseCase,
         defaultSearchCommitUseCase: DefaultSearchCommitUseCase,
         defaultSearchIssueUseCase: DefaultSearchIssuesUseCase) {
        
        self.defaultSearchRepositoryUseCase = defaultSearchRepositoryUseCase
        self.defaultSearchCommitUseCase = defaultSearchCommitUseCase
        self.defaultSearchIssuesUseCase = defaultSearchIssueUseCase
        
        let currentPage = BehaviorRelay<Int>(value: 1)
        
        let repositoryResponse = BehaviorRelay<[SectionItem]?>(value: nil)
        
        let didQueryObservable = didQueryProperty
            .compactMap { $0 }
        
        Observable.combineLatest(didQueryObservable, didTapSearchTypeProperty)
            .subscribe(onNext: { _ in
                currentPage.accept(1)
                repositoryResponse.accept([])
            }).disposed(by: disposeBag)
    
        let searchRequest = Observable
            .combineLatest(currentPage, didTapSearchTypeProperty, didQueryObservable) { page, searchType, query in
                return (page, searchType, query)
            }
            .flatMapLatest {[weak self] page, searchType, query -> Observable<LoadingResult<[SectionItem]>> in
                guard let self = self else { return Observable.empty() }
                switch searchType {
                case .repositories:
                    return self.repositoriesRequest(page, "\(searchType)", self.offsetLimit, query)
                case .commits:
                    return self.commitRequest(page, "\(searchType)", self.offsetLimit, query)
                case .issues:
                    return self.issuesRequest(page, "\(searchType)", self.offsetLimit, query)
                }
            }
            .share()
        
        self.repositories = repositoryResponse
            .filterNil()
            .map { [.repositorySection(title: "", items: $0)] }
            .asDriver(onErrorJustReturn: [])
        
        searchRequest.elements()
            .compactMap { (repositoryResponse.value ?? []) + $0 }
            .bind(to: repositoryResponse)
            .disposed(by: disposeBag)
    
        self.messageResult = searchRequest.elements()
            .map { if $0.isEmpty { return "No Result" } else { return "" } }
            .asDriver(onErrorJustReturn: "")
        
        self.viewDidLoadProperty
            .filterNil()
            .map { _ in 1 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
        self.refreshProperty
            .map { _ in 1 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
        self.error = searchRequest.errors()
            .map { $0.localizedDescription }
            .asDriver(onErrorJustReturn: "Unknown Error")
        
        self.isLoading = searchRequest.loading()
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
        
        self.nextPageProperty
            .withLatestFrom(searchRequest.loading())
            .filter { !$0 }
            .withLatestFrom(currentPage)
            .map { $0 + 1 }
            .bind(to: currentPage)
            .disposed(by: disposeBag)
    }
    
    private func repositoriesRequest(_ page: Int, _ searchType: String, _ offset: Int, _ query: String) -> Observable<LoadingResult<[SectionItem]>> {
        let requestValue = SearchRepositoryUseCaseReqValue(page: page,
                                                           offset: self.offsetLimit,
                                                           searchType: searchType,
                                                           query: query)
        return defaultSearchRepositoryUseCase.execute(requestValue: requestValue)
            .map { value in
                var items = [SectionItem]()
                value.forEach { items.append(.repositorySectionItem(repository: $0)) }
                return items
            }.monitorResult()
    }
    
    private func commitRequest(_ page: Int, _ searchType: String, _ offset: Int, _ query: String) -> Observable<LoadingResult<[SectionItem]>> {
        let requestValue = SearchRepositoryUseCaseReqValue(page: page,
                                               offset: self.offsetLimit,
                                                searchType: searchType,
                                                query: query)
        return defaultSearchCommitUseCase.execute(requestValue: requestValue)
            .map { value in
                var items = [SectionItem]()
                value.forEach { items.append(.commitSectionItem(commit: $0)) }
                return items
            }.monitorResult()
    }
    
    private func issuesRequest(_ page: Int, _ searchType: String, _ offset: Int, _ query: String) -> Observable<LoadingResult<[SectionItem]>> {
        let requestValue = SearchRepositoryUseCaseReqValue(page: page,
                                               offset: self.offsetLimit,
                                                searchType: searchType,
                                                query: query)
        return defaultSearchIssuesUseCase.execute(requestValue: requestValue)
            .map { value in
                var items = [SectionItem]()
                value.forEach { items.append(.issueSectionItem(issue: $0)) }
                return items
            }.monitorResult()
    }
}
