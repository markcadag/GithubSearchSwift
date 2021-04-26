//
//  SearchRepositorySpec.swift
//  technicalexamTests
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject
import Moya
import RxBlocking
import RxTest
import RxSwift
import RxNimble

@testable import technicalexam

class SearchRepositorySpec: QuickSpec {
    
    override func spec() {

        describe("Search Page") {
            var serviceProvider: MoyaProvider<GithubSearchService>!
            var searchRepositoryUseCase: DefaultSearchRepositoryUseCase!
            var searchIssuesUseCase: DefaultSearchIssuesUseCase!
            var searchCommitUseCase: DefaultSearchCommitUseCase!
            var viewModel: RepositoryViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            context("on successful response") {
                beforeEach {
                    scheduler = TestScheduler(initialClock: 0)
                    disposeBag = DisposeBag()
                    
                    serviceProvider = MoyaProvider<GithubSearchService>(
                        endpointClosure: self.successRepo(_:),
                        stubClosure: MoyaProvider.immediatelyStub)
                    
                    searchRepositoryUseCase = DefaultSearchRepositoryUseCase(
                        searchService: serviceProvider)
                    
                    searchIssuesUseCase = DefaultSearchIssuesUseCase(
                        searchService: serviceProvider)
                    
                    searchCommitUseCase = DefaultSearchCommitUseCase(
                        searchService: serviceProvider)
                    
                    viewModel = RepositoryViewModel(defaultSearchRepositoryUseCase: searchRepositoryUseCase,
                                                    defaultSearchCommitUseCase: searchCommitUseCase,
                                                    defaultSearchIssueUseCase: searchIssuesUseCase)
                }
                
                it("can search repo") {
                    let result = scheduler.createObserver(Int.self)

                    viewModel.outputs.repositories
                        .compactMap { ($0.first?.items.count) }
                        .drive(result)
                        .disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([Recorded.next(2, ())])
                        .subscribe(onNext: { _ in
                            viewModel.didQuery(query: "")
                        }).disposed(by: disposeBag)

                    scheduler.start()
                    
                    expect(result.events)
                        .to(equal([Recorded.next(2, 0),
                                   Recorded.next(2, 5)]))
                }
                
                it("can paginate") {
                    let result = scheduler.createObserver(Int.self)

                    viewModel.outputs.repositories
                        .compactMap { ($0.first?.items.count) }
                        .drive(result)
                        .disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([Recorded.next(2, ())])
                        .subscribe(onNext: { _ in
                            viewModel.didQuery(query: "")
                        }).disposed(by: disposeBag)

                    scheduler.createColdObservable([Recorded.next(3, ())])
                        .subscribe(onNext: { _ in
                            viewModel.nextPage()
                        }).disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(result.events)
                        .to(equal([Recorded.next(2, 0),
                                   Recorded.next(2, 5),
                                   Recorded.next(3, 10)]))
                }
                
                it("shows no results") {
                    
                    serviceProvider = MoyaProvider<GithubSearchService>(
                        endpointClosure: self.emptyResultResponse(_:),
                        stubClosure: MoyaProvider.immediatelyStub)
                    
                    searchRepositoryUseCase = DefaultSearchRepositoryUseCase(
                        searchService: serviceProvider)
                    
                    viewModel = RepositoryViewModel(defaultSearchRepositoryUseCase: searchRepositoryUseCase,
                                                    defaultSearchCommitUseCase: searchCommitUseCase,
                                                    defaultSearchIssueUseCase: searchIssuesUseCase)
                    
                    let result = scheduler.createObserver(String.self)

                    viewModel.outputs.messageResult
                        .drive(result)
                        .disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([Recorded.next(2, ())])
                        .subscribe(onNext: { _ in
                            viewModel.didQuery(query: "")
                        }).disposed(by: disposeBag)

                    scheduler.start()
                    
                    expect(result.events)
                        .to(equal([Recorded.next(2, "No Result")]))
                }
            }
        }
    }
    
    func successRepo(_ target: GithubSearchService) -> Endpoint {
        return createEndpoint(target, fileName: "repository_json_success")
    }
    
    func successIssues(_ target: GithubSearchService) -> Endpoint {
        return createEndpoint(target, fileName: "issues_json_success")
    }
    
    func successCommits(_ target: GithubSearchService) -> Endpoint {
        return createEndpoint(target, fileName: "commits_json_success")
    }
    
    func emptyResultResponse(_ target: GithubSearchService) -> Endpoint {
        return createEndpoint(target, fileName: "success_empty")
    }
    
    func createEndpoint(_ target: GithubSearchService, fileName: String) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, StubDataHelper.shared.generateResponseDataFromResourceJSON(fileName: fileName)) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
