//
//  Camera.swift
//  Flipsy
//
//  Created by DotVC on 03/08/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

typealias PhotoData = (image: CIImage, context: CIContext)

protocol CameraDelegate {
    func afterPhotoCapture(_: PhotoData)
    func afterCameraLoad(_: AVCaptureVideoPreviewLayer)
}

class Camera: NSObject, AVCapturePhotoCaptureDelegate, MirrorImage {
    
    var session: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var device: AVCaptureDevice!
    var captureVideoLayer: AVCaptureVideoPreviewLayer?
    var usingFrontCamera: Bool = false
    var delegate: CameraDelegate?
    
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position)
    }
    
    func loadCamera(ofSize size: CGRect) {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        stillImageOutput = AVCapturePhotoOutput()
        
        device = (usingFrontCamera ? cameraWithPosition(position: .front) : cameraWithPosition(position: .back))
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (session.canAddInput(input)) {
                session.addInput(input)
                if (session.canAddOutput(stillImageOutput)) {
                    session.addOutput(stillImageOutput)
                    captureVideoLayer = AVCaptureVideoPreviewLayer.init(session: session)
                    captureVideoLayer?.frame = size
                    captureVideoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    if let vidOrientation = UIDevice.current.orientation.videoOrientation {
                        captureVideoLayer?.connection?.videoOrientation = vidOrientation
                    }
                    
                    captureVideoLayer?.frame = size
                    self.delegate?.afterCameraLoad(captureVideoLayer!)
                }
            }
        } catch let firstError {
            print("Error creating capture device input: \(firstError.localizedDescription)")
        }
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            if let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
            
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let (image, context, jpegData) = self.processImageBuffer(session: self.session, bufferData: data) else { return }
                    
                    DispatchQueue.main.async {
                        self.delegate?.afterPhotoCapture((image: image, context: context))
                    }
                    
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        request.addResource(with: .photo, data: jpegData, options: nil)
                    }){ saved, error in
                        if (error != nil) {
                            print("phasset change request error: \(String(describing: error))")
                        }
                        
                    }
                }
            }
        }
    }
    
    func takePhoto(previewWidth: CGFloat, previewHeight: CGFloat) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        
        let position = device.position
        settingsForMonitoring.flashMode = position == .front || position == .unspecified ? .off : .auto
        
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        let previewPixelType = settingsForMonitoring.availablePreviewPhotoPixelFormatTypes.first!
        settingsForMonitoring.previewPhotoFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: previewWidth,
            kCVPixelBufferHeightKey as String: previewHeight
        ]
        
        stillImageOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func switchCamera(){
        usingFrontCamera = !usingFrontCamera
        
        if let session = self.session {
            var newCamera: AVCaptureDevice! = nil
            var newVideoInput: AVCaptureDeviceInput!
            
            session.beginConfiguration()
            
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else { return }
            session.removeInput(currentCameraInput)
            
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back){
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let error as NSError {
                print("Error creating capture device input: \(error.localizedDescription)")
            }
            
            session.addInput(newVideoInput)
            session.commitConfiguration()
        }
    }
}
