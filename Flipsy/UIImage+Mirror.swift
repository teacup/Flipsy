//
//  UIImage+Mirror.swift
//  Flipsy
//
//  Created by DotVC on 04/04/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit

/**
    Extend UIImage to enable images to be flipped.
    - Detail: We present a much smaller UIImage version of the photo to the user to interact with on the front end.
*/
extension UIImage {
    
    func mirror() -> UIImage {
        if #available(iOS 10, *) {
            return self.withHorizontallyFlippedOrientation()
        } else {
            switch self.imageOrientation {
                case .up:
                    return self.flippedHorizontally
                case .upMirrored:
                    return self.original
                default:
                    return self
            }
        }
    }
    
    var flippedHorizontally: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .upMirrored)
    }
    
    var original: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .up)
    }
    
    /**
        Fix exif/orientation configuration problem in portrait photos
 
        - Returns: A normalised UIImage
        - Note: 
            [Exif problems](https://stackoverflow.com/a/20276301/2209609)
    */
    func normalizedImage() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        var rect = CGRect.zero
        rect.size = self.size
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
