//
//  Ext_UICollectionView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public protocol ReusableView: class {}

public extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

@objc public protocol NibLoadableView: class { }

public extension NibLoadableView where Self: UIView {
    
    static var NibName: String {
        return String(describing: self)
    }
}

extension UICollectionView {

    public func scrollToIndexpathByShowingHeader(_ indexPath: IndexPath) {
        let sections = self.numberOfSections
        
        if indexPath.section <= sections{
            
            let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            let topOfHeader = CGPoint(x: 0, y: attributes!.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }

    
    public func scrollToIndexpathBelowHeader(_ indexPath: IndexPath, shouldStickHeaderView: Bool) {
        let sections = self.numberOfSections
        
        if indexPath.section <= sections{
            let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            let topOfHeader = CGPoint(x: 0, y: attributes!.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type, _ bundle : Bundle? = nil) where T: ReusableView, T: NibLoadableView {
        
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier:T.reuseIdentifier , for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
}
