//
//  JRCOUtils.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 05/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

class JRCOUtils {
    static func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView,
                               lineWidth: CGFloat, lineDashPattern: [NSNumber], lineColor: CGColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = lineColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.frame = view.bounds
        let path = CGMutablePath()
        path.move(to: p0)
        path.addLine(to: p1)
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
        view.clipsToBounds = true
    }
    
    static func dropShadow(view: UIView, rect: CGRect, color: UIColor) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2
    }
    
    class func getDateForDealsAndCrossPromo(inputDate : String) -> String {
        let monthArray:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let inputArray = inputDate.components(separatedBy: "/")
        if inputArray.count > 1 {
            let month    = inputArray[1]
            if let  monthInt = Int(month), monthInt > 0, monthInt <= monthArray.count  {
                return "\(inputArray[0]) \(monthArray[monthInt-1]) \(inputArray[2])"
            }
        }
        return inputDate
    }
    
    class func getDateForDeal(inputDate : String) -> String {
        let monthArray:[String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let inputArray = inputDate.components(separatedBy: "/")
        if inputArray.count > 1 {
            let month    = inputArray[1]
            if let  monthInt = Int(month), monthInt > 0, monthInt <= monthArray.count  {
                return "\(inputArray[0]) \(monthArray[monthInt-1])"
            }
        }
        return inputDate
    }
}

// MARK: Enums
enum FilterSelectionType {
    case MultiSelect
    case SingleSelect
}

enum VoucherStatus {
    case active
    case expired
    case expiringSoon
    case used
    case invalid
    
    var statusId : String {
        switch self {
        case .active: return "1"
        case .expired: return "2"
        case .expiringSoon: return ""
        case .used: return "0"
        case .invalid: return "3"
        }
    }
    
    var statusTitle: String {
        switch self {
        case .active: return "Active"
        case .expired: return "Expired"
        case .expiringSoon: return "Expiring Soon"
        case .used: return "Used"
        case .invalid: return "Inactive"
        }
    }
}

enum SortingStyle: String{
    case normal = "validUpto,asc"
    case createdAt = "createdAt,Desc"
    case none = ""
}

extension UIColor {
    static let cashbackRed = UIColor(red: 253/255, green: 92/255, blue: 92/255, alpha: 1.0)
    static let cashbackYellow = UIColor(red: 255/255, green: 164/255, blue: 0/255, alpha: 1.0)
    static let cashbackSkyBlue = UIColor(red: 0/255, green: 185/255, blue: 245/255, alpha: 1.0)
    static let cashbackSkyBlueA30 = UIColor(red: 0/255, green: 185/255, blue: 245/255, alpha: 0.30)
    static let cashbackGrey = UIColor(red: 226/255, green: 235/255, blue: 238/255, alpha: 1.0)
    static let cashbackBlackA10 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.10)
    static let cashbacklightBlack = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
    static let cashbacklightBlackA30 = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.30)
    static let cashbackGreen = UIColor(red:9/255 , green: 172/255, blue: 99/255, alpha: 1.0)
    static let cashbackGrey243 = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0)
    static let cashbackGreen33 = UIColor(red: 33/255, green: 193/255, blue: 122/255, alpha: 1.0)
    static let cashbackSeaYellow = UIColor(red: 236/255, green: 175/255, blue: 21/255, alpha: 1.0)
    static let cashbackLightGreen = UIColor(red: 238/255, green: 251/255, blue: 248/255, alpha: 1.0)
}

enum CashbackColors {
    case cashbackRed
    case cashbackYellow
    case cashbackSkyBlue
    case cashbackGrey
    case cashbacklightBlack
    case cashbackGreen
    case cashbackGrey243
    case cashbackGreen33
    case cashbackBlackA10
    case cashbackSkyBlueA30
    case cashbacklightBlackA30
    case cashbackSeaYellow
    case cashbackLightGreen
}

extension CashbackColors {
    var color: UIColor {
        switch self {
        case .cashbackRed: return UIColor.cashbackRed
        case .cashbackYellow: return UIColor.cashbackGreen
        case .cashbackSkyBlue: return UIColor.cashbackSkyBlue
        case .cashbackGrey: return UIColor.cashbackGrey
        case .cashbacklightBlack: return UIColor.cashbacklightBlack
        case .cashbackGreen: return UIColor.cashbackGreen
        case .cashbackGrey243: return UIColor.cashbackGrey243
        case .cashbackGreen33: return UIColor.cashbackGreen33
        case .cashbackBlackA10: return UIColor.cashbackBlackA10
        case .cashbackSkyBlueA30: return UIColor.cashbackSkyBlueA30
        case .cashbacklightBlackA30: return UIColor.cashbacklightBlackA30
        case .cashbackSeaYellow: return UIColor.cashbackSeaYellow
        case .cashbackLightGreen: return UIColor.cashbackLightGreen
        }
    }
}


enum OfferStatus: String {
    case inProgress = "INPROGRESS"  //When user has participated in offer to earn higher cashback
    case initialized = "INITIALIZED" //When user has activated the offer by doing 1 transaction
    case completed = "COMPLETED" //When user has completed the offer  - either claimed initial cashback or earned higher cashback
    case expired = "GAME_EXPIRED" //when user participated in offer to earn higher cashback, but did not complete all the transactions
    case offerExpired = "OFFER_EXPIRED" //When user did not chose - claim or participate option
    case denied = "DENIED" //When user claimed initial cashback and denied to participate further to earn cashback
    case unacked = "OFFER_UNACKED"
    case userOptOut = "USER_OPT_OUT"
    case none = ""
}
    
enum ButtonType {
    case borderWithAnimated
    case bordered
    case flat
}

enum PostTransactionStates {
    case shimmer
    case scratchState
    case promotionState
}

enum ScratchCardStates {
    case inProgress
    case inProgressWithBetterLuck
    case inProgressWithStageMove
    case initializedWithClaim
    case initializedWithoutClaim
    case completed
    case none
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, UIScreen.main.scale)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
