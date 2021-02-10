//
//  JRCBScratchConstants.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 25/12/19.
//

import Foundation

extension UIColor {
    struct ScratchMask {
        static let trumpetUpper  = UIColor(hex: "3252F0")
        static let trumpetLower  = UIColor(hex: "3B68FF")
        static let victoryUpper  = UIColor(hex: "F02674")
        static let victoryLower  = UIColor(hex: "FF428B")
        static let diamondUpper  = UIColor(hex: "101F5C")
        static let diamondLower  = UIColor(hex: "22378A")
        static let sunglassUpper = UIColor(hex: "FEDB31")
        static let sunglassLower = UIColor(hex: "FFF536")
        static let skyBlueUpper  = UIColor(hex: "00AAFF")
        static let skyBlueLower  = UIColor(hex: "00C4FF")
    }
    
    struct ScratchCard {
        struct Blue {
            static let commonBtnBlueColor = UIColor(red: 0/255, green: 172/255, blue: 237/255, alpha: 1.0)
            static let scratchCommonBlue = UIColor(red: 0/255, green: 196/255, blue: 255/255, alpha: 1.0)
            static let scratchPointsBlue = UIColor(red: 26/255, green: 30/255, blue: 49/255, alpha: 1.0)
            static let scratchWonBlue = UIColor(red: 32/255, green: 47/255, blue: 81/255, alpha: 1.0)
        }
        
        struct yellow {
            static let pointsLabel = UIColor(red: 206/255, green: 166/255, blue: 104/255, alpha: 1.0)
        }
    }
    
    struct Grid {
        static let headerBlue = UIColor(red: 26/255, green: 69/255, blue: 137/255, alpha: 1.0)
    }
}

extension UIImage {
    struct ScratchCard {
        struct Blue {
            static let commonBtnBlueColor = UIColor(red: 0/255, green: 172/255, blue: 237/255, alpha: 1.0)
        }
        
        struct ScratchIcon {
            static let betterLuck = UIImage.imageWith(name: "scratchBlnt") ?? UIImage()
            static let postScratchCommonConfeti = UIImage.imageWith(name: "ic_PostScratchConfeti") ?? UIImage()
            static let postScratchPointsConfeti = UIImage.imageWith(name: "postScratchPointConfeti") ?? UIImage()
        }
        
             
        struct MaskImageWithConfeti {
            static let trumpet = UIImage.imageWith(name: "scratchTrumpet") ?? UIImage()
            static let victory = UIImage.imageWith(name: "scratchVictory") ?? UIImage()
            static let diamond = UIImage.imageWith(name: "scratchDiamond") ?? UIImage()
            static let sunglass = UIImage.imageWith(name: "scratchSunglass") ?? UIImage()
        }
    }
    
    struct Grid {
        struct Placeholder {
            static let offersPlaceholder = UIImage.imageWith(name: "offersPlaceholder") ?? UIImage()
            static let rewardsPlaceholder = UIImage.imageWith(name: "rewardsPlaceholder") ?? UIImage()
            static let campaignPlaceholder = UIImage.imageWith(name: "offers_placeholder") ?? UIImage()
        }
    }
}


enum JRCBScratchConfigEnum: Int, CaseIterable {
    case yellow = 0
    case blue
    case orange
    case violet
    case yellowLocked
    
    func getScratchColor() -> UIColor {
        return UIColor.clear
    }
    
    static func configWith(index: Int) -> JRCBScratchConfigEnum {
        let allConfigs :[JRCBScratchConfigEnum] = [.yellow, .blue, .orange, .violet]
        let total = allConfigs.count
        guard total > 1  else {
            return .yellow
        }
        
        var indx = index
        if index > allConfigs.count-1 {
            indx = index%(allConfigs.count)
        }
        
        let cardConfig = allConfigs[indx]
        return cardConfig
    }
    
    static func getLockedConfig() -> JRCBScratchConfigEnum {
        return .yellowLocked
    }
    
    static func getPlaceholderConfig() -> JRCBScratchConfigEnum {
        return .yellow
    }
    
    static func randomScratchColor() -> (config: JRCBScratchConfigEnum, index: Int) {
        let rIndx = Int.random(in: 1..<JRCBScratchConfigEnum.allCases.count-1)
        return (JRCBScratchConfigEnum.configWith(index: rIndx), rIndx)
    }
}


enum JRCBCardType {
    case cashback
    case goldback
    case coins
    case crosspromo
    case deal
    case inProgressStepAhead
    case initiatedAcceptCase
    case initiatedRejectCase
    case betterLuckNextTime
    case locked
    case cricketCard
    case flipCard
    case superCashGame
    case unknown

    func getCardIndex() -> Int {
        switch self {
        case .cashback, .goldback, .coins, .crosspromo, .deal:
            return 0
        case .locked, .superCashGame, .unknown:
            return 1
        case .cricketCard:
            return 2
        case .betterLuckNextTime, .flipCard:
            return 3
        default:
            return -1
        }
    }
    
    static func getCardTypeForScratchCard(modelData: JRCBRedumptionScratchCard) -> JRCBCardType {
        var cardType: JRCBCardType = .unknown
        if modelData.isSupported == false {
            return cardType
        }
        if modelData.status == .stInitialised {
            return cardType
        } else if modelData.status == .stExpired || modelData.status == .stCancelled {
            return cardType
        } else if modelData.status == .stLocked {
            cardType = .locked
        } else if let metadata = modelData.redemMetedata {
            if metadata.redemptionType == .rSuperCashgame {
                cardType = .superCashGame
            } else if metadata.redemptionType == .rCricket {
                cardType = .cricketCard
            } else if metadata.amount > 0.0 {
                let type = metadata.redemptionType
                switch type {
                    
                case .rCrosspromo:
                    cardType = .crosspromo
                case .rDeal:
                    cardType = .deal
                case .rCashback, .rUPI, .rPBPL, .rGV_Cashback:
                    cardType = .cashback
                case .rGoldback:
                    cardType = .goldback
                case .rCoins:
                    cardType = .coins
                case .rCricket:
                    cardType = .cricketCard
                default:
                    cardType = .unknown
                }
            } else {
                if metadata.flip {
                    cardType = .flipCard
                } else {
                    cardType = .betterLuckNextTime
                }
            }
        }
        
        return cardType
    }
    
    static func getCardTypeForAssured(modelData: JRCBGratification) -> JRCBCardType {
        var cardType: JRCBCardType = .unknown
        if let _ = modelData.redumptionInfo as? JRCBRedumptionSuperCashGame {
            cardType = .superCashGame
        } else if modelData.bonus_amount == 0, modelData.redemption_type != .rCricket {
            cardType = .betterLuckNextTime
        } else {
            switch modelData.redemption_type {
            case .rCrosspromo:
                cardType = .crosspromo
            case .rDeal:
                cardType = .deal
            case .rCashback, .rUPI, .rPBPL, .rGV_Cashback:
                cardType = .cashback
            case .rGoldback:
                cardType = .goldback
            case .rCoins:
                cardType = .coins
            case .rCricket:
                cardType = .cricketCard
            default:
                cardType = .unknown
            }
        }
        
        return cardType
    }
}


struct JRCBConstants {
    struct Common {
        static let kDefaultErrorMsg = "jr_CB_SomethingWrong".localized
        static let kDefaultErrorTitle = "jr_CB_PleaseTryAgain".localized
        static let kValidTill = "jr_CB_ValidTill".localized + " "
        static let kValidFrom = "jr_CB_ValidFrom".localized + " "
        static let kToString = "jr_CB_To".localized
        static let kPinString = "jr_CB_PINString".localized
        static let kSelOfferTagVal = "money transfer and bank offers"
        static let kSelOfferTagValRech = "recharge and bill payment offers"
        static let kStickerCollectibleType = "sticker"
        static let kNoCouponCodeText = "No coupon code required"
    }
    
    struct ScractchCard {
        static let kScratchLineWidth = 70
        static let kScratchCardCornerRadius = CGFloat(20)
        static let kScratchPercentToComplete = 20
        static let kRetryErrorStatus = 404
        static let kRetryErrorCode = "SUCASH_4001"
    }
    
    struct Symbol {
        static let kRupee = "₹"
        static let kOfferActivated = "jr_CB_OfferActivated".localized
        static let kVoucherCopied = "jr_co_vc_copied".localized
        static let kBetterLuck = "jr_CB_BetterLuck".localized
    }
}

enum JRCBLoadingState {
    case cbNotStarted
    case cbInProgress
    case cbSuccess
    case cbUpdate
    case cbFailed
    case cbUpdateFailed
}

enum kScratchImageConfigEnum: Int, CaseIterable {
    case trumpet = 0
    case victory
    case diamond
    case sunglass
    case skyBlue
    
    func getScratchMaskImages() -> UIImage {
        switch self {
        case .trumpet:
            return UIImage.ScratchCard.MaskImageWithConfeti.trumpet
        case .victory:
            return UIImage.ScratchCard.MaskImageWithConfeti.victory
        case .diamond:
            return UIImage.ScratchCard.MaskImageWithConfeti.diamond
        case .sunglass:
            return UIImage.ScratchCard.MaskImageWithConfeti.sunglass
        case .skyBlue:
            return UIImage.ScratchCard.MaskImageWithConfeti.trumpet
        }
    }
    
    func getScratchColors() -> (upper: UIColor, lower: UIColor?) {
        switch self {
        case .trumpet:
            return (UIColor.ScratchMask.trumpetUpper, UIColor.ScratchMask.trumpetLower)
        case .victory:
            return (UIColor.ScratchMask.victoryUpper, UIColor.ScratchMask.victoryLower)
        case .diamond:
            return (UIColor.ScratchMask.diamondUpper, UIColor.ScratchMask.diamondLower)
        case .sunglass:
            return (UIColor.ScratchMask.sunglassUpper, UIColor.ScratchMask.sunglassLower)
        case .skyBlue:
            return (UIColor.ScratchMask.skyBlueUpper, UIColor.ScratchMask.skyBlueLower)
        }
    }
    
    func getFontColor() -> UIColor {
        switch self {
        case .trumpet, .victory, .diamond, .skyBlue:
            return UIColor.white
        case .sunglass:
            return UIColor.black
        }
    }
    
    static func getRandomCardConfigInfo(scratchId: String) -> kScratchImageConfigEnum {
        if let intScratchId = Int64(scratchId) {
            let reaminder = intScratchId % 4
            return kScratchImageConfigEnum(rawValue: Int(reaminder)) ?? .trumpet
        }
        return .trumpet
    }
    
    static func getActiveGameInfo() -> kScratchImageConfigEnum {
        return .skyBlue
    }
}
