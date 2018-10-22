//
//  PhotoPickerCell.swift
//  Flipsy
//
//  Created by Dot on 10/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

class PhotoPickerCell: UICollectionViewCell {
    @IBOutlet weak fileprivate var imageView: UIImageView?
    
    func setup(_ viewModel: PhotoPickerCellViewModel) {
        self.imageView?.image = viewModel.image
        
        viewModel.didUpdate = self.setup
    }
}

