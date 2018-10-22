//
//  PermissionsViewController.swift
//  Flipsy
//
//  Created by Dot on 23/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

class PermissionsViewController: UIViewController {
    
    @IBOutlet var goToSettingsButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
    var viewModel: PermissionsViewModel? {
        didSet {
            bindToViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoLabel.isHidden = true
        cameraLabel.isHidden = true
        goToSettingsButton.isHidden = false
        setState()
        self.view.bringSubview(toFront: goToSettingsButton)
    }
    
    func bindToViewModel() {
        viewModel?.didUpdate = { [weak self] viewModel in
            self?.setState()
        }
    }
    
    func setState() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.permissionType {
        case .Camera:
            cameraLabel.isHidden = false
            goToSettingsButton.setTitle(viewModel.cameraTitle, for: .normal)
        case .Photos:
            photoLabel.isHidden = false
            goToSettingsButton.setTitle(viewModel.photosTitle, for: .normal)
        }
    }
    
    @IBAction func goToSettings(_ sender: AnyObject) {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
        }
    }

}
