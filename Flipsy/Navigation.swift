//
//  Navigation.swift
//  Flipsy
//
//  Created by Dot on 22/09/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit

// MARK: - Navigation methods

class Navigation {
    
    var navigationController: UINavigationController?
    
    init() {
        navigationController = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
        navigationController?.isNavigationBarHidden = true
    }
    
    func showController(_ controller: UIViewController?) {
        guard let controller = controller else { return }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func removeController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


