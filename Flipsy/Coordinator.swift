//
//  Coordinator.swift
//  Flipsy
//
//  Created by Dot on 20/09/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

import UIKit

class Coordinator {
    
    var navigation = Navigation()
    let photoAPI = PhotoAPI()
    let cameraAPI = CameraAPI()
    
    func setup(window: UIWindow?) {
        window?.rootViewController = navigation.navigationController
        window?.makeKeyAndVisible()
        
        checkPhotoAuthorisation()
    }
    
    // MARK: - Authorisation coordinators
    
    func checkPhotoAuthorisation() {
        photoAPI.authorisationCheck{ isAuthorised in
            switch isAuthorised {
            case true:
                self.navigation.showController(self.showFlipsyView())
            case false:
                self.navigation.showController(self.showAuthorisation(.Photos))
            }
        }
    }
    
    func checkCameraAuthorisation() {
        cameraAPI.authorisationCheck{ isAuthorised in
            switch isAuthorised {
            case true:
                self.navigation.showController(self.showCameraView())
            case false:
                self.navigation.showController(self.showAuthorisation(.Camera))
            }
        }
    }
    
    // MARK: - Initialise views
    
    private func showFlipsyView() -> MainViewController? {
        let viewModel = FlipsyViewModel(
            from: FlipsyModel()
        )
        viewModel.cameraSelected = {
            self.checkCameraAuthorisation()
        }
        let controller = MainViewController.instantiate()
        controller.viewModel = viewModel
        controller.childView = showPhotosCollectionView(with: viewModel)
        return controller
    }
    
    private func showPhotosCollectionView(with delegate: PhotoCollectionDelegate) -> PhotosCollectionViewController? {
        let viewModel = CollectionViewViewModel(
            API: self.photoAPI,
            delegate: delegate
        )
        let controller = PhotosCollectionViewController.instantiate()
        controller.viewModel = viewModel
        return controller
    }
    
    private func showCameraView() -> CameraViewController? {
        let viewModel = CameraViewModel(
            API: self.cameraAPI
        )
        viewModel.photoSelected = {
            self.navigation.removeController()
        }
        let controller = CameraViewController.instantiate()
        controller.viewModel = viewModel
        return controller
    }
    
    private func showAuthorisation(_ type: PermissionType) -> PermissionsViewController? {
        let viewModel = PermissionsViewModel(
            from: PermissionsModel(type: type)
        )
        let controller = PermissionsViewController.instantiate()
        controller.viewModel = viewModel
        return controller
    }
}
