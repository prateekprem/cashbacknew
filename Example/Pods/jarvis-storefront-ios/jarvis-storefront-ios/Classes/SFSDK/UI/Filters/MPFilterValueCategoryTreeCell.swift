//
//  MPFilterValueCategoryTreeCell.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 24/07/19.
//

import UIKit

class MPFilterValueCategoryTreeCell: UITableViewCell {
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var appliedButton: UIButton!
    private var showCross:Bool = false
    private var selectedTreeNode:SFFilterTreeCategoryNode?
    var crossClickedblock:((SFFilterTreeCategoryNode) -> ())?
    
    func configureCell(treeNode:SFFilterTreeCategoryNode?, filter: SFFilter){
        
        selectedTreeNode = treeNode
        title.textColor = UIColor.getColorFromHexValue(0x506D85, Alpha: 1.0)
        if let treeNode = treeNode {
            if let count  = treeNode.catCount {
                countLabel.text = String(describing: count)
                countLabel.isHidden = false
            }else {
                countLabel.isHidden = true
            }
            title.text = treeNode.catName
            title.font = UIFont.fontSemiBoldOf(size: 12.0)
            if treeNode.showCross == true {
                appliedButton.setImage(UIImage.imageNamed(name: "blueCross"), for: .normal)
                title.textColor = UIColor.black
                title.font = UIFont.fontSemiBoldOf(size: 12.0)
                countLabel.isHidden = true
            }else  {
                appliedButton.setImage(UIImage.imageNamed(name: "disabledTick"), for: .normal)
            }
            if treeNode.isSelected  {
                title.textColor = UIColor.black
                title.font = UIFont.fontSemiBoldOf(size: 12.0)
                if treeNode.isLeafNode {
                    appliedButton.setImage(UIImage.imageNamed(name: "enabledTick"), for: .normal)
                }
            }
            countLabel.font = title.font
        }
    }
    
    @IBAction func crossTapped(_ sender: Any) {
        var navigateToParent = false
        if let node = selectedTreeNode , let count  = node.parent?.children.count, count > 1{
            navigateToParent = true
        }
        if let node = selectedTreeNode, node.catParentID != nil {
            navigateToParent = true
        }
        if navigateToParent {
            crossClickedblock?(selectedTreeNode!)
        }
    }
}
