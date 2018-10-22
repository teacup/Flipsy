//
//  CameraViewController.swift
//  Flipsy
//
//  Created by Dot on 23/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var previewView: UIImageView! = nil
    @IBOutlet weak var switchToFrontCamera: UIButton!
    @IBOutlet weak var controlsView: UIView!
    
    var viewModel: CameraViewModel?
    
    var cameraCaptureLayer: AVCaptureVideoPreviewLayer? = nil {
        didSet {
            guard let layer = cameraCaptureLayer else { return }
            self.cameraView.layer.addSublayer(layer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToView()
        viewModel?.loadCamera(viewSize: self.cameraView.bounds)
        setStyling()
        registerGestures()
    }
    
    func bindToView() {
        viewModel?.didUpdate = { [weak self] viewModel in
            self?.cameraCaptureLayer = viewModel.cameraCaptureLayer
        }
        viewModel?.photoCaptured = { [weak self] photoData in
            self?.setPreviewImage(imageData: photoData.image, context: photoData.context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel?.cameraAPI.setCameraSize(self.cameraView.bounds)
    }
    
    // MARK: - Setup methods
    
    func setStyling() {
        cameraView.addBorder(to: .Top)
        controlsView.addBorder(to: .Top)
        
        previewView.isUserInteractionEnabled = true
        previewView.layer.borderWidth = 1
        previewView.layer.borderColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.00).cgColor
        previewView.layer.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.1).cgColor
        previewView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func registerGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        previewView.addGestureRecognizer(singleTap)
    }
    
    // MARK: - Methods to show the photo preview image
    
    // Grab a screenshot of the current preview image
    func captureScreen() -> UIImage? {
        let globalPoint = self.previewView.superview?.convert(self.previewView.frame.origin, to: nil)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.previewView.frame.width, height: self.previewView.frame.height), false, UIScreen.main.scale)
        view.drawHierarchy(in: CGRect(x: -globalPoint!.x, y: -globalPoint!.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Method to mimic the Photos app preview image animation
    func setPreviewImage(imageData: CIImage, context: CIContext) {
        
        // To save memory, scales preview image on GPU before displaying
        let transformedImage = imageData.transformed(by: CGAffineTransform(scaleX: 0.2, y: 0.2))
        let previewData = context.jpegRepresentation(of: transformedImage, colorSpace: transformedImage.colorSpace!)
        
        let screenshotView = UIImageView()
        
        if self.previewView.isHidden {
            self.previewView.image = UIImage(data: previewData!)
            self.previewView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } else {
            // If previous preview image exists, screenshot it and temporarily position it under new image to enable smooth animation
            let screenshot = captureScreen()
            screenshotView.image = screenshot
            screenshotView.frame = CGRect(x: self.previewView.frame.origin.x, y: self.previewView.frame.origin.y, width: self.previewView.frame.width, height: self.previewView.frame.height)

            self.controlsView.insertSubview(screenshotView, belowSubview: self.previewView)
            self.previewView.image = UIImage(data: previewData!)
            self.previewView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.previewView.isHidden = false

            self.previewView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in screenshotView.removeFromSuperview() })

    }
    
    // MARK: - Actions / Gestures
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        viewModel?.cameraAPI.takePhoto(previewWidth: self.previewView.bounds.width, previewHeight: self.previewView.bounds.height)
    }
    
    @IBAction func switchCameraButton(_ sender: UIButton) {
        viewModel?.cameraAPI.switchCamera()
    }
    
    @objc func imageTapped(_ gesture: UIGestureRecognizer) {
        viewModel?.photoSelected?()
    }
    
}
