//
//  KeywordsViewController.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import UIKit

final class KeywordsViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var keywordSearchBar: UISearchBar!
    @IBOutlet weak var keywordTableView: UITableView!
    @IBOutlet weak var keywordCounterLabel: UILabel!
    @IBOutlet weak var keywordCounterTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
