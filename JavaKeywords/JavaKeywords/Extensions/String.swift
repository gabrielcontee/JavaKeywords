//
//  String.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 29/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

extension String {
    mutating func twoDigit() {
         self = String(format: "%02d", self)
    }
}

extension Int {
    func twoDigitString() -> String {
        return String(format: "%02d", self)
    }
}
