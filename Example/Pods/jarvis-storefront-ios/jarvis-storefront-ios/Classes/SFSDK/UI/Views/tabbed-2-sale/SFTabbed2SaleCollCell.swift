//
//  SFTabbed2SaleTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 19/12/19.
//

import UIKit

class SFTabbed2SaleCollCell: SFBaseCollCell {
    
    @IBOutlet private weak var titleLabel   :UILabel!
    @IBOutlet private weak var timerLabel   :UILabel!
    @IBOutlet private weak var bgView       :UIView!
    @IBOutlet private weak var topImageView :UIImageView!
    private var timer: Timer?
    private var counter = 0
    
    private var hours: String {
        let hours = counter/3600
        if hours >= 10 {
            return "\(hours)"
        }
        else {
            return "0\(hours)"
        }
    }
    private var minutes: String {
        let minutes = (counter % 3600)/60
        if minutes >= 10 {
            return "\(minutes)"
        }
        else {
            return "0\(minutes)"
        }
    }
    private var seconds: String {
        let seconds = (counter % 3600) % 60
        if seconds >= 10 {
            return "\(seconds)"
        }
        else {
            return "0\(seconds)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        timerLabel.text = item.itemName
    }
    
    func configureViews(with item: SFLayoutItem) {
        bgView.layer.cornerRadius = 3.0
        bgView.layer.masksToBounds = true
        bgView.layer.borderWidth = 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
            if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                
                if let startTimeStr = item.startTime, let endTimeStr = item.endTime {
                    if  let startTime = dateFormatter.date(from: startTimeStr), let endTime = dateFormatter.date(from: endTimeStr) {
                        if date > endTime {
                            timerLabel.font = UIFont.fontSemiBoldOf(size: 12.0)
                            timerLabel.textColor = UIColor(red: 29/255, green: 37/255, blue: 45/255, alpha: 1)
                            topImageView.isHidden = true
                            titleLabel.text = "End Sale"
                            timerLabel.text = "00 : 00"
                        } else if date < startTime && date < endTime {
                            timerLabel.font = UIFont.fontSemiBoldOf(size: 12.0)
                            timerLabel.textColor = UIColor(red: 29/255, green: 37/255, blue: 45/255, alpha: 1)
                            if Calendar.current.isDateInToday(startTime) {
                                titleLabel.text = "Coming Soon"
                            } else if Calendar.current.isDateInTomorrow(startTime) {
                                titleLabel.text = "Tomorrow"
                            } else {
                                dateFormatter.dateFormat = "EEEE"
                                titleLabel.text = dateFormatter.string(from: startTime)
                            }
                            topImageView.isHidden = true
                            dateFormatter.dateFormat = "h:mm a"
                            timerLabel.text = dateFormatter.string(from: startTime)
                        } else if date > startTime && date <= endTime {
                            titleLabel.text = "Sale Ends In"
                            
                            
                            let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                            if let second = difference.second {
                                counter = second
                                timerLabel.text = "\(hours) : \(minutes) : \(seconds)"
                            }
                            topImageView.isHidden = false
                            timerLabel.font = UIFont.fontSemiBoldOf(size: 12.0)
                            timerLabel.textColor = UIColor(red: 255/255, green: 88/255, blue: 93/255, alpha: 1)
                            getTimer(startTime: startTime, endTime: endTime) { [weak self] (data) in
                                self?.timerLabel.text = data
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didSelectedCell() {
        bgView.layer.borderColor = UIColor(red: 0/255, green: 172/255, blue: 237/255, alpha: 0.8).cgColor
        bgView.backgroundColor = UIColor(red: 233/255, green: 246/255, blue: 253/255, alpha: 1)

        titleLabel.font = UIFont.fontSemiBoldOf(size: 10.0)
        titleLabel.textColor = UIColor(red: 80/255, green: 109/255, blue: 133/255, alpha: 1)
    }
    
    func didUnSelectCell() {
        bgView.layer.borderColor = UIColor(red: 221/255, green: 229/255, blue: 237/255, alpha: 0.8).cgColor
        bgView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
   
        titleLabel.font = UIFont.fontSemiBoldOf(size: 10.0)
        titleLabel.textColor = UIColor(red: 80/255, green: 109/255, blue: 133/255, alpha: 1)
    }
    
    private func startTimer(startTime: Date, endTime: Date, result: ((String) -> ())?) {
        removeTimerIfAny()
        if timer == nil {
            if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
                if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                    let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                    counter = difference.second!
                    timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                        self.counter-=1
                        if self.counter <= 0 {
                            self.timer?.invalidate()
                            self.timer = nil
                        }else{
                            result?("\(self.hours) : \(self.minutes) : \(self.seconds)")
                        }
                        
                    })
                }else {
                   removeTimerIfAny()
                }
            }
        }
    }
    
    private func getTimer(startTime: Date, endTime: Date, result: ((String) -> ())?){
        startTimer(startTime: startTime, endTime: endTime,  result: { data in
            result?(data)
        })
    }
    
    func removeTimerIfAny() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}
