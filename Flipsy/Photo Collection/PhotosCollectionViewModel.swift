//
//  PhotosCollectionViewModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import Photos

protocol PhotoCollectionDelegate {
    func photoSelected(_ photo: PHAsset)
}

class CollectionViewViewModel: NSObject {
    
    fileprivate let photoAPI: PhotoAPI
    var assets: PhotoStreamModel? {
        didSet {
            createCellModels()
        }
    }
    var cellViewModels = [PhotoPickerCellViewModel]()
    var selectedPhoto: PHAsset?
    var didUpdate: ((CollectionViewViewModel) -> Void)?
    var delegate: PhotoCollectionDelegate?
    
    init(API: PhotoAPI, delegate: PhotoCollectionDelegate) {
        self.photoAPI = API
        self.delegate = delegate
        
        super.init()
        
        reloadData()
        didUpdate?(self)
    }
    
    func reloadData() {
        self.assets = photoAPI.loadAssets()
    }
    
    func createCellModels() {
        self.cellViewModels = self.assets?.lazy.map {
            PhotoPickerCellViewModel(asset: $0)
            } ?? []
    }
    
    func displayPhoto(indexPath: IndexPath) {
        guard let assets = assets else { return }
        let selectedPhoto = assets[indexPath.item]
        self.selectedPhoto = selectedPhoto
        
        delegate?.photoSelected(selectedPhoto)
    }
    
    func photoLibraryDidChange(_ changes: PHFetchResult<PHAsset>) {
        assets?.photos = changes
        createCellModels()
    }
}
