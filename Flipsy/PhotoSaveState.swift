//
//  PhotoSaveState.swift
//  Flipsy
//
//  Created by DotVC on 01/08/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import Foundation

enum PhotoSaveState {
    case Saved, UnSaved(String)
}

extension PhotoSaveState: Equatable {
    public var debugDescription: String {
        switch self {
        case .Saved:
            return "Finished saving"
        case .UnSaved(let error):
            return "PHAsset change request error: \(error))"
        }
    }
}

func ==(lhs: PhotoSaveState, rhs: PhotoSaveState) -> Bool {
    switch (lhs, rhs) {
    case (.Saved, .Saved):
        return true
    case (.UnSaved(_), .UnSaved(_)):
        return true
    default:
        return false
    }
}
