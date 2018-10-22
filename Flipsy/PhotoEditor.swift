//
//  PhotoEditor.swift
//  Flipsy
//
//  Created by DotVC on 03/08/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

/**
    PhotoEditor handles the editing functionality for PHAssets
 */
protocol PhotoEditor {}

extension PhotoEditor {
    
    /**
        Preload and prepare a photo for editing
     */
    func preparePhotoForEditing(asset: PHAsset?, completion: @escaping (UIImage, PHContentEditingInput) -> () ){
        let options = PHContentEditingInputRequestOptions()
        var id: PHContentEditingInputRequestID = 0
        var image: UIImage?
        
        options.canHandleAdjustmentData = { _ in return false }
        
        if let assetToEdit = asset {
            id = assetToEdit.requestContentEditingInput(with: options) { input, info in
                guard let input = input else {
                    assetToEdit.cancelContentEditingInputRequest(id)
                    return
                }
                
                image = input.displaySizeImage
                image = image?.normalizedImage()
                completion(image!, input)
            }
        }
    }
    
    /**
        Receives orientation changes to photo, applies and saves them
     
        - Remark: Uses CIImage to convert PHAssets on the GPU to avoid running out of memory with giant photo assets(!)
     */
    func savePhotoEdits(orientation: UIImageOrientation,
                        input: PHContentEditingInput,
                        asset: PHAsset,
                        then callback: @escaping (PhotoSaveState) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let url = input.fullSizeImageURL,
                  let inputImage = CIImage(contentsOf: url, options: nil)?.oriented(forExifOrientation: input.fullSizeImageOrientation) else {
                callback(.UnSaved(PhotoSaveError.CIImageFailed.privateDescription))
                return
            }
            
            let output = PHContentEditingOutput(contentEditingInput: input)
            var transformedImage: CIImage?
            
            if orientation == .upMirrored {
                transformedImage = inputImage.transformed(by: CGAffineTransform(scaleX: -1, y: 1))
            }
            
            // Save photo even if no orientation changes have been applied, since the user has requested it
            guard let outputCGImage = CIContext().createCGImage(transformedImage ?? inputImage, from: transformedImage?.extent ?? inputImage.extent),
                let destination = CGImageDestinationCreateWithURL(output.renderedContentURL as CFURL, kUTTypeJPEG, 1, nil) else {
                callback(.UnSaved(PhotoSaveError.CGImageFailed.privateDescription))
                return
            }
            
            CGImageDestinationAddImage(destination, outputCGImage, [kCGImageDestinationLossyCompressionQuality as String: 1] as CFDictionary)
            CGImageDestinationFinalize(destination)
            
            // Record type of edit made to PHAsset
            let archivedData =
                NSKeyedArchiver.archivedData(withRootObject: String(describing: orientation))
            
            let adjustmentData = PHAdjustmentData(formatIdentifier: "com.dot.flipsy",
                                                  formatVersion: "1.0",
                                                  data: archivedData)
            
            output.adjustmentData = adjustmentData
            
            PHPhotoLibrary.shared().performChanges({
                
                let request = PHAssetChangeRequest(for: asset)
                request.contentEditingOutput = output
                
            }) { saved, error in
                DispatchQueue.main.async {
                    if saved {
                        callback(.Saved)
                    } else {
                        callback(.UnSaved(String(describing: error)))
                    }
                }
            }
        }
    }
    
}
