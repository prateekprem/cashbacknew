//
//  Ext_UITableView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell>(_: T.Type, inBundle bundle : Bundle? = nil) where T: ReusableView, T: NibLoadableView {
        
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: NSIndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    public var isTableHeaderViewVisible: Bool {
        guard let tableHeaderView = tableHeaderView else {
            return false
        }
        
        let currentYOffset = self.contentOffset.y;
        let headerHeight = tableHeaderView.frame.size.height;
        
        return currentYOffset < headerHeight
    }
    
    public var indexesOfVisibleSections: [Int] {
        // Note: We can't just use indexPathsForVisibleRows, since it won't return index paths for empty sections.
        var visibleSectionIndexes = [Int]()
        
        for i in 0..<numberOfSections {
            var headerRect: CGRect?
            // In plain style, the section headers are floating on the top, so the section header is visible if any part of the section's rect is still visible.
            // In grouped style, the section headers are not floating, so the section header is only visible if it's actualy rect is visible.
            if (self.style == .plain) {
                headerRect = rect(forSection: i)
            } else {
                headerRect = rectForHeader(inSection: i)
            }
            if headerRect != nil {
                // The "visible part" of the tableView is based on the content offset and the tableView's size.
                let visiblePartOfTableView: CGRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: bounds.size.width, height: bounds.size.height)
                if (visiblePartOfTableView.intersects(headerRect!)) {
                    visibleSectionIndexes.append(i)
                }
            }
        }
        return visibleSectionIndexes
    }
    
    public var visibleSectionHeaders: [UITableViewHeaderFooterView] {
        var visibleSects = [UITableViewHeaderFooterView]()
        for sectionIndex in indexesOfVisibleSections {
            if let sectionHeader = headerView(forSection: sectionIndex) {
                visibleSects.append(sectionHeader)
            }
        }
        return visibleSects
    }
    
}
