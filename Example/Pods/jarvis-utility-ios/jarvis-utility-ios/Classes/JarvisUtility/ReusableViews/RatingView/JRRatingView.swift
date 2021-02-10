//
//  JRRatingView.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 05/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

let MAX_RATING: Float = 5.0

@objc public protocol JRRatingViewDelegate: class {
    
    func updateViewOnChangingRating(_ rating: Float)
}

/**
 UIImageView that creates and hold an image for the required rating.
 */
open class JRRatingView: UIImageView {

    fileprivate var mRating: Float = 0.0
    fileprivate var ratingImageCache: NSCache<AnyObject, AnyObject>?
    fileprivate let JRSteppingInterval: Float = 1.0
    
    weak open var delegate: JRRatingViewDelegate?

    /**
    Creates an image for the sent inRating value
    - parameter inRating : rating value
    */
    @objc open func setRating(_ inRating: Float) {
        
        let newRating = floorf(inRating)
        let fraction = (inRating - newRating)
        
        if fraction == 0 {
            
            mRating = newRating
        } else if fraction > 0.5 {
            
            mRating = newRating + 1.0
        } else {
            
            mRating = newRating + 0.5
        }
        
        if mRating > MAX_RATING {
            mRating = MAX_RATING
        }
        
        contentMode = UIView.ContentMode.scaleAspectFit
        image = generateImageForRating(mRating)
    }
    
    
    // MARK: - Editable rating view methods
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let location = touch.location(in: self)
            updateStarRatings(location)
        }
    }
}


fileprivate extension JRRatingView {
    
    func generateImageForRating(_ inRating: Float) -> UIImage {
        
        if ratingImageCache == nil {
            
            ratingImageCache = NSCache.init()
            ratingImageCache?.countLimit = 40
        }
        
        if let cachedImage = ratingImageCache?.object(forKey: inRating as AnyObject) {
            return cachedImage as! UIImage
        }
        
        let grayImage = UIImage.init(named: "star_empty")
        let yellowImage = UIImage.init(named: "star_filled")
        let combineImage = UIImage.init(named: "star_half_filled")
        
        let size = grayImage?.size
        
        var imageSize = size
        imageSize?.width *= 5
        
        UIGraphicsBeginImageContext(imageSize!)
        
        let rating = floorf(mRating)
        for index in 0...4 {
            
            let dx = CGFloat(index) * size!.width
            let rect = CGRect(x: dx, y: 0.0, width: size!.width, height: size!.height)
            grayImage?.draw(in: rect)
            
            if Float(index) < rating {
                
                yellowImage?.draw(in: rect)
            }
        }
        
        if mRating > rating {
            
            let dx = CGFloat(rating) * size!.width
            let rect = CGRect(x: dx, y: 0.0, width: size!.width, height: size!.height)
            combineImage?.draw(in: rect)
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ratingImageCache?.setObject(resultImage!, forKey: inRating as AnyObject)
        return resultImage!
    }
    
    
    func updateStarRatings(_ location: CGPoint) {
        
        var value = Float(location.x) / (Float(30.0) * Float(5.0)) * Float(5.0)
        value = max(0, ceilf(value / JRSteppingInterval) * JRSteppingInterval)
        
        if let delegate = delegate {
            
            setRating(value)
            delegate.updateViewOnChangingRating(value)
        }
    }
}
