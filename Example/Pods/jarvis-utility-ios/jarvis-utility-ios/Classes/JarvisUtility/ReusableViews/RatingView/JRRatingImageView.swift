//
//  JRRatingImageView.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 14/03/17.
//  Copyright © 2017 One97. All rights reserved.
//

import UIKit

open class JRRatingImageView: UIImageView {
    
    open var maxRating: Int = 5
    fileprivate var mRating: Float = 0.0
    fileprivate var ratingImageCache: NSCache<AnyObject, AnyObject>?
    
    open var grayImage:UIImage?
    open var yellowImage:UIImage?
    open var combineImage:UIImage?
    open var isLeftAligned: Bool = true
    
    
    /**
     Creates an image for the sent inRating value
     - parameter inRating : rating value
     */
    open func setRating(_ inRating: Float) {
        
        let newRating = floorf(inRating)
        let fraction = (inRating - newRating)
        
        if fraction == 0 {
            
            mRating = newRating
        } else if fraction > 0.5 {
            
            mRating = newRating + 1.0
        } else {
            
            mRating = newRating + 0.5
        }
        
        if mRating > Float(maxRating) {
            mRating = Float(maxRating)
        }
        
        contentMode = UIView.ContentMode.scaleAspectFit
        image = generateImageForRating(mRating)
        
        if !isLeftAligned {
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
    }
}


fileprivate extension JRRatingImageView {
    
    func generateImageForRating(_ inRating: Float) -> UIImage? {
        
        if ratingImageCache == nil {
            
            ratingImageCache = NSCache.init()
            ratingImageCache?.countLimit = 40
        }
        
        if let cachedImage = ratingImageCache?.object(forKey: inRating as AnyObject) {
            return cachedImage as? UIImage
        }
        
        if let size = yellowImage?.size {
            
            var imageSize = size
            imageSize.width *= CGFloat(maxRating)
            imageSize.width += CGFloat(maxRating * 2)
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            
            let rating = floorf(mRating)
            for index in 0..<maxRating {
                
                let dx = CGFloat(index) * (size.width + 2)
                let rect = CGRect(x: dx, y: 0.0, width: size.width, height: size.height)
                grayImage?.draw(in: rect)
                
                if Float(index) < rating {
                    
                    yellowImage?.draw(in: rect)
                }
            }
            
            if mRating > rating {
                
                let dx = CGFloat(rating) * (size.width + 2)
                let rect = CGRect(x: dx, y: 0.0, width: size.width, height: size.height)
                combineImage?.draw(in: rect)
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let resultImage = resultImage {
                
                ratingImageCache?.setObject(resultImage, forKey: inRating as AnyObject)
                return resultImage
            }
        }
        return nil
    }
}
