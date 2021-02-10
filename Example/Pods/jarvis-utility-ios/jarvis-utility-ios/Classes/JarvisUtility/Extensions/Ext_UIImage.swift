//
//  Ext_UIImage.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - Class Methods
    /**
     Method to retrieve image of the given view
     - returns : This method returns UIImage value.
     */
    @objc public class func imageFromView(_ view: UIView) -> UIImage {
        
        beginImageContextWithSize(view.bounds.size)
        let hidden = view.isHidden
        view.isHidden = false
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.isHidden = hidden
        return image!
    }
    
    /**
     Method to retrieve image of the given view with scaling
     - returns : This method returns UIImage value.
     */
    public class func imageFromView(_ view: UIView, scaleToSize newSize: CGSize) -> UIImage {
        var image = imageFromView(view)
        if view.bounds.size.width != newSize.width || view.bounds.size.height != newSize.height {
            image = imageWithImage(image, scaleToSize: newSize)
        }
        return image
    }
    
    
    public class func imageFromView(_ view: UIView, scaleToSize size: CGSize, opacity opaque: Bool, viewScale scale: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     Method to retrieve scaled image from original image
     - returns : This method returns UIImage value.
     */
    public class func imageWithImage(_ image: UIImage, scaleToSize newSize: CGSize) -> UIImage {
        
        beginImageContextWithSize(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    public func resizeImageWith(newSize: CGSize) -> UIImage? {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        if let newImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    public func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    //MARK: fileprivate Section
    fileprivate class func beginImageContextWithSize(_ size: CGSize) {
        
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) && UIScreen.main.scale == 2.0 {
            
            UIGraphicsBeginImageContextWithOptions(size, true, 2.0)
        } else {
            UIGraphicsBeginImageContext(size)
        }
        
    }
    
    public func compressImageData(samplingIndex:Int) -> Data{
        // Reducing file size to a 10th
        
        let image:UIImage = self
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = actualHeight/CGFloat(samplingIndex)
        let maxWidth : CGFloat = actualWidth/CGFloat(samplingIndex)
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1.0
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1.0
            }
        }
        
        let rect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData:Data = img!.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext()
        
        return imageData
        
    }
    
    public class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
    
    // MARK: - UIImage+Resize
    public func compressTo(_ expectedSizeInKB:Int) -> UIImage {
        let sizeInBytes = expectedSizeInKB * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.3
                }
            }
        }
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data) ?? self
            }
        }
        return self
    }

    public func resizeImage(requiredHeight: CGFloat) -> UIImage? {
        let actualHeight: CGFloat = size.height
        let actualWidth: CGFloat = size.width
        let requiredWidth = actualWidth*requiredHeight/actualHeight
        
        let rect = CGRect(x: 0, y: 0, width: requiredWidth, height: requiredHeight)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}
