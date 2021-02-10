//
//  PBScrolTabs.swift
//  BusinessApp
//
//  Created by Prakash Jha on 18/01/19.
//  Copyright © 2019 PayTm. All rights reserved.
//
/*
 Use --
 let headTabsV = JRCOScrolTabs.tabVWith(fr: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
 headTabsV.setList(titles: ["Home", "Offers", "Help"])
 */

import UIKit

protocol JRCOScrolTabsDelegate: class {
    func jrScrolTabsDidSelectItem(at: Int)
}

extension JRCOScrolTabsDelegate {
    func jrScrolTabsDidSelectItem(at: Int) {}
}

class JRCOScrolTabs: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak private var collectV : UICollectionView!
    var delegate: JRCOScrolTabsDelegate?
   
    private var selectedIndex = 0
    private var list = [JRCOScrolTabDataModel]()
    
    func setList(titles: [String]) {
        list.removeAll()
        for ttl in titles {
            list.append(JRCOScrolTabDataModel(ttl: ttl))
        }
    }
    
    class func tabVWith(fr: CGRect) -> JRCOScrolTabs {
        let nib = Bundle.cbBundle.loadNibNamed("JRCOScrolTabs", owner: self, options: nil)
        let header = nib![0] as! JRCOScrolTabs
        header.frame = fr
        header.innovate()
        return header
    }
    
    func innovate() {
        collectV.backgroundColor = UIColor.clear
        collectV.register(JRCOScrolTabCollectCell.mNib, forCellWithReuseIdentifier: "kJRCOScrolTabCollectCell")
    }
    
    func refresh() {
        collectV.reloadData()
    }
    
    func makeSelected(index: Int, shouldDelay: Bool) {
        if index == self.selectedIndex { return }
        
        selectedIndex = index
        collectV.reloadData()
        
        if shouldDelay {
            self.perform(#selector(self.scrollToSelected), with: nil, afterDelay: 0.05)
        } else {
            self.scrollToSelected()
        }
    }
    
    @objc func scrollToSelected() {
        if selectedIndex >= 0 {
            let indxP = IndexPath(row: selectedIndex, section: 0)
            collectV.scrollToItem(at: indxP, at:.centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kJRCOScrolTabCollectCell", for: indexPath) as! JRCOScrolTabCollectCell
        cell.show(title: list[indexPath.row].title, selected: selectedIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: list[indexPath.row].width+20, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      self.makeSelected(index: indexPath.row, shouldDelay: false)
        delegate?.jrScrolTabsDidSelectItem(at: indexPath.row)
    }
}
