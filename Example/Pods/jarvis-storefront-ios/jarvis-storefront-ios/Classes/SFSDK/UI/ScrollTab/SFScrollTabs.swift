//
//  SFScrollTabs.swift
//  BusinessApp
//
//  Created by Prakash Jha on 18/01/19.
//  Copyright © 2019 PayTm. All rights reserved.
//
/*
 Use --
 let headTabsV = SFScrollTabs.tabVWith(fr: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
 headTabsV.setList(titles: ["Home", "Offers", "Help"])
 */

import UIKit

public protocol SFScrollTabsDelegate: class {
    func jrScrolTabsDidSelectItem(at: Int)
}

extension SFScrollTabsDelegate {
    func jrScrolTabsDidSelectItem(at: Int) {}
}

public class SFScrollTabs: UIView {

    @IBOutlet weak private var collectV : UICollectionView!
    public var delegate: SFScrollTabsDelegate?
   
    private var selectedIndex = 0
    private var list = [SFScrolTabDataModel]()
    
    public func setList(titles: [String]) {
        list.removeAll()
        var ww = CGFloat(0)
        for ttl in titles {
            let info = SFScrolTabDataModel(ttl: ttl)
            list.append(info)
            ww = ww + info.width
        }
        
        let deltaW = self.frame.width - ww
        if deltaW > 0 {
            let wD = deltaW/CGFloat(list.count)
            for info in list {
                info.increaseWidth(by: wD)
            }
        }
        
        collectV.reloadData()
        self.roundCorners([.topLeft,.topRight], radius: 7)
    }
    
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        innovate()
    }
    
    public class func tabVWith(fr: CGRect) -> SFScrollTabs {
        let vv: SFScrollTabs = Bundle.nibWith(name: "SFScrollTabs")?.instantiate(withOwner: nil, options: nil)[0] as! SFScrollTabs
        vv.frame = fr
        vv.layoutIfNeeded()
        return vv
    }
    
    func innovate() {
        collectV.backgroundColor = UIColor.clear
        collectV.register(SFScrollTabsCollectCell.mNib, forCellWithReuseIdentifier: "kSFScrollTabsCollectCell")
    }
    
    func refresh() {
        collectV.reloadData()
    }
    
    @objc func scrollToSelected() {
        if selectedIndex >= 0 {
            let indxP = IndexPath(row: selectedIndex, section: 0)
            collectV.scrollToItem(at: indxP, at:.centeredHorizontally, animated: true)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension SFScrollTabs: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSFScrollTabsCollectCell", for: indexPath) as! SFScrollTabsCollectCell
        cell.show(title: list[indexPath.row].title, selected: selectedIndex == indexPath.row)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: list[indexPath.row].width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     // self.makeSelected(index: indexPath.row, shouldDelay: false)
        delegate?.jrScrolTabsDidSelectItem(at: indexPath.row)
    }
}


