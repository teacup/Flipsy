//
//  PermissionsViewModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

class PermissionsViewModel {
    var model: PermissionsModel
    var cameraTitle: String
    var photosTitle: String
    var permissionType: PermissionType
    
    init(from model: PermissionsModel) {
        self.model = model
        self.cameraTitle = model.enableCameraTitle
        self.photosTitle = model.enablePhotosTitle
        self.permissionType = model.type
    }
    
    var didUpdate: ((PermissionsViewModel) -> Void)?
}
