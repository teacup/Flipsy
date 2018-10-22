//
//  UIViewController+Instantiate.swift
//  Flipsy
//
//  Created by Dot on 22/09/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static func instantiate() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    static func instantiate() -> Self {
        let name = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: name) as! Self
    }
}

extension UIViewController: StoryboardInstantiable { } // Automatically apply to all ViewControllers
