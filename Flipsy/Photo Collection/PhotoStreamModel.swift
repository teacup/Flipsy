//
//  PhotoStreamModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import Photos

struct PhotoStreamModel {
    var photos: PHFetchResult<PHAsset>
    
    init(_ photos: PHFetchResult<PHAsset>) {
        self.photos = photos
    }
}

extension PhotoStreamModel: Collection {
    var startIndex: Int { return 0 }
    var endIndex: Int { return photos.count }
    func index(after i: Int) -> Int { return i + 1 }
    subscript(index: Int) -> PHAsset { return photos[index] }
}
