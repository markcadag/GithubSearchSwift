//
//  DefaultSearchRepositoryService.swift
//  technicalexam
//
//  Created by iOS on 4/24/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import RxSwift
import Foundation
import Moya

protocol SearchRepositoryUseCase {
    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Repository]>
}

final class DefaultSearchRepositoryUseCase: SearchRepositoryUseCase {
   
    private var searchService: MoyaProvider<GithubSearchService>
    private var disposeBag = DisposeBag()

    init(searchService: MoyaProvider<GithubSearchService>) {
        self.searchService = searchService
    }

    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Repository]> {
        return searchService.rx.request(.search(page: requestValue.page ?? 1,
                                                offset: requestValue.offset,
                                                searchType: requestValue.searchType,
                                                query: requestValue.query))
            .mapObject(BaseResponse<Repository>.self)
            .compactMap { $0.items }
            .asObservable()
    }
}

struct SearchRepositoryUseCaseReqValue {
    let page: Int?
    let offset: Int
    let searchType: String
    let query: String
}
