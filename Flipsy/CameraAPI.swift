//
//  CameraAPI.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import Photos

class CameraAPI {
    
    private lazy var camera = {
        return Camera()
    }()
    
    var delegate: CameraDelegate? = nil {
        didSet {
            camera.delegate = delegate
        }
    }
    
    func loadCamera(ofSize: CGRect) {
        camera.loadCamera(ofSize: ofSize)
    }
    
    func switchCamera() {
        camera.switchCamera()
    }
    
    func setCameraSize(_ size: CGRect) {
        camera.captureVideoLayer?.frame = size
    }
    
    func start() {
        camera.session.startRunning()
    }
    
    func stop() {
        camera.session.stopRunning()
    }
    
    func takePhoto(previewWidth: CGFloat, previewHeight: CGFloat) {
        camera.takePhoto(previewWidth: previewWidth, previewHeight: previewHeight)
    }
    
    func authorisationCheck(_ result: @escaping ((Bool) -> Void)) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            result(true)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted {
                    result(true)
                } else {
                    result(false)
                }
            })
        }
    }
}
