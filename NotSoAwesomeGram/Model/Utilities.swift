//
//  Utilities.swift
//  NotSoAwesomeGram
//
//  Created by Eli Armstrong on 3/4/19.
//  Copyright © 2019 Eli Armstrong. All rights reserved.
//

import Foundation
import Parse

class Utilities{
    static func imageToPFFileObject(image: UIImage, imageName: String) -> PFFileObject {
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        return PFFileObject(name: "\(imageName).png", data: scaledImage.pngData()!)!
    }
}
