//
//  Ext_UISegmentedControl.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UISegmentedControl {

    public func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1.0),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .medium)], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 1/255, green: 43/255, blue: 114/255, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .medium)], for: .selected)
    }
    
    public func removeBorders_v2() {
        if let bgColor = backgroundColor , let img = imageWithColor(color: bgColor) {
            setBackgroundImage(img, for: .normal, barMetrics: .default)
        }
        if let tColor = tintColor , let img = imageWithColor(color: tColor) {
            setBackgroundImage(img, for: .selected, barMetrics: .default)
        }
        if let img = imageWithColor(color: UIColor.clear) {
            setDividerImage(img, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }
    }
    
}

private extension UISegmentedControl{
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
}
