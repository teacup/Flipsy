//
//  PhotoPickerCellViewModel.swift
//  Flipsy
//
//  Created by Dot on 14/09/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerCellViewModel {
    
    fileprivate var containerWidth: CGFloat?
    let reuseIdentifier = "PhotoPickerCell"
    var asset: PHAsset
    
    var didUpdate: ((PhotoPickerCellViewModel) -> ())?
    
    init(asset: PHAsset) {
        self.asset = asset
    }
    
    var image: UIImage? = nil
    
    var thumbnailSize: CGSize {
        let screenWidth = containerWidth ?? 80,
        cellsPerLine: CGFloat = 4,
        cellSize = (screenWidth-6)/cellsPerLine
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func loadImage() {
        if self.image == nil {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: thumbnailSize,
                contentMode: .aspectFill,
                options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                    guard let image = image else { return }
                    self.image = image
                    self.didUpdate?(self)
            }
        }
    }
    
    func dequeCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoPickerCell else { return UICollectionViewCell() }
        self.containerWidth = collectionView.frame.width
        cell.setup(self)
        self.loadImage()
        return cell
    }
}
