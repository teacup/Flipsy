//
//  PhotoPickerViewController.swift
//  pixpix
//
//  Created by Dot on 20/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerViewController: UICollectionViewController {

    private var assets: PHFetchResult?
    private let reuseIdentifier = "PhotoPickerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            reloadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .Authorized {
                    self.reloadAssets()
                    print("assets reloaded")
                } else {
                    self.showNeedAccessMessage()
                }
            })
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (assets != nil) ? assets!.count : 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    }
    
    func reloadAssets() {
        assets = nil
        self.collectionView!.reloadData()
        assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        self.collectionView!.reloadData()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        let image = (cell as! PhotoPickerCell).image
        
        if let unwrappedImage = image {
            mainImage.image = unwrappedImage
            mainImage.contentMode = .ScaleAspectFill
        }
        
        resetToggle()
    }
    
    // MARK: UICollectionVViewLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = collectionView.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth-6)/4, height: (screenWidth-6)/4)
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let screenWidth = collectionView.bounds.width
        let screenScale = UIScreen().scale
        let itemSizes = CGSize( width: (screenWidth-6)/4, height: (screenWidth-6)/4)
        let scaledItemSizes = CGSize(width: itemSizes.width * screenScale, height: itemSizes.height * screenScale)
        
        print("Target size is \(scaledItemSizes)", screenScale)
        
        PHImageManager.defaultManager().requestImageForAsset(
            assets?[indexPath.row] as! PHAsset,
            targetSize: scaledItemSizes,
            contentMode: .AspectFill,
            options: nil) {
                (image: UIImage?, info: [NSObject : AnyObject]?) -> Void in
                print("Result Size Is \(image!.size)")
                (cell as! PhotoPickerCell).image = image
        }
    }
    
    private func showNeedAccessMessage() {
        let alert = UIAlertController(title: "Image picker", message: "App need get access to photos", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        showViewController(alert, sender: nil)
    }
    
}
