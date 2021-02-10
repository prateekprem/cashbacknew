//
//  JRCustomImageView.swift

//
//  Created by Lokesh Kumar on 08/12/20.
//
import Foundation
import UIKit

open class JRInspectableImageView: UIImageView {
    
    @IBInspectable var rotateImage: Double = 0.0 {
        didSet {
            self.transform = self.transform.rotated(by: CGFloat(rotateImage * .pi / 180))
        }
    }
    
    @IBInspectable var flipImage: UIImage? {
        didSet {
            if let image = flipImage,let cgImage = image.cgImage {
                self.image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
            }
        }
    }
    
    private var shouldSetTint : Bool = false
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
            self.layer.masksToBounds = true
         }
    }
    private var imageScaleToUse:Double = 1.0
    @IBInspectable var imageScale: Double = 1.0 {
        didSet {
            self.imageScaleToUse = imageScale
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        //Do not move scaling and tint outside awakeFromNib as Scaling image doesn't takes tint property
        var imageToSet = self.image
        if self.imageScaleToUse != 1.0 {
            if let img = imageToSet {
                let sizeOfOldImage = img.size
                let sizeOfNewImage = CGSize(width: sizeOfOldImage.width * CGFloat(imageScaleToUse), height: sizeOfOldImage.height * CGFloat(imageScaleToUse))
                
                UIGraphicsBeginImageContextWithOptions(sizeOfNewImage, false, 0.0);
                img.draw(in: CGRect(x: 0, y: 0, width: sizeOfNewImage.width, height: sizeOfNewImage.height))
                imageToSet = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            }
        }
        if var imageToSet = imageToSet {
            if self.shouldSetTint {
                imageToSet = imageToSet.withRenderingMode(.alwaysTemplate)
            }
            self.image = imageToSet
        }
    }
    //Set Flip/Mirrored Image.
    public func setFlipImage(flipImage: UIImage?) {
        if let flipImg = flipImage, let cgImg = flipImg.cgImage {
            self.image = UIImage(cgImage: cgImg, scale: flipImg.scale, orientation: UIImage.Orientation.upMirrored)
        }
    }
}
