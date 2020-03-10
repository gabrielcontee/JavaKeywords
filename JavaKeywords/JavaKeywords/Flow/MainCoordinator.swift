//
//  MainCoordinator.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator{
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let clientProvider: Requester = Requester()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func start() {
        let keywordsVC = KeywordsViewController()
        keywordsVC.coordinator = self
        navigationController.pushViewController(keywordsVC, animated: false)
    }
    
}

