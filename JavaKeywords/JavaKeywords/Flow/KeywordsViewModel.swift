//
//  KeywordsViewModel.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

struct KeywordsViewModel {
    
    init() {
        Requester.execute(router: .keywords) { (result: Result<KeywordsQaA, Error>) in
            
            switch result{
            case .success(let provResponseDict):
                print(provResponseDict)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
