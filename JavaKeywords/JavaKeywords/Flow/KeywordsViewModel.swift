//
//  KeywordsViewModel.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

protocol LoadableProtocol: class {
    func isLoading()
    func alreadyLoaded()
    func loadError(_ error: Error)
}

final class KeywordsViewModel: NSObject {
    
    weak var loadingDelegate: LoadableProtocol?
    
    private lazy var javaKeywords: [String] = []
    
    func fetchJavaKeywords() {
        self.loadingDelegate?.isLoading()
        
        Requester.execute(router: .keywords) { [unowned self] (result: Result<KeywordsQaA, Error>) in
            switch result {
            case .success(let keywords):
                self.javaKeywords = keywords.answer
                self.loadingDelegate?.alreadyLoaded()
                break
            case .failure(let error):
                self.loadingDelegate?.loadError(error)
                break
            }
        }
    }
}
