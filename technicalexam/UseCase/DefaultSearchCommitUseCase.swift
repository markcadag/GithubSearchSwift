//
//  DefaultSearchCommitUseCase.swift
//  technicalexam
//
//  Created by iOS on 4/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol SearchCommitUseCase {
    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Commit]>
}

final class DefaultSearchCommitUseCase: SearchCommitUseCase {
   
    private var searchService: MoyaProvider<GithubSearchService>
    private var disposeBag = DisposeBag()

    init(searchService: MoyaProvider<GithubSearchService>) {
        self.searchService = searchService
    }

    func execute(requestValue: SearchRepositoryUseCaseReqValue) -> Observable<[Commit]> {
        return searchService.rx.request(.search(page: requestValue.page ?? 1,
                                                offset: requestValue.offset,
                                                searchType: requestValue.searchType,
                                                query: requestValue.query))
            .mapObject(BaseResponse<Commit>.self)
            .compactMap { $0.items }
            .asObservable()
    }
}
