//
//  SFH1StoreBannerView.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 17/12/19.
//

import UIKit

public class SFH1StoreBannerView: UIView {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var reviewsButton: UIButton!
    @IBOutlet private weak var viewStoreButton: UIButton!
    @IBOutlet private weak var followButton: UIButton!
    @IBOutlet private weak var logoImageWidthConstraint: NSLayoutConstraint!
    
    public var backActionHandler: (() -> Void)?
    public var reviewsActionHandler: (() -> Void)?
    public var storesActionHandler: (() -> Void)?
    
    private var bannerInfo: SFLayoutViewInfo?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguration()
    }
    
    public static func loadH1StoreBannerView() -> SFH1StoreBannerView {
        return Bundle.sfBundle.loadNibNamed("SFH1StoreBannerView", owner: self, options: nil)?.last as! SFH1StoreBannerView
    }
    
    // MARK: Public Methods
    
    public func configureView(_ layoutInfo: SFLayoutViewInfo?) {
        bannerInfo = layoutInfo
        let storeInfo: SFStoreInfo? = layoutInfo?.storeInfo
        if let imUrlString = storeInfo?.coverPic, let imgURL = URL(string: imUrlString) {
            bannerImageView.setImageFrom(url: imgURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
        
        if let imUrlString = storeInfo?.logoUrl, let imgURL = URL(string: imUrlString) {
            logoImageWidthConstraint.constant = 42
            logoImageView.setImageFrom(url: imgURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
        else {
            logoImageWidthConstraint.constant = 0
        }
        
        nameLabel.text = storeInfo?.name
        
        let ratingReviewsInfo: SFReviewRatingInfo? = layoutInfo?.reviewRatingInfo
        if let rating = ratingReviewsInfo?.avgRating {
            ratingView.isHidden = false
            ratingLabel.text = "\(rating.cleanValue)"
        }
        else {
            ratingView.isHidden = true
        }
        
        if let reviews = ratingReviewsInfo?.totalReviews, reviews > 0 {
            let reviewText = "\(reviews) Review\(reviews > 1 ? "s" : "")"
            let attributedText = underlineText(reviewText)
            reviewsButton.setAttributedTitle(attributedText, for: .normal)
            reviewsButton.isHidden = false
        }
        else {
            reviewsButton.setTitle("", for: .normal)
            reviewsButton.isHidden = true
        }
        
        if let seeAllStoresUrl = storeInfo?.seeAllStoresUrl, seeAllStoresUrl.isValidString() {
            viewStoreButton.isHidden = false
            let title = underlineText("View All Stores")
            viewStoreButton.setAttributedTitle(title, for: .normal)
        }
        else {
            viewStoreButton.isHidden = true
        }
        
        if let isFollowing = storeInfo?.isFollowing {
            configureFollowButton(isFollowing)
        }
    }
    
    public func configureViewForSearchController() {
        viewStoreButton.isHidden = true
        followButton.isHidden = true
        reviewsButton.isHidden = true
    }
    
    // MARK: Private Methods
    func doInitialConfiguration() {
        ratingView.layer.cornerRadius = ratingView.frame.size.height / 2
        followButton.layer.cornerRadius = followButton.frame.size.height / 2
    }
    
    private func configureFollowButton(_ isFollowing: Bool) {
        if isFollowing {
            followButton.backgroundColor = UIColor.paytmBlueColor()
            followButton.setTitleColor(UIColor.white, for: .normal)
            followButton.setTitle("Following", for: .normal)
        }
        else {
            followButton.backgroundColor = UIColor.white
            followButton.setTitleColor(UIColor.paytmBlueColor(), for: .normal)
            followButton.setTitle("Follow", for: .normal)
        }
    }
    
    private func underlineText(_ string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    @IBAction private func backButtonClicked(_ sender: UIButton) {
        backActionHandler?()
    }
    
    @IBAction private func reviewsClicked(_ sender: UIButton) {
        reviewsActionHandler?()
    }
    
    @IBAction private func viewAllStoresClicked(_ sender: UIButton) {
        storesActionHandler?()
    }
    
    @IBAction private func followButtonCliked(_ sender: UIButton) {
        guard let isFollowing = bannerInfo?.storeInfo?.isFollowing else {
            return
        }
        sender.isUserInteractionEnabled = false
        bannerInfo?.pDelegate?.followUnfollow(!isFollowing, completionHandler: { [weak self] (success) in
            sender.isUserInteractionEnabled = true
            if success {
                let following = !isFollowing
                self?.bannerInfo?.storeInfo?.isFollowing = following
                self?.configureFollowButton(following)
            }
        })
    }
}
