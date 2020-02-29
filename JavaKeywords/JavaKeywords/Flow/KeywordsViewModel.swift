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

protocol TimerProtocol: class {
    func resetTimer(to time: String, buttonState: String, running: Bool)
    func updateTimer(time: String)
    func endgame(title: String, message: String, actionMessage: String)
}

protocol KWCounterProtocol: class {
    func updateKeywordsFound(number: String)
    func wrongKeyword(_ keyword: String)
}

protocol TableReloadProtocol: class {
    func reloadData()
}

private enum ButtonState: String {
    case start = "Start"
    case reset = "Reset"
}

final class KeywordsViewModel: NSObject {
    
    weak var loadingDelegate: LoadableProtocol?
    weak var timerDelegate: TimerProtocol?
    weak var kwCounterDelegate: KWCounterProtocol?
    weak var tableControlDelegate: TableReloadProtocol?
    
    fileprivate let initialTimerSeconds: Int = 4
    
    private lazy var javaKeywords: [String] = []
    private lazy var foundKeywords: [String] = []
    private var foundKeywordsNumber: String {
        return "\(foundKeywords.count.twoDigitString())/\(javaKeywords.count.twoDigitString())"
    }
    
    private lazy var timer = Timer()
    private lazy var seconds: Int = initialTimerSeconds
    private lazy var isRunning: Bool = false
    
    // MARK: - Table population functions
    
    func fetchJavaKeywords() {
        self.loadingDelegate?.isLoading()
        
        Requester.execute(router: .keywords) { [unowned self] (result: Result<KeywordsQaA, Error>) in
            switch result {
            case .success(let keywords):
                let answer = keywords.answer
                self.javaKeywords = ["a", "b"]
                self.loadingDelegate?.alreadyLoaded()
                self.kwCounterDelegate?.updateKeywordsFound(number: self.foundKeywordsNumber)
                break
            case .failure(let error):
                self.loadingDelegate?.loadError(error)
                break
            }
        }
    }
    
    func numberOfKeywords() -> Int {
        return foundKeywords.count
    }
    
    func keywordFound(for index: Int) -> String {
        guard foundKeywords.count > index else {
            return "Error"
        }
        return foundKeywords[index]
    }
    
    // MARK: - Keywords validation function
    
    func verify(_ keyword: String) {
        if keyword != "" {
            if javaKeywords.containsWithInsentiveCase(keyword) && !foundKeywords.containsWithInsentiveCase(keyword) {
                foundKeywords.append(keyword)
                self.kwCounterDelegate?.updateKeywordsFound(number: foundKeywordsNumber)
                if foundKeywords.count == javaKeywords.count {
                    self.timerDelegate?.endgame(title: "Congratulations", message: "Good job! You found all the answers on time. Keep up with the great work.", actionMessage: "Play Again")
                    self.timer.invalidate()
                }
            } else {
                self.kwCounterDelegate?.wrongKeyword(keyword)
            }
        }
    }
    
    // MARK: - Timer functions
    
    func changeTimerState() {
        if isRunning {
            self.foundKeywords = []
            self.kwCounterDelegate?.updateKeywordsFound(number: foundKeywordsNumber)
            self.timerDelegate?.resetTimer(to: initialTimerSeconds.secondsToMinutesSeconds(), buttonState: ButtonState.start.rawValue, running: isRunning)
            self.tableControlDelegate?.reloadData()
        } else {
            seconds = initialTimerSeconds
            let time = seconds.secondsToMinutesSeconds()
            self.timerDelegate?.resetTimer(to: time, buttonState: ButtonState.reset.rawValue, running: isRunning)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(KeywordsViewModel.updateTimer)), userInfo: nil, repeats: true)
        }
        isRunning.toggle()
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds >= 0 {
            let time = seconds.secondsToMinutesSeconds()
            self.timerDelegate?.updateTimer(time: time)
        } else {
            self.timer.invalidate()
            self.timerDelegate?.endgame(title: "Time finished", message: "Sorry, time is up! You got \(foundKeywords.count) out of \(javaKeywords.count) answers", actionMessage: "Try Again")
        }
    }
    
}
