//
//  UITapGestureRecognizer+Extension.swift
//  Flipsy
//
//  Created by DotVC on 04/04/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

// Override UITapGestureRecognizer to stop single-tap delay when...

class UIShortTapGestureRecognizer: UITapGestureRecognizer {
    let tapMaxDelay: Double = 0.3
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)
        delay(delay: tapMaxDelay) {
            // Enough time has passed and the gesture was not recognized -> It has failed.
            if  self.state != UIGestureRecognizerState.ended {
                self.state = UIGestureRecognizerState.failed
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when){}
    }
}
