//
//  ImageExtensions.swift
//  Flipsy
//
//  Created by Dot on 20/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDeviceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeRight
        case .landscapeRight: return .landscapeLeft
        default: return nil
        }
    }
}

// Extend UIApplication to enable setting the statusbar colour

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


