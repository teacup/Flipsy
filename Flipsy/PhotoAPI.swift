//
//  PhotoAPI.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import Photos

// Facade to allow us to switch the photo source
class PhotoAPI {
    
    func authorisationCheck(_ result: @escaping ((Bool) -> Void) ) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            result(true)
        }
        else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                switch status {
                case .authorized:
                    result(true)
                default:
                    result(false)
                }
            })
        }
    }
    
    func loadAssets() -> PhotoStreamModel {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return PhotoStreamModel(PHAsset.fetchAssets(with: allPhotosOptions))
    }
}
