//
//  JRInspectableButton.swift
//  CustomImageView
//
//  Created by Lokesh kumar on 14/12/20.
//  Copyright © 2020 Lokesh kumar. All rights reserved.
//

import Foundation
import UIKit

open class JRInspectableButton: UIButton {
    
    var imageScaleToUse:Double = 1.0
    @IBInspectable var imageScale: Double {
        get {
            return self.imageScaleToUse
        }
        set {
            self.imageScaleToUse = newValue
        }
    }
    
    @IBInspectable var flipImage: UIImage? {
        didSet {
            if let image = flipImage,let cgImage = image.cgImage {
                self.setImage(UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored), for: .normal)
            }
        }
    }
    
    @IBInspectable var rotateImage: Double = 0.0 {
        didSet {
            self.transform = self.transform.rotated(by: CGFloat(rotateImage * .pi / 180))
        }
    }
    
   var shouldSetTint: Bool = false
    @IBInspectable var isTintNeeded: Bool = false {
        didSet {
            self.shouldSetTint = isTintNeeded
        }
    }
    
    @IBInspectable var borderWidth: Double = 0.0 {
         didSet {
            self.layer.borderWidth = CGFloat(borderWidth)
         }
    }
    @IBInspectable var borderColour: UIColor? {
         didSet {
            self.layer.borderColor = borderColour?.cgColor
         }
    }
    
    @IBInspectable var cornerRadius: Double = 0.0 {
         didSet {
            self.layer.cornerRadius = CGFloat(cornerRadius)
         }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        var imageToSet = self.image(for: .normal)
        if self.imageScale != 1.0 {
            if let img = imageToSet {
                let sizeOfOldImage = img.size
                let sizeOfNewImage = CGSize(width: sizeOfOldImage.width * CGFloat(self.imageScale), height: sizeOfOldImage.height * CGFloat(self.imageScale))
                
                UIGraphicsBeginImageContextWithOptions(sizeOfNewImage, false, 0.0);
                img.draw(in: CGRect(x: 0, y: 0, width: sizeOfNewImage.width, height: sizeOfNewImage.height))
                imageToSet = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            }
        }
        if var imageToSet = imageToSet {
            if self.isTintNeeded {
                imageToSet = imageToSet.withRenderingMode(.alwaysTemplate)
            }
            self.setImage(imageToSet, for: .normal)
        }
    }
    
    //Set Flip/Mirrored Image.
    public func setFlipImage(flipImage: UIImage?) {
        if let flipImg = flipImage, let cgImg = flipImg.cgImage {
            self.setImage(UIImage(cgImage: cgImg, scale: flipImg.scale, orientation: UIImage.Orientation.upMirrored), for: .normal)
        }
    }
}
