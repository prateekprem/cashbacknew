//
//  FSFeedTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSFeedTableCell: SFBaseTableCell {
    
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var brandDescription: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var feedView: UIView!
    
    private var firstItem: SFLayoutItem?
    private var currentIndex: IndexPath?
    override class func register(table: UITableView) {
        if let mNib = FSFeedTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSFeedTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSFeedTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "FSFeedTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.feedView.layer.borderColor = UIColor(red:230/255, green:230/255, blue:230/255, alpha: 1).cgColor
        feedView.layer.shadowColor = UIColor(red: 0.896, green: 0.896, blue: 0.896, alpha: 0.5).cgColor
        feedView.layer.shadowOpacity = 1
        feedView.layer.shadowOffset = CGSize(width: 0, height: 7)
        feedView.layer.shadowRadius = 16
        followBtn.layer.borderColor = #colorLiteral(red: 0, green: 0.7254901961, blue: 0.9607843137, alpha: 1)
        followBtn.setTitleColor(#colorLiteral(red: 0, green: 0.7254901961, blue: 0.9607843137, alpha: 1), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        currentIndex = indexPath
        guard let count = layout?.vItems.count, count >= indexPath.row else {
            return
        }
        firstItem = layout?.vItems[indexPath.row]
        logImpressionForItem(item: firstItem)
        brandName.text = firstItem?.itemName
        title.text = firstItem?.itemTitle
        brandDescription.text = firstItem?.feedDescription
        if let firstItem = firstItem, let mURL = URL(string: firstItem.itemImageUrl), feedImage != nil {
            self.feedImage.setImageFrom(url: mURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
        if let firstItem = firstItem, let mURL = URL(string: firstItem.itemLogoUrl), brandImage != nil {
            self.brandImage.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        if let firstItem = firstItem {
            likeBtn.isSelected = firstItem.isLike
            likeCount.text = String(firstItem.likeCount)
            if firstItem.isLike {
                likeBtn.isSelected = true
            }else {
                likeBtn.isSelected = false
            }
            if firstItem.isFollowing {
                followBtn.setTitle("Unfollow", for: .normal)
            }else {
                followBtn.setTitle("Follow", for: .normal)
            }
        }
        if let activeFrom = firstItem?.activeFrom {
            time.text = calculateTime(activeFrom)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        action(type: FeedAction.Like)
    }
    @IBAction func followAction(_ sender: Any) {
        action(type: FeedAction.Follow)
    }
    @IBAction func shareAction(_ sender: Any) {
        action(type: FeedAction.Share)
    }
    
    // Private Methods
    private func action(type: FeedAction) {
        guard let mLayout = self.layout else { return }
        
        guard let delegate = mLayout.pDelegate else { return }
        if let firstItem = firstItem, let index = currentIndex {
            delegate.sfFeedItemClicked(item: firstItem, actionType: type, indexPath: index)
        }
    }
}

public enum FeedAction {
    case Like
    case Follow
    case Share
}

extension FSFeedTableCell {
    
    func getDates(_ validUptoDate: String)-> (Date, Date)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000+0000"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let currentDate = dateFormatter.string(from: Date())
       if let validDateFormat = dateFormatter.date(from: validUptoDate), let currentDateFormat = dateFormatter.date(from: currentDate){
                return(validDateFormat, currentDateFormat)
        }
        return nil
    }
    
    func calculateTime(_ validUptoDate: String) -> String {
        guard let dates =  getDates(validUptoDate) else{
            return ""
        }
        let difference = Calendar.current.dateComponents([.weekday, .day, .hour, .minute, .second], from: dates.0, to: dates.1)
        if let weeks = difference.weekday, let days = difference.day, let hours = difference.hour, let min = difference.minute, let sec = difference.second{
            var timeAgo = ""
            
            if (sec > 0){
                if (sec > 1) {
                    timeAgo = "\(sec) Seconds Ago"
                } else {
                    timeAgo = "\(sec) Second Ago"
                }
            }

            if (min > 0){
                if (min > 1) {
                    timeAgo = "\(min) Minutes Ago"
                } else {
                    timeAgo = "\(min) Minute Ago"
                }
            }

            if(hours > 0){
                if (hours > 1) {
                    timeAgo = "\(hours) Hours Ago"
                } else {
                    timeAgo = "\(hours) Hour Ago"
                }
            }

            if (days > 0) {
                if (days > 1) {
                    timeAgo = "\(days) Days Ago"
                } else {
                    timeAgo = "\(days) Day Ago"
                }
            }

            if(weeks > 0){
                if (weeks > 1) {
                    timeAgo = "\(weeks) Weeks Ago"
                } else {
                    timeAgo = "\(weeks) Week Ago"
                }
            }
            return timeAgo
        }
         return ""
    }
}
