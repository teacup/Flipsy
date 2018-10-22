//
//  PhotosCollectionViewController.swift
//  Flipsy
//
//  Created by Dot on 20/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import Photos
import ImageIO
import MobileCoreServices

class PhotosCollectionViewController: UICollectionViewController, PhotoEditor, PHPhotoLibraryChangeObserver {

    @IBOutlet var appView: UIView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet var photosCollectionView: UICollectionView!
    
    var viewModel: CollectionViewViewModel? {
        didSet {
            bindToViewModel()
        }
    }

    var asset: PHAsset? = nil
    var input: PHContentEditingInput? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
    }
    
    func bindToViewModel() {
        viewModel?.didUpdate = { [weak self] viewModel in
            self?.collectionView?.reloadData()
            self?.selectFirstPhoto()
        }
        reloadData()
    }
    
    private func reloadData() {
        viewModel?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Load and show photos
    
    func selectFirstPhoto() {
        guard let viewModel = viewModel, viewModel.cellViewModels.count > 0 else { return }
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.photosCollectionView.scrollToItem(at: firstIndexPath, at: [], animated: false)
        displayPhoto(indexPath: firstIndexPath)
    }
    
    // Store photo as current asset, and kick off contentEditingInput request
    func displayPhoto(indexPath: IndexPath) {
        viewModel?.displayPhoto(indexPath: indexPath)
    }
    
    // MARK: - Handle photo editing
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let collectionView = self.collectionView, let unwrappedAssets = self.viewModel?.assets?.photos else { return }
        
        let group = DispatchGroup() // Block further execution on the thread until all changes to the CollectionView are complete to avoid NSInternalInconsistencyExceptions with the datasource
        group.enter()
        
        DispatchQueue.main.async {
            
            if let changes = changeInstance.changeDetails(for: unwrappedAssets) {
                self.viewModel?.photoLibraryDidChange(changes.fetchResultAfterChanges)
                
                if changes.hasIncrementalChanges {
                    collectionView.performBatchUpdates({

                        if let removed = changes.removedIndexes, removed.count > 0 {
                            collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
                        }
                        if let inserted = changes.insertedIndexes, inserted.count > 0 {
                            collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
                        }

                    }, completion: { _ in
                        if let changed = changes.changedIndexes, changed.count > 0 {
                            collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
                        }
                        
                        changes.enumerateMoves { fromIndex, toIndex in
                            
                            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                    to: IndexPath(item: toIndex, section: 0))
                        }
                        
                        if let inserted = changes.insertedIndexes, inserted.count > 0 {
                            self.selectFirstPhoto()
                        }
                    })
                } else {
                    collectionView.reloadData()
                }
            }
            group.leave()
        }
    
        group.wait()
    }

}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let amountPerLine: CGFloat = 4
        let screenSize = collectionView.frame
        let photoSize = (screenSize.width-6) / amountPerLine
        return CGSize(width: photoSize, height: photoSize)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel?.cellViewModels[indexPath.row].dequeCell(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }
    
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayPhoto(indexPath: indexPath)
    }
    
}
