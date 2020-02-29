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

    @IBOutlet weak var keywordSearchBar: UISearchBar!
    
    @IBOutlet weak var keywordTableView: UITableView!{
        didSet{
            keywordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "keywordCell")
            keywordTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var keywordCounterLabel: UILabel!
    
    @IBOutlet weak var keywordCounterTimer: UILabel!
    
    override func viewDidLoad() {
        viewModel.loadingDelegate = self
        viewModel.fetchJavaKeywords()
    }

}

extension KeywordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .white
        cell.textLabel?.text = "aaaa"
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
            let alert = UIAlertController(title: "Network error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (_) in
                self.viewModel.fetchJavaKeywords()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
