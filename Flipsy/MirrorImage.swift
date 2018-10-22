//
//  MirrorImage.swift
//  Flipsy
//
//  Created by DotVC on 09/08/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import AVFoundation

// Transform photos on the CPU to enable scaling of extremely images without memory crashes
protocol MirrorImage {}

extension MirrorImage {

    // Fixes CI rotation bug
    private func getRotationAngle() -> CGFloat {
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .portrait:
            return CGFloat.pi
        case .landscapeLeft:
            return CGFloat.pi / 2
        case .landscapeRight:
            return -CGFloat.pi / 2
        default:
            return 0
        }
    }
    
    // Mirrors photo if taken with the front-facing camera and fixes CI rotation bug
    func processImageBuffer(session: AVCaptureSession, bufferData: Data) -> (CIImage, CIContext, Data)? {
        guard let image = CIImage(data: bufferData),
                let colorSpace = image.colorSpace else { return nil }
        let input = session.inputs.first as? AVCaptureDeviceInput
        let context = CIContext()
        let rotationAngle = getRotationAngle()
        var transformedImage = CIImage()
        
        // Mirrors photo
        if input?.device.position == .front {
            transformedImage = image.transformed(by: CGAffineTransform(scaleX: -1, y: 1))
        } else {
            transformedImage = image.transformed(by: CGAffineTransform(scaleX: -1, y: -1))
        }
        
        // Fixes CI rotation bug
        transformedImage = transformedImage.transformed(by: CGAffineTransform(rotationAngle: rotationAngle))
        
        guard let jpegData = context.jpegRepresentation(of: transformedImage, colorSpace: colorSpace) else { return nil }
        
        return (transformedImage, context, jpegData)
    }
    
}
