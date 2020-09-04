//
//  UIImageView+ImageMask.swift
//  StackOverflowUsers
//
//  Created by Colin Walsh on 9/4/20.
//  Copyright © 2020 Colin Walsh. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.image = anyImage
    }
}
