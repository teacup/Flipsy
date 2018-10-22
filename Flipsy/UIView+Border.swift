//
//  UIView+Border.swift
//  Flipsy
//
//  Created by DotVC on 18/04/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

// Extend UIView to enable borders on one side

enum BorderSide {
    case Top, Bottom, Left, Right
}

extension UIView {
    func addBorder(to side: BorderSide) {
        let lineView = UIView()
        self.addSubview(lineView)
        lineView.backgroundColor = #colorLiteral(red:0.87, green:0.87, blue:0.87, alpha:1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        switch side {
        case .Top:
            lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .Bottom:
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .Left:
            lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        case .Right:
            lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            lineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
}
