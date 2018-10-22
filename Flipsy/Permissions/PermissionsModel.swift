//
//  PermissionsModel.swift
//  Flipsy
//
//  Created by Dot on 16/10/2018.
//  Copyright © 2018 Dot. All rights reserved.
//

enum PermissionType {
    case Camera
    case Photos
}

struct PermissionsModel {
    var enableCameraTitle = "Enable camera access"
    var enablePhotosTitle = "Enable photo access"
    var type: PermissionType
    
    init(type: PermissionType) {
        self.type = type
    }
}
