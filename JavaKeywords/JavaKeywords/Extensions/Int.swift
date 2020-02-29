//
//  Int.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import Foundation

extension Int {
    func secondsToMinutesSeconds() -> String {
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        return "\(minutes):\(seconds)"
    }
}
