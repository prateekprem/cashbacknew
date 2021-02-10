//
//  SFRecoTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 28/01/20.
//

import UIKit

class SFCarouselRecoTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleStackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var clubbedImageWrapperView: UIView!
    @IBOutlet weak var clubbedImageWrapperWidth: NSLayoutConstraint!
    @IBOutlet weak var headerSubtitle: UILabel!
    
    var defaultCollectionCellHeight:Double = 108.0
    
    override public class func register(table: UITableView) {
        if let mNib = SFCarouselRecoTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselRecoTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "SFCarouselRecoTableCell" }
    override var collectCellId: String { return "SFCarouselRecoCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFCarouselRecoTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFCarouselRecoCollCell") }
    private var tableIndex = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        self.tableIndex = indexPath
        if let mLayout = self.layout {
            headerLabel.text = mLayout.vTitle
            headerSubtitle.text = mLayout.vSubTitle
            let filteredImages = mLayout.itemImages.filter {
                if let imgUrlString = $0 {
                    return imgUrlString != ""
                }
                return false
            }
            setItemImages(filteredImages)
            if mLayout.isExpanded {
                collectionViewHeight.constant =  CGFloat(defaultCollectionCellHeight * ceil((Double(mList.count) / 3.0)))
                self.clubbedImageWrapperWidth.constant = 0
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping : 0.7,  initialSpringVelocity: 2, options:.curveEaseInOut, animations: {
                    self.clubbedImageWrapperView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.headerView?.layoutIfNeeded()
                },completion: nil)
            } else {
                collectionViewHeight.constant = 1
                var clubbedImageWidth = CGFloat(22 * (filteredImages.count) + 18)
                if filteredImages.count == 0 {
                    clubbedImageWidth = 0
                }
                self.clubbedImageWrapperWidth.constant = clubbedImageWidth
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping : 0.7,  initialSpringVelocity: 2, options:.curveEaseInOut, animations: {
                    self.clubbedImageWrapperView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.headerView?.layoutIfNeeded()
                },completion: nil)            }
        }
    }
    
    private func setItemImages(_ itemImages:[String?]) {
        let clubbedImageSubviews = clubbedImageWrapperView.subviews
        for subview in clubbedImageSubviews {
            subview.removeFromSuperview()
        }
        clubbedImageWrapperWidth.constant = 0
        for i in 0..<itemImages.count {
            let imageView = UIImageView()
            let imgUrl = URL(string: itemImages[itemImages.count - i - 1] ?? "")
            clubbedImageWrapperWidth.constant = CGFloat(22 * (itemImages.count) + 18)
            if imgUrl == nil {
                imageView.image = placeholderImage
            } else {
                imageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
                    
                }
            }
            imageView.frame = CGRect(x: (itemImages.count - i - 1) * 22, y: 0, width: 36, height: 36)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 18
            imageView.layer.backgroundColor = UIColor.white.cgColor
            self.clubbedImageWrapperView.addSubview(imageView)
        }
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let mLayout = self.layout {
            let margin = CGFloat(10)
            let clmCnt = mLayout.cellPresentInfo.collectColomnCount
            let ww = (collectionView.frame.width)/clmCnt
            return CGSize(width: ww - margin, height: CGFloat(defaultCollectionCellHeight))
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let cell = cell as? SFCarouselRecoCollCell {
            cell.layout = self.layout
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.layout?.vItems[indexPath.row]
        item?.isCTAUrlClicked = false
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    @IBAction func viewAllClicked(_ sender: UIButton) {
        guard let layout = self.layout, let delegate = layout.pDelegate else { return }
        layout.isExpanded = !layout.isExpanded
        let rotationAngle:CGFloat = layout.isExpanded ? .pi : 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: rotationAngle)
        })   
        delegate.sfDidClickExpand(layout: layout, indexPath: self.tableIndex)
    }
}
