//
//  KeywordsLogicTests.swift
//  KeywordsLogicTests
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import XCTest
@testable import JavaKeywords

class MockApi: RequestExecuter {
    
    func execute<T>(router: Router, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable, T : Encodable {
        
        let keywordsMocked = KeywordsQaA(question: "What are the mocked keywords?", answer: ["test", "test2", "test3"])
        let data = try! JSONEncoder().encode(keywordsMocked)
        let responseObject = try! JSONDecoder().decode(T.self, from: data)
        
        completion(.success(responseObject))
    }
    
}

class KeywordsLogicTests: XCTestCase {

    var keywordsViewModel: KeywordsViewModel!
    var keywordsMocked: KeywordsQaA!
    
    override func setUp() {
        
        let mockClient = MockApi()
        keywordsViewModel = KeywordsViewModel(apiClient: mockClient)
    
        let fetchExpectation = expectation(description: "Fetch")
        
        keywordsViewModel.apiClient.execute(router: .keywords) { (result: Result<KeywordsQaA, Error>) in
            switch result {
            case .success(let mockKeywords):
                self.keywordsViewModel.javaKeywords = mockKeywords.answer
                fetchExpectation.fulfill()
                break
            case .failure(_):
                XCTFail("Should always load with success")
            }
        }
        
        wait(for: [fetchExpectation], timeout: 3.0)
        
        keywordsViewModel.verify("test2")
        keywordsViewModel.verify("nottrue")
    }

    func testNumberOfKeywords() {
        XCTAssert(keywordsViewModel.javaKeywords.count == 3)
        XCTAssert(keywordsViewModel.foundKeywords.count == 1)
    }
    
    func testKeywordsAtIndex() {
        let keywordForIndex = keywordsViewModel.keywordFound(for: 0)
        XCTAssert(keywordForIndex == "test2")
    }

    func testStateOfGame() {
        XCTAssertFalse(keywordsViewModel.isRunning)
        keywordsViewModel.changeTimerState()
        XCTAssertTrue(keywordsViewModel.isRunning)
    }
}
