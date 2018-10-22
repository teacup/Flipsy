//
//  MainViewController.swift
//  Flipsy
//
//  Created by Dot on 06/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import Photos
import CoreImage

enum AppState {
    case running, paused
}

class MainViewController: UIViewController {

    @IBOutlet var appView: UIView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var toolbar: UIToolbar?
    @IBOutlet weak var collectionContainer: UIView!
    
    var childView: PhotosCollectionViewController? = nil
    var savedLabel: UILabel?
    var viewModel: FlipsyViewModel? {
        didSet {
            bindToView()
        }
    }
    
    var appState: AppState = .running {
        didSet {
            switch appState {
            case .running:
                appView?.isUserInteractionEnabled = true
            case .paused:
                appView?.isUserInteractionEnabled = false
            }
        }
    }
    
    var photoSaveState: PhotoSaveState? = nil {
        didSet {
            onPhotoSave()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerGestures()
        setToolbarStyling()
        UITestHelper()
        loadSubview()
    }
    
    func loadSubview() {
        guard let childView = childView else { return }

        addChildViewController(childView)
        childView.view.frame = CGRect(origin: .zero, size: collectionContainer.frame.size)
        collectionContainer.addSubview(childView.view)
        
        childView.didMove(toParentViewController: self)
    }
    
    func bindToView() {
        viewModel?.didUpdate = { [weak self] viewModel in
            self?.appState = viewModel.appState
            self?.photoSaveState = viewModel.photoSaveState
            self?.imageView?.image = viewModel.selectedImage
            self?.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    func registerGestures() {
        imageView?.isUserInteractionEnabled = true
        
        // Single tap
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imageView?.addGestureRecognizer(singleTap)
        
        // Double tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageDoubleTapped(_:)))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        imageView?.addGestureRecognizer(doubleTap)
    }
    
    func setToolbarStyling() {        
        let cameraButton: UIBarButtonItem = {
            let button = HighlightedButton()
            button.frame = CGRect(x: 0, y: 0, width: 28, height: 24)
            button.setImage(#imageLiteral(resourceName: "icon_camera3").withRenderingMode(.alwaysTemplate), for: .normal)
            button.widthAnchor.constraint(equalToConstant: 28).isActive = true
            button.heightAnchor.constraint(equalToConstant: 24).isActive = true
            button.addTarget(self, action: #selector(triggerSegue), for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        }()
        
        let saveButton: UIBarButtonItem = {
            let button = HighlightedButton()
            button.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
            button.setImage(#imageLiteral(resourceName: "icon_save4").withRenderingMode(.alwaysTemplate), for: .normal)
            button.widthAnchor.constraint(equalToConstant: 23).isActive = true
            button.heightAnchor.constraint(equalToConstant: 23).isActive = true
            button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        }()
        
        let attributes: NSDictionary = [NSAttributedStringKey.kern: CGFloat(1.2)]
        let attributedTitle = NSAttributedString(string: Constants.appName, attributes: attributes as? [NSAttributedStringKey: Any])
        
        let title: UIBarButtonItem = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont(name: "Freehand575BT-RegularB", size: 36)
            label.textColor = #colorLiteral(red:0.16, green:0.17, blue:0.21, alpha:1)
            label.shadowColor = UIColor.lightGray
            label.shadowOffset = CGSize(width: 0, height: -1)
            label.attributedText = attributedTitle
            label.sizeToFit()
            return UIBarButtonItem(customView: label)
        }()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar?.tintColor = #colorLiteral(red:0.16, green:0.17, blue:0.21, alpha:0.9)
        toolbar?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar?.setItems([cameraButton, spacer, title, spacer, saveButton], animated: true)
        
        toolbar?.addBorder(to: .Bottom)
        imageView?.addBorder(to: .Bottom)
    }
    
    func UITestHelper() {
        // Saved label required for UI testing
        let savedLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
            label.center = CGPoint(x: 160, y: 284)
            label.textAlignment = .center
            label.text = "Saved"
            label.accessibilityValue = "Photo Saved Label"
            label.isHidden = true
            return label
        }()
        #if DEBUG
        appView?.addSubview(savedLabel)
        #endif
    }
    
    @objc func triggerSegue() {
        viewModel?.cameraSelected?()
    }
    
    func onPhotoSave() {
        guard let photoSaveState = photoSaveState else { return }
        if case .Saved = photoSaveState {
            #if DEBUG
            self.savedLabel?.isHidden = false
            childView?.collectionView?.reloadData()
            #endif
        }
        print(photoSaveState.debugDescription)
    }
    
    func flipImage() {
        guard let image = imageView?.image?.mirror() else { return }
        imageView?.image = image
        viewModel?.selectedImage = image
        // print(imageView.image?.imageOrientation.rawValue)
    }
    
    func fitImage() {
        guard let imageView = imageView,
              let _ = imageView.image else { return }
        
        switch imageView.contentMode {
        case UIViewContentMode.scaleAspectFill:
            imageView.contentMode = UIViewContentMode.scaleAspectFit
        default:
            imageView.contentMode = UIViewContentMode.scaleAspectFill
        }
    }
    
    @objc func imageTapped(_ gesture: UIGestureRecognizer) {
        if let _ = gesture.view as? UIImageView {
            flipImage()
        }
    }
    
    @objc func imageDoubleTapped(_ gesture: UIGestureRecognizer) {
        if let mainImageView = gesture.view as? UIImageView,
            let _ = mainImageView.image {
            viewModel?.savePhotoChanges()
        }
    }
    
    @IBAction func saveImage(_ sender: AnyObject) {
        viewModel?.savePhotoChanges()
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        // Manually trigger viewWillAppear on the child container since embedding the view can block it from firing
        childView?.beginAppearanceTransition(true, animated: true)
        childView?.endAppearanceTransition()
    }
    
    @IBAction func flipImageButton(sender: UIButton){
        flipImage()
    }
    
    @IBAction func fitImageButton(sender: UIButton){
         fitImage()
    }

}
