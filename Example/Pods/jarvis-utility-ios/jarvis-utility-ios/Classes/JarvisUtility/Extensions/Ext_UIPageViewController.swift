//
//  Ext_UIPageViewController.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIPageViewController {

    //MARK: Instance Methods
    /**
     Method to setViewCOntroller with completion block
     */
    @objc public func setViewControllers(_ viewControllers: [UIViewController], direction: UIPageViewController.NavigationDirection, invalidateCache: Bool ,  animated: Bool, completion : ((_ finished: Bool) -> Void)?) {
        let vcs: [UIViewController] = viewControllers
        if invalidateCache && transitionStyle == .scroll {
            
            let controller: UIViewController? = (direction == .forward) ? dataSource?.pageViewController(self, viewControllerBefore: viewControllers[0]) : dataSource?.pageViewController(self, viewControllerAfter: viewControllers[0])
            if let neighborViewController = controller {
                
                setViewControllers([neighborViewController], direction: direction, animated: false, completion: {[weak self] (finished: Bool) -> Void in
                    self?.setViewControllers(vcs, direction: direction, animated: animated, completion: completion)
                })
            } else {
                setViewControllers(vcs, direction: direction, animated: animated, completion: completion)
            }
        } else {
            setViewControllers(vcs, direction: direction, animated: animated, completion: completion)
        }
    }
    
}
