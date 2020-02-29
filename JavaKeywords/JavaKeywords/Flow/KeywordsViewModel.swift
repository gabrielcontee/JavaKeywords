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
    func endgame(title: String, message: String)
}

protocol KWCounterProtocol: class {
    func updateKeywordsFound(number: String)
}

private enum ButtonState: String {
    case start = "Start"
    case reset = "Reset"
}

fileprivate let initialTimerSeconds: Int = 10

final class KeywordsViewModel: NSObject {
    
    weak var loadingDelegate: LoadableProtocol?
    weak var timerDelegate: TimerProtocol?
    weak var kwCounterDelegate: KWCounterProtocol?
    
    private lazy var javaKeywords: [String] = []
    private lazy var foundKeywords: [String] = []
    private var foundKeywordsNumber: String {
        return "\(foundKeywords.count)/\(javaKeywords.count)"
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
                self.javaKeywords = keywords.answer
                self.loadingDelegate?.alreadyLoaded()
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
        if javaKeywords.containsWithInsentiveCase(keyword) && !foundKeywords.containsWithInsentiveCase(keyword) {
            foundKeywords.append(keyword)
            self.kwCounterDelegate?.updateKeywordsFound(number: foundKeywordsNumber)
        }
    }
    
    func resetKeywordGame() {
        self.timer.invalidate()
        self.kwCounterDelegate?.updateKeywordsFound(number: foundKeywordsNumber)
    }
    
    // MARK: - Timer functions
    
    func changeTimerState() {
        seconds = initialTimerSeconds
        let time = seconds.secondsToMinutesSeconds()
        if isRunning {
            resetKeywordGame()
            self.timerDelegate?.resetTimer(to: time, buttonState: ButtonState.start.rawValue, running: isRunning)
        } else {
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
            changeTimerState()
            self.timerDelegate?.endgame(title: "BLABLA", message: "FIM DE JOGO, VOCÊ........")
        }
    }
}
