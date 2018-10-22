//
//  FlipsyViewModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit
import Photos
import CoreImage

class FlipsyViewModel {
    
    var selectedAsset: PHAsset?
    var selectedImage: UIImage? {
        didSet {
            imageOrientation = selectedImage?.imageOrientation
        }
    }
    var imageOrientation: UIImageOrientation?
    var input: PHContentEditingInput? = nil
    var didUpdate: ((FlipsyViewModel) -> Void)?
    var appState: AppState = .running {
        didSet {
            didUpdate?(self)
        }
    }
    var photoSaveState: PhotoSaveState?
    
    init(from model: FlipsyModel) {
        self.selectedAsset = model.selectedImage
        preparePhotoForEditing(asset: model.selectedImage, completion: setPhotoOnView)
    }
    
    func setPhotoOnView(_ image: UIImage, input: PHContentEditingInput) {
        self.input = input
        self.selectedImage = image
        didUpdate?(self)
    }
    
    var cameraSelected: (() -> Void)?
    
}

extension FlipsyViewModel: PhotoEditor, PhotoCollectionDelegate {
    
    func photoSelected(_ photo: PHAsset) {
        self.selectedAsset = photo
        preparePhotoForEditing(asset: photo, completion: setPhotoOnView)
    }
    
    func savePhotoChanges(){
        print("started saving")
        guard let input = self.input, let asset = self.selectedAsset, let image = self.selectedImage else { return }
        
        appState = .paused
        
        savePhotoEdits(orientation: image.imageOrientation, input: input, asset: asset, then: afterPhotoSaved)
    }
    
    func afterPhotoSaved(_ photoState: PhotoSaveState) {
        photoSaveState = photoState
        appState = .running
        didUpdate?(self)
    }
    
}
