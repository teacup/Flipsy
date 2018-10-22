//
//  CameraViewModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewModel: CameraDelegate {
    
    let cameraAPI: CameraAPI
    var cameraCaptureLayer: AVCaptureVideoPreviewLayer?
    var didUpdate: ((CameraViewModel) -> Void)?
    var photoCaptured: ((PhotoData) -> Void)?
    var photoSelected: (() -> Void)?
    
    init(API: CameraAPI) {
        self.cameraAPI = API
        API.delegate = self
    }
    
    func loadCamera(viewSize: CGRect) {
        cameraAPI.loadCamera(ofSize: viewSize)
    }
    
    func afterPhotoCapture(_ data: PhotoData) {
        photoCaptured?((image: data.image, context: data.context))
    }
    
    func afterCameraLoad(_ cameraCaptureLayer: AVCaptureVideoPreviewLayer) {
        self.cameraCaptureLayer = cameraCaptureLayer
        didUpdate?(self)
    }
    
    func startSession() {
        cameraAPI.start()
    }
    
    func stopSession() {
        cameraAPI.stop()
    }
}
