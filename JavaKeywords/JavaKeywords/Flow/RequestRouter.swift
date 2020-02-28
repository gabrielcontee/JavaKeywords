//
//  RequestRouter.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

protocol RequestComponents {
    var baseUrl: String { get }
    var path: String { get }
}

enum Router: RequestComponents {
    
    case keywords
    
    var baseUrl: String {
        switch self {
        case .keywords:
            return "https://codechallenge.arctouch.com/"
        }
    }
    
    var path: String {
        switch self {
        case .keywords:
            return "quiz/1"
        }
    }
    
    var method: String {
      switch self {
      case .keywords:
          return "GET"
      }
    }
}
