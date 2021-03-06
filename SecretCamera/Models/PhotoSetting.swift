//
//  PhotoSetting.swift
//  SecretCamera
//
//  Created by Hung on 8/21/17.
//  Copyright © 2017 Hung. All rights reserved.
//

import Foundation

final class PhotoTimeSetting: SettingLogoWithOptions {
    
    init(name: String, imageNamed: String) {
        let options = ["3s", "5s", "10s"]
        super.init(name: name, imageNamed: imageNamed, options: options)
    }
}
