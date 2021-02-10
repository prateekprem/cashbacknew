//
//  SFRowBs1TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/19.
//

import UIKit

class SFRowBs1TableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak var flashSaleView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    private let maxItemToShowInCollectionView: Int = 8
    private var countdownTimer: Timer?
    private var endDate: String?
    
    override class func register(table: UITableView) {
        if let mNib = SFRowBs1TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRowBs1TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRowBs1TableCell" }
    override var collectCellId: String { return "kSFRowBs1CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRowBs1TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFRowBs1CollCell") }
    
    private var seeAllNib: UINib? { return Bundle.nibWith(name: "SFSeeAllCollCell") }
    private var seeAllCollCellId: String { return "kSFSeeAllCollCell" }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.register(seeAllNib, forCellWithReuseIdentifier: seeAllCollCellId)
        flashSaleView.layer.shadowColor = UIColor.black.cgColor
        flashSaleView.layer.shadowOffset = CGSize(width: 1, height: 2.0)
        flashSaleView.layer.shadowOpacity = 0.3
        flashSaleView.layer.shadowRadius = 4.0
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let endTime = info.vEndTime, !endTime.isEmpty {
            endDate = endTime
            if let _ = getDates() {
                invalidateTimer()
                getRemainingTime()
                calculateTime()
            }
        }else{
            flashSaleView.isHidden = true
            invalidateTimer()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if mList.count > maxItemToShowInCollectionView {
                return maxItemToShowInCollectionView
            }
            
            return mList.count
        }
        else if section == 1 {
            if let isValidUrl = layout?.vSeeAllSeoUrl.isValidString(), isValidUrl {
                return 1
            }
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seeAllCollCellId, for: indexPath) as? SFSeeAllCollCell {
                return cell
            }
        }
        return SFBaseCollCell()
    }
    
    override func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: 108 , height: collectionView.frame.size.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
        else {
            guard let mLayout = self.layout else { return }
            
            guard let delegate = mLayout.pDelegate else { return }
            delegate.sfDidClickViewAll(mLayout)
        }
    }
}

//MARK: Private Methods
extension SFRowBs1TableCell {
    private func getRemainingTime() {
        guard let _ =  getDates() else{
            return
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calculateTime), userInfo: nil, repeats: true)
        flashSaleView.isHidden = false
    }
    
    @objc private func calculateTime() {
        guard let dates =  getDates() else{
            return
        }
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: dates.1, to: dates.0)
        if let hour = difference.hour, let minute = difference.minute, let second = difference.second {
            timeLabel.text = String(format: "%02d : %02d : %02d", hour, minute, second)
        }
    }
    
    private func invalidateTimer() {
        if let timer = countdownTimer {
            timer.invalidate()
            countdownTimer = nil
        }
    }
    
    
    private func getDates()-> (Date, Date)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int, let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                if let endDate = endDate, let endDateFormat = dateFormatter.date(from: endDate){
                    if endDateFormat > date {
                        return(endDateFormat, date)
                    }
                    else {
                        flashSaleView.isHidden = true
                        invalidateTimer()
                    }
                }
            }
        return nil
    }
}
