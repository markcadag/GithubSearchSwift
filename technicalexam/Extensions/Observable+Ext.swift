//
//  Observable+Ext.swift
//  technicalexam
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.Element> {
        compactMap { $0.event.element }
    }

    func errors() -> Observable<Swift.Error> {
        compactMap { $0.event.error }
    }
}

public protocol LoadingDataConvertible {
    /// Type of element in event
    associatedtype ElementType

    /// Event representation of this instance
    var data: Event<ElementType>? { get }
    var loading: Bool { get }
}

public struct LoadingResult<E>: LoadingDataConvertible {
    public let data: Event<E>?
    public let loading: Bool

    public init(_ loading: Bool) {
        self.data = nil
        self.loading = loading
    }

    public init(_ data: Event<E>) {
        self.data = data
        self.loading = false
    }
}

extension ObservableType {
    public func monitorResult() -> Observable<LoadingResult<Element>> {
        return self.materialize()
            .map(LoadingResult.init)
            .startWith(LoadingResult(true))
    }
}

extension ObservableType where Element: LoadingDataConvertible {
    public func loading() -> Observable<Bool> {
        return self
            .map { $0.loading }
    }

    public func elements() -> Observable<Element.ElementType> {
        return self
            .events()
            .elements()
    }

    public func errors() -> Observable<Error> {
        return self
            .events()
            .errors()
    }

    // MARK: - Private
    private func events() -> Observable<Event<Element.ElementType>> {
        return self
            .filter { !$0.loading }
            .compactMap { $0.data }
    }
}
