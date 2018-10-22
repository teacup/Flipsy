//
//  HighlightedButton.swift
//  Flipsy
//
//  Created by DotVC on 16/04/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

internal class HighlightedButton: UIButton {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.3
            } else {
                self.alpha = 1
            }
        }
    }
    
}
