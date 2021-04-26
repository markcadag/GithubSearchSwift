//
//  DefeaultSearchIssueUsecase.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol SearchIssuesUseCase {
    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Issue]>
}

final class DefaultSearchIssuesUseCase: SearchIssuesUseCase {
   
    private var searchService: MoyaProvider<GithubSearchService>
    private var disposeBag = DisposeBag()

    init(searchService: MoyaProvider<GithubSearchService>) {
        self.searchService = searchService
    }

    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Issue]> {
        return searchService.rx.request(.search(page: requestValue.page ?? 1,
                                                offset: requestValue.offset,
                                                searchType: requestValue.searchType,
                                                query: requestValue.query))
            .mapObject(BaseResponse<Issue>.self)
            .compactMap { $0.items }
            .asObservable()
    }
}
