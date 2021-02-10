//
//  SFBaseInfiniteCollCell.swift
//  jarvis-storefront-ios
//
//  Created by Samar Gupta on 20/06/20.
//

import UIKit

class SFBaseInfiniteCollCell: SFBaseTableCellIncCollection {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isInfiniteScrollType = true
    }
    
    func modifyDatasourceForCircularScroll() {
        if mList.count == 1 {
            return
        }
        let firstElement = mList.first
        let lastElement = mList.last
        if let firstEl = firstElement, let lastEl = lastElement {
            mList.insert(lastEl,at: 0)
            mList.insert(firstEl,at: mList.endIndex)
        }
    }
    
    func setupForInfiniteScrolling() {
        if mList.count > 1   { //circular case
            DispatchQueue.main.async( execute: {
                if self.currentPage == 0 {
                    self.didScrollTo(1, animated: false)
                }
                else {
                    self.didScrollTo(self.currentPage+1, animated: false)
                }
            })
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width
        if mList.count > 1 { //case for circular infinte scroll
            let regularContentOffset = pageWidth * CGFloat(mList.count - 2)
            if (scrollView.contentOffset.x >= pageWidth * CGFloat(mList.count - 1)) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - regularContentOffset, y: 0.0)
            } else if (scrollView.contentOffset.x < pageWidth) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + regularContentOffset, y: 0.0)
            }
        }

        let numberOfCells = mList.count
        let page = Int(scrollView.contentOffset.x) / Int(pageWidth)
        if page == 0 { // we are within the fake last, so delegate real last
            self.currentPage = numberOfCells - 1
        } else if page == numberOfCells - 1 { // we are within the fake first, so delegate the real first
            self.currentPage = 0
        } else { // real page is always fake minus one
            self.currentPage = page - 1
        }
    }
    
    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pauseResumeAutoScroll(isResume: false)
    }
}

