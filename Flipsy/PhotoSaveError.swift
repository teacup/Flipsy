//
//  PhotoSaveError.swift
//  Flipsy
//
//  Created by Dot on 14/09/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit

enum PhotoSaveError: Error {
    case CIImageFailed
    case CGImageFailed
    
    var userDescription: String {
        switch self {
        default:
            return "Problem saving image"
        }
    }
    
    var privateDescription: String {
        switch self {
        default:
            return "\(String(describing: self)) failed to instantiate"
        }
    }
}
