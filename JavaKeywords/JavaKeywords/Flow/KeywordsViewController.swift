//
//  KeywordsViewController.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import UIKit

final class KeywordsViewController: UIViewController {
    
    private lazy var viewModel = KeywordsViewModel()
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var challengeControlButton: UIButton!
    
    @IBOutlet weak var keywordSearchBar: UISearchBar!{
        didSet{
            keywordSearchBar.delegate = self
            keywordSearchBar.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var keywordTableView: UITableView!{
        didSet{
            keywordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "keywordCell")
            keywordTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var keywordCounterLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        viewModel.timerDelegate = self
        viewModel.loadingDelegate = self
        viewModel.fetchJavaKeywords()
    }
    
    @IBAction func startKeywordChallenge(_ sender: Any) {
        viewModel.changeTimerState()
    }
    
}

extension KeywordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfKeywords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .white
        cell.textLabel?.text = viewModel.keywordFound(for: indexPath.row)
        cell.textLabel?.textColor = .black

        return cell
    }
    
    
}

extension KeywordsViewController: LoadableProtocol {
    
    func isLoading() {
        DispatchQueue.main.async {
            Spinner.start(from: self.view)
        }
    }
    
    func alreadyLoaded() {
        DispatchQueue.main.async {
            Spinner.stop()
        }
    }
    
    func loadError(_ error: Error) {
        DispatchQueue.main.async {
            Spinner.stop()
            self.showAlert(title: "Network error", message: error.localizedDescription)
        }
    }
    
}

extension KeywordsViewController: TimerProtocol {

    func endgame(title: String, message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: title, message: message)
        }
    }
    
    func resetTimer(to seconds: String, buttonState: String, running: Bool) {
        DispatchQueue.main.async {
            self.keywordSearchBar.isUserInteractionEnabled = !running
            self.challengeControlButton.setTitle(buttonState, for: .normal)
            self.timerLabel.text = String(seconds)
        }
    }
    
    func updateTimer(time: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = time
        }
    }
}

extension KeywordsViewController: KWCounterProtocol {
    
    func updateKeywordsFound(number: String) {
        DispatchQueue.main.async {
            self.keywordCounterLabel.text = number
        }
    }

}

extension KeywordsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        viewModel.verify(text)
        DispatchQueue.main.async {
            self.keywordSearchBar.endEditing(true)
            self.keywordSearchBar.text = ""
            self.keywordTableView.reloadData()
        }
    }
}
