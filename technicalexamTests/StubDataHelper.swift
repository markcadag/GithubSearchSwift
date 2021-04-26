//
//  StubDataHelper.swift
//  technicalexamTests
//
//  Created by iOS on 04/25/21.
//  Copyright © 2021 iOS. All rights reserved.
//
import Foundation

@testable import technicalexam

final class StubDataHelper {
    static let shared = StubDataHelper()

    func generateResponseDataFromResourceJSON(fileName: String) -> Data {
        if let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            } catch { fatalError() }
        }
        return Data()
    }
}
