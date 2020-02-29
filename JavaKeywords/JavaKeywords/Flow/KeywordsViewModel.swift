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
    func resetTimer(to time: String, buttonState: String)
    func updateTimer(time: String)
    func endgame(title: String, message: String)
}

private enum ButtonState: String {
    case start = "Start"
    case reset = "Reset"
}

fileprivate let initialTimerSeconds: Int = 4

final class KeywordsViewModel: NSObject {
    
    weak var loadingDelegate: LoadableProtocol?
    
    weak var timerDelegate: TimerProtocol?
    
    private lazy var javaKeywords: [String] = []
    
    private lazy var timer = Timer()
    private lazy var seconds: Int = initialTimerSeconds
    private lazy var isRunning: Bool = false
    
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
    
    // MARK: - Keywords validation functions
    
    
    
    // MARK: - Timer functions
    
    func changeTimerState() {
        seconds = initialTimerSeconds
        let time = seconds.secondsToMinutesSeconds()
        if isRunning {
            self.timer.invalidate()
            self.timerDelegate?.resetTimer(to: time, buttonState: ButtonState.start.rawValue)
        } else {
            self.timerDelegate?.resetTimer(to: time, buttonState: ButtonState.reset.rawValue)
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
