//
//  JRCBPostTransactionModel.swift
//  jarvis-auth-ios
//
//  Created by Rahul Kamra on 12/06/19.
//

import UIKit
import jarvis_utility_ios

struct JRCBPostTransactionModel: Codable {
    let data: JRCOSupercashList?
    let errors: [JRCOErrorModel]?
    let status: Int?
}

struct JRCOSupercashList: Codable {
    let acknowledgedAt: String?
    let bonusAmount: Int?
    let campaignId: Int?
    let cancelledTxnCount: Int?
    let claimCTA: String?
    let createdAt: String?
    let expireAt: String?
    let frontendRedemptionType: String?
    let gameExpiry: String?
    let gameExpiryAmount: Int?
    let id: Int?
    
    /**Post Transaction Extra keys**/
    var claimTitle: String?
    var postTransactionCompleted: String?
    var claimText: String?
    var winningText: String?
    var postTransactionProgressStatus: String?
    var postTransactionProgressTitle: String?
    /***/
    
    let info: JRCOSuperCashInfo?
    let initialAmount: Int?
    let initializedTransactionConstruct: String?
    let maxCashbackValue: String?
    let maxCashbackValueBonusStage: String?
    let maxCashbackValueInitialStage: String?
    let offerExpiry: String?
    let offerExpiryAmount: Int?
    let offerId: String?
    let offerProgressConstruct: String?
    let optOutTime: String?
    let percentRedemption: String?
    let postTransactionInitialized: String?
    let promocode: String?
    let redemptionStatus: String?
    let redemptionText: String?
    let redemptionType: String?
    let redemptionTypeFlatPercent: String?
    let redemptionTypeIcon: String?
    let remark: String?
    let responseString: String?
    let serverTimestamp: String?
    let stage: Int?
    let stageTxnCount: String?
    let status: String?
    let totalTxnCount: Int?
    let updatedAt: String?
    let postTransactionInitializedTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case acknowledgedAt = "acknowledged_at"
        case bonusAmount = "bonus_amount"
        case campaignId = "campaign_id"
        case cancelledTxnCount = "cancelled_txn_count"
        case claimCTA = "Claim_CTA"
        case createdAt = "created_at"
        case expireAt = "expire_at"
        case frontendRedemptionType = "frontend_redemption_type"
        case gameExpiry = "game_expiry"
        case gameExpiryAmount = "game_expiry_amount"
        case id = "id"
        
        case claimTitle = "claim_title"
        case postTransactionCompleted = "post_transaction_completed"
        case claimText = "claim_text"
        case winningText = "winning_text"
        case postTransactionProgressStatus = "post_transaction_progress_status"
        case postTransactionProgressTitle = "post_transaction_progress_title"
        
        case info = "info"
        case initialAmount = "initial_amount"
        case initializedTransactionConstruct = "initialized_transaction_construct"
        case maxCashbackValue = "max_cashback_value"
        case maxCashbackValueBonusStage = "max_cashback_value_bonus_stage"
        case maxCashbackValueInitialStage = "max_cashback_value_initial_stage"
        case offerExpiry = "offer_expiry"
        case offerExpiryAmount = "offer_expiry_amount"
        case offerId = "offer_id"
        case offerProgressConstruct = "offer_progress_construct"
        case optOutTime = "opt_out_time"
        case percentRedemption = "percent_redemption"
        case postTransactionInitialized = "post_transaction_initialized"
        case promocode = "promocode"
        case redemptionStatus = "redemption_status"
        case redemptionText = "redemption_text"
        case redemptionType = "redemption_type"
        case redemptionTypeFlatPercent = "redemption_type_flat_percent"
        case redemptionTypeIcon = "redemption_type_icon"
        case remark = "remark"
        case responseString = "response_string"
        case serverTimestamp = "server_timestamp"
        case stage = "stage"
        case stageTxnCount = "stage_txn_count"
        case status = "status"
        case totalTxnCount = "total_txn_count"
        case updatedAt = "updated_at"
        case postTransactionInitializedTitle = "post_transaction_initialized_title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acknowledgedAt = try values.decodeIfPresent(String.self, forKey: .acknowledgedAt)
        bonusAmount = try values.decodeIfPresent(Int.self, forKey: .bonusAmount)
        campaignId = try values.decodeIfPresent(Int.self, forKey: .campaignId)
        cancelledTxnCount = try values.decodeIfPresent(Int.self, forKey: .cancelledTxnCount)
        claimCTA = try values.decodeIfPresent(String.self, forKey: .claimCTA)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        expireAt = try values.decodeIfPresent(String.self, forKey: .expireAt)
        frontendRedemptionType = try values.decodeIfPresent(String.self, forKey: .frontendRedemptionType)
        gameExpiry = try values.decodeIfPresent(String.self, forKey: .gameExpiry)
        gameExpiryAmount = try values.decodeIfPresent(Int.self, forKey: .gameExpiryAmount)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        
        claimTitle = try values.decodeIfPresent(String.self, forKey: .claimTitle)
        postTransactionCompleted = try values.decodeIfPresent(String.self, forKey: .postTransactionCompleted)
        claimText = try values.decodeIfPresent(String.self, forKey: .claimText)
        winningText = try values.decodeIfPresent(String.self, forKey: .winningText)
        postTransactionProgressStatus = try values.decodeIfPresent(String.self, forKey: .postTransactionProgressStatus)
        postTransactionProgressTitle = try values.decodeIfPresent(String.self, forKey: .postTransactionProgressTitle)
        
        info = try values.decodeIfPresent(JRCOSuperCashInfo.self, forKey: .info)
        initialAmount = try values.decodeIfPresent(Int.self, forKey: .initialAmount)
        initializedTransactionConstruct = try values.decodeIfPresent(String.self, forKey: .initializedTransactionConstruct)
        maxCashbackValue = try values.decodeIfPresent(QuantumString.self, forKey: .maxCashbackValue)?.value
        maxCashbackValueBonusStage = try values.decodeIfPresent(QuantumString.self, forKey: .maxCashbackValueBonusStage)?.value
        maxCashbackValueInitialStage = try values.decodeIfPresent(QuantumString.self, forKey: .maxCashbackValueInitialStage)?.value
        offerExpiry = try values.decodeIfPresent(String.self, forKey: .offerExpiry)
        offerExpiryAmount = try values.decodeIfPresent(Int.self, forKey: .offerExpiryAmount)
        offerId = try values.decodeIfPresent(String.self, forKey: .offerId)
        offerProgressConstruct = try values.decodeIfPresent(String.self, forKey: .offerProgressConstruct)
        optOutTime = try values.decodeIfPresent(String.self, forKey: .optOutTime)
        percentRedemption = try values.decodeIfPresent(QuantumString.self, forKey: .percentRedemption)?.value
        postTransactionInitialized = try values.decodeIfPresent(String.self, forKey: .postTransactionInitialized)
        promocode = try values.decodeIfPresent(String.self, forKey: .promocode)
        redemptionStatus = try values.decodeIfPresent(String.self, forKey: .redemptionStatus)
        redemptionText = try values.decodeIfPresent(String.self, forKey: .redemptionText)
        redemptionType = try values.decodeIfPresent(String.self, forKey: .redemptionType)
        redemptionTypeFlatPercent = try values.decodeIfPresent(String.self, forKey: .redemptionTypeFlatPercent)
        redemptionTypeIcon = try values.decodeIfPresent(String.self, forKey: .redemptionTypeIcon)
        remark = try values.decodeIfPresent(String.self, forKey: .remark)
        responseString = try values.decodeIfPresent(String.self, forKey: .responseString)
        serverTimestamp = try values.decodeIfPresent(String.self, forKey: .serverTimestamp)
        stage = try values.decodeIfPresent(Int.self, forKey: .stage)
        stageTxnCount = try values.decodeIfPresent(QuantumString.self, forKey: .stageTxnCount)?.value
        status = try values.decodeIfPresent(String.self, forKey: .status)
        totalTxnCount = try values.decodeIfPresent(Int.self, forKey: .totalTxnCount)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        postTransactionInitializedTitle = try values.decodeIfPresent(String.self, forKey: .postTransactionInitializedTitle)
    }
}

struct JRCOSuperCashInfo: Codable {
    
    let campaign: JRCOCampaign?
    let cancelledTxnCount: Int?
    let cashbackDelay: String?
    let cbEarnedAt: String?
    let offerExpiryReason: String?
    let offerResetCount: String?
    let transactionStatus: Int?
    let transactions: [JRCOTransaction]?
    
    enum CodingKeys: String, CodingKey {
        case campaign = "campaign"
        case cancelledTxnCount = "cancelled_txn_count"
        case cashbackDelay = "cashback_delay"
        case cbEarnedAt = "cb_earned_at"
        case offerExpiryReason = "offer_expiry_reason"
        case offerResetCount = "offer_reset_count"
        case transactionStatus = "transaction_status"
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        campaign = try values.decodeIfPresent(JRCOCampaign.self, forKey: .campaign)
        cancelledTxnCount = try values.decodeIfPresent(Int.self, forKey: .cancelledTxnCount)
        cashbackDelay = try values.decodeIfPresent(String.self, forKey: .cashbackDelay)
        cbEarnedAt = try values.decodeIfPresent(String.self, forKey: .cbEarnedAt)
        offerExpiryReason = try values.decodeIfPresent(String.self, forKey: .offerExpiryReason)
        offerResetCount = try values.decodeIfPresent(QuantumString.self, forKey: .offerResetCount)?.value
        transactionStatus = try values.decodeIfPresent(Int.self, forKey: .transactionStatus)
        transactions = try values.decodeIfPresent([JRCOTransaction].self, forKey: .transactions)
    }
    
}
struct JRCOTransaction: Codable {

    let transactionID: String?
    let orderID : String?
    let transactionSource : String?
    let transactionType : String?
    let createdAt : String?
    let transactionAmount : String?
    let merchantName : String?
    let merchantId : String?
    let progressScreenConstruct : String?
    let status : String?
    let stage: String?
    let stageObjects: [JRCOStageObject]?
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "txn_id"
        case orderID = "order_id"
        case transactionSource = "txn_source"
        case transactionType = "txn_type"
        case createdAt = "created_at"
        case transactionAmount = "txn_amount"
        case merchantName = "merchant_name"
        case merchantId = "merchant_id"
        case progressScreenConstruct = "progress_screen_construct"
        case status = "status"
        case stage = "stage"
        case stageObjects = "stage_objects"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionID = try values.decodeIfPresent(QuantumString.self, forKey: .transactionID)?.value
        orderID = try values.decodeIfPresent(QuantumString.self, forKey: .orderID)?.value
        transactionSource = try values.decodeIfPresent(String.self, forKey: .transactionSource)
        transactionType = try values.decodeIfPresent(String.self, forKey: .transactionType)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        transactionAmount = try values.decodeIfPresent(QuantumString.self, forKey: .transactionAmount)?.value
        merchantName = try values.decodeIfPresent(String.self, forKey: .merchantName)
        merchantId = try values.decodeIfPresent(QuantumString.self, forKey: .merchantId)?.value
        progressScreenConstruct = try values.decodeIfPresent(String.self, forKey: .progressScreenConstruct)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        stage = try values.decodeIfPresent(QuantumString.self, forKey: .stage)?.value
        stageObjects = try values.decodeIfPresent([JRCOStageObject].self, forKey: .stageObjects)
    }
}

struct JRCOStageObject: Codable {
    
    let bonusAmount: Int?
    let cashbackText: String?
    let doneTransactions: Int?
    let earnedText: String?
    let frontendRedemptionType: String?
    let redumptionTypeIcon: String?
    let fulfillmentAt: String?
    let maxCashback: Int?
    let percentageRedemption: String?
    let redemptionStatus: String?
    let redemptionText: String?
    let redemptionType: String?
    let redemptionTypeFlatPercent: String?
    let stageStatus: String?
    let stageTxnCount: String?
    let surpriseStage: Bool?
    let crossPromoData: JRCOCrossPromoModelNew?
    let dealData: JRCODealModelNew?
    
    enum CodingKeys: String, CodingKey {
        case bonusAmount = "bonus_amount"
        case cashbackText = "cashback_text"
        case doneTransactions = "done_transactions"
        case earnedText = "earned_text"
        case frontendRedemptionType = "frontend_redemption_type"
        case redumptionTypeIcon = "redemption_type_icon"
        case fulfillmentAt = "fulfillment_at"
        case maxCashback = "max_cashback"
        case percentageRedemption = "percentage_redemption"
        case redemptionStatus = "redemption_status"
        case redemptionText = "redemption_text"
        case redemptionType = "redemption_type"
        case redemptionTypeFlatPercent = "redemption_type_flat_percent"
        case stageStatus = "stage_status"
        case stageTxnCount = "stage_txn_count"
        case surpriseStage = "surprise_stage"
        case crossPromoData = "crosspromo_data"
        case dealData = "deal_data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bonusAmount = try values.decodeIfPresent(Int.self, forKey: .bonusAmount)
        cashbackText = try values.decodeIfPresent(String.self, forKey: .cashbackText)
        doneTransactions = try values.decodeIfPresent(Int.self, forKey: .doneTransactions)
        earnedText = try values.decodeIfPresent(String.self, forKey: .earnedText)
        frontendRedemptionType = try values.decodeIfPresent(String.self, forKey: .frontendRedemptionType)
        redumptionTypeIcon = try values.decodeIfPresent(String.self, forKey: .redumptionTypeIcon)
        fulfillmentAt = try values.decodeIfPresent(String.self, forKey: .fulfillmentAt)
        maxCashback = try values.decodeIfPresent(Int.self, forKey: .maxCashback)
        percentageRedemption = try values.decodeIfPresent(String.self, forKey: .percentageRedemption)
        redemptionStatus = try values.decodeIfPresent(String.self, forKey: .redemptionStatus)
        redemptionText = try values.decodeIfPresent(String.self, forKey: .redemptionText)
        redemptionType = try values.decodeIfPresent(String.self, forKey: .redemptionType)
        redemptionTypeFlatPercent = try values.decodeIfPresent(String.self, forKey: .redemptionTypeFlatPercent)
        stageStatus = try values.decodeIfPresent(String.self, forKey: .stageStatus)
        stageTxnCount = try values.decodeIfPresent(QuantumString.self, forKey: .stageTxnCount)?.value
        surpriseStage = try values.decodeIfPresent(Bool.self, forKey: .surpriseStage)
        crossPromoData = try values.decodeIfPresent(JRCOCrossPromoModelNew.self, forKey: .crossPromoData)
        dealData = try values.decodeIfPresent(JRCODealModelNew.self, forKey: .dealData)
    }
}

struct JRCOCampaign: Codable {
    
    let autoActivate: Bool?
    let backgroundImageUrl: String?
    let bonusAmount: String?
    let campaign: String?
    let cashbackProcessDelay: Int?
    let cashbackProcessDelayUnit: Int?
    let condition: String?
    let deeplinkUrl: String?
    let frontendRedemptionType: String?
    let gameExpiry: Int?
    let gameExpiryAmount: String?
    let id: Int?
    let importantTerms: String?
    let info: JRCOCampaignInfo?
    let initialAmount: String?
    let isOffusTransaction: Bool?
    let maxCashbackValueBonusStage: String?
    let maxCashbackValueInitialStage: String?
    let maxOfferAllowed: String?
    let multiStageCampaign: Bool?
    let multiStageGoldback: Bool?
    let multiStageIcon: String?
    let newOffersImageUrl: String?
    let offUsTransactionText: String?
    let offerExpiry: Int?
    let offerExpiryAmount: String?
    let offerImageUrl: String?
    let offerKeyword: String?
    let offerSummary: String?
    let offerTextOverride: String?
    let offerTypeId: Int?
    let offerTypeText: String?
    let offerUserCondition: JRCOOfferUserCondition?
    let pendingOfferValue: String?
    let percentRedemption: String?
    let progressScreenConstruct: String?
    let progressScreenCta: String?
    let redemptionType: String?
    let redemptionTypeFlatPercent: String?
    let shortDescription: String?
    let stages: JRCOStage?
    let surpriseText: String?
    let surpriseTextTitle: String?
    let thirdPartyId: Int?
    let tnc: String?
    let totalCashbackEarned: Int?
    let totalOfferValue: JRCOTotalOfferValue?
    let validUpto: String?
    let backgroundOverlay: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case autoActivate = "auto_activate"
        case backgroundImageUrl = "background_image_url"
        case bonusAmount = "bonus_amount"
        case campaign = "campaign"
        case cashbackProcessDelay = "cashback_process_delay"
        case cashbackProcessDelayUnit = "cashback_process_delay_unit"
        case condition = "condition"
        case deeplinkUrl = "deeplink_url"
        case frontendRedemptionType = "frontend_redemption_type"
        case gameExpiry = "game_expiry"
        case gameExpiryAmount = "game_expiry_amount"
        case id = "id"
        case importantTerms = "important_terms"
        case info = "info"
        case initialAmount = "initial_amount"
        case isOffusTransaction = "is_offus_transaction"
        case maxCashbackValueBonusStage = "max_cashback_value_bonus_stage"
        case maxCashbackValueInitialStage = "max_cashback_value_initial_stage"
        case maxOfferAllowed = "max_offer_allowed"
        case multiStageCampaign = "multi_stage_campaign"
        case multiStageGoldback = "multi_stage_goldback"
        case multiStageIcon = "multi_stage_icon"
        case newOffersImageUrl = "new_offers_image_url"
        case offUsTransactionText = "off_us_transaction_text"
        case offerExpiry = "offer_expiry"
        case offerExpiryAmount = "offer_expiry_amount"
        case offerImageUrl = "offer_image_url"
        case offerKeyword = "offer_keyword"
        case offerSummary = "offer_summary"
        case offerTextOverride = "offer_text_override"
        case offerTypeId = "offer_type_id"
        case offerTypeText = "offer_type_text"
        case offerUserCondition = "offerUserCondition"
        case pendingOfferValue = "pending_offer_value"
        case percentRedemption = "percent_redemption"
        case progressScreenConstruct = "progress_screen_construct"
        case progressScreenCta = "progress_screen_cta"
        case redemptionType = "redemption_type"
        case redemptionTypeFlatPercent = "redemption_type_flat_percent"
        case shortDescription = "short_description"
        case stages = "stages"
        case surpriseText = "surprise_text"
        case surpriseTextTitle = "surprise_text_title"
        case thirdPartyId = "third_party_id"
        case tnc = "tnc"
        case totalCashbackEarned = "total_cashback_earned"
        case totalOfferValue = "total_offer_value"
        case validUpto = "valid_upto"
        case backgroundOverlay = "background_overlay"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        autoActivate = try values.decodeIfPresent(Bool.self, forKey: .autoActivate)
        backgroundImageUrl = try values.decodeIfPresent(String.self, forKey: .backgroundImageUrl)
        bonusAmount = try values.decodeIfPresent(QuantumString.self, forKey: .bonusAmount)?.value
        campaign = try values.decodeIfPresent(String.self, forKey: .campaign)
        cashbackProcessDelay = try values.decodeIfPresent(Int.self, forKey: .cashbackProcessDelay)
        cashbackProcessDelayUnit = try values.decodeIfPresent(Int.self, forKey: .cashbackProcessDelayUnit)
        condition = try values.decodeIfPresent(String.self, forKey: .condition)
        deeplinkUrl = try values.decodeIfPresent(String.self, forKey: .deeplinkUrl)
        frontendRedemptionType = try values.decodeIfPresent(String.self, forKey: .frontendRedemptionType)
        gameExpiry = try values.decodeIfPresent(Int.self, forKey: .gameExpiry)
        gameExpiryAmount = try values.decodeIfPresent(QuantumString.self, forKey: .gameExpiryAmount)?.value
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        importantTerms = try values.decodeIfPresent(String.self, forKey: .importantTerms)
        info = try values.decodeIfPresent(JRCOCampaignInfo.self, forKey: .info)
        initialAmount = try values.decodeIfPresent(QuantumString.self, forKey: .initialAmount)?.value
        isOffusTransaction = try values.decodeIfPresent(Bool.self, forKey: .isOffusTransaction)
        maxCashbackValueBonusStage = try values.decodeIfPresent(QuantumString.self, forKey: .maxCashbackValueBonusStage)?.value
        maxCashbackValueInitialStage = try values.decodeIfPresent(QuantumString.self, forKey: .maxCashbackValueInitialStage)?.value
        maxOfferAllowed = try values.decodeIfPresent(String.self, forKey: .maxOfferAllowed)
        multiStageCampaign = try values.decodeIfPresent(Bool.self, forKey: .multiStageCampaign)
        multiStageGoldback = try values.decodeIfPresent(Bool.self, forKey: .multiStageGoldback)
        multiStageIcon = try values.decodeIfPresent(String.self, forKey: .multiStageIcon)
        newOffersImageUrl = try values.decodeIfPresent(String.self, forKey: .newOffersImageUrl)
        offUsTransactionText = try values.decodeIfPresent(String.self, forKey: .offUsTransactionText)
        offerExpiry = try values.decodeIfPresent(Int.self, forKey: .offerExpiry)
        offerExpiryAmount = try values.decodeIfPresent(QuantumString.self, forKey: .offerExpiryAmount)?.value
        offerImageUrl = try values.decodeIfPresent(String.self, forKey: .offerImageUrl)
        offerKeyword = try values.decodeIfPresent(String.self, forKey: .offerKeyword)
        offerSummary = try values.decodeIfPresent(String.self, forKey: .offerSummary)
        offerTextOverride = try values.decodeIfPresent(String.self, forKey: .offerTextOverride)
        offerTypeId = try values.decodeIfPresent(Int.self, forKey: .offerTypeId)
        offerTypeText = try values.decodeIfPresent(String.self, forKey: .offerTypeText)
        offerUserCondition = try values.decodeIfPresent(JRCOOfferUserCondition.self, forKey: .offerUserCondition)
        pendingOfferValue = try values.decodeIfPresent(String.self, forKey: .pendingOfferValue)
        percentRedemption = try values.decodeIfPresent(QuantumString.self, forKey: .percentRedemption)?.value
        progressScreenConstruct = try values.decodeIfPresent(String.self, forKey: .progressScreenConstruct)
        progressScreenCta = try values.decodeIfPresent(String.self, forKey: .progressScreenCta)
        redemptionType = try values.decodeIfPresent(String.self, forKey: .redemptionType)
        redemptionTypeFlatPercent = try values.decodeIfPresent(String.self, forKey: .redemptionTypeFlatPercent)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        stages = try values.decodeIfPresent(JRCOStage.self, forKey: .stages)
        surpriseText = try values.decodeIfPresent(String.self, forKey: .surpriseText)
        surpriseTextTitle = try values.decodeIfPresent(String.self, forKey: .surpriseTextTitle)
        thirdPartyId = try values.decodeIfPresent(Int.self, forKey: .thirdPartyId)
        tnc = try values.decodeIfPresent(String.self, forKey: .tnc)
        totalCashbackEarned = try values.decodeIfPresent(Int.self, forKey: .totalCashbackEarned)
        totalOfferValue = try values.decodeIfPresent(JRCOTotalOfferValue.self, forKey: .totalOfferValue)
        validUpto = try values.decodeIfPresent(String.self, forKey: .validUpto)
        backgroundOverlay = try values.decodeIfPresent(QuantumBool.self, forKey: .backgroundOverlay)?.value
    }
    
}

struct JRCOTotalOfferValue: Codable {
    
    let maxBonus: Int?
    
    enum CodingKeys: String, CodingKey {
        case maxBonus = "max_bonus"
    }
}

struct JRCOStage: Codable {
    
    var campaignStageList: [String: [JRCOCampaignStageList]]?
    
    private struct CustomKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        
        self.campaignStageList = [String: [JRCOCampaignStageList]]()
        for key in container.allKeys {
            let value = try container.decodeIfPresent([JRCOCampaignStageList].self, forKey: CustomKey(stringValue: key.stringValue)!)
            self.campaignStageList?[key.stringValue] = value
        }
    }
}

struct JRCOCampaignStageList: Codable {
    
    let bonusAmount: Int?
    let cashbackText: String?
    let doneTransactions: Int?
    let earnedText: String?
    let frontendRedemptionType: String?
    let fulfillmentAt: String?
    let maxCashback: Int?
    let percentageRedemption: String?
    let redemptionStatus: String?
    let redemptionText: String?
    let redemptionType: String?
    let redemptionTypeFlatPercent: String?
    let stageStatus: String?
    let stageTxnCount: String?
    let surpriseStage: Bool?
    
    enum CodingKeys: String, CodingKey {
        case bonusAmount = "bonus_amount"
        case cashbackText = "cashback_text"
        case doneTransactions = "done_transactions"
        case earnedText = "earned_text"
        case frontendRedemptionType = "frontend_redemption_type"
        case fulfillmentAt = "fulfillment_at"
        case maxCashback = "max_cashback"
        case percentageRedemption = "percentage_redemption"
        case redemptionStatus = "redemption_status"
        case redemptionText = "redemption_text"
        case redemptionType = "redemption_type"
        case redemptionTypeFlatPercent = "redemption_type_flat_percent"
        case stageStatus = "stage_status"
        case stageTxnCount = "stage_txn_count"
        case surpriseStage = "surprise_stage"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bonusAmount = try values.decodeIfPresent(Int.self, forKey: .bonusAmount)
        cashbackText = try values.decodeIfPresent(String.self, forKey: .cashbackText)
        doneTransactions = try values.decodeIfPresent(Int.self, forKey: .doneTransactions)
        earnedText = try values.decodeIfPresent(String.self, forKey: .earnedText)
        frontendRedemptionType = try values.decodeIfPresent(String.self, forKey: .frontendRedemptionType)
        fulfillmentAt = try values.decodeIfPresent(String.self, forKey: .fulfillmentAt)
        maxCashback = try values.decodeIfPresent(Int.self, forKey: .maxCashback)
        percentageRedemption = try values.decodeIfPresent(String.self, forKey: .percentageRedemption)
        redemptionStatus = try values.decodeIfPresent(String.self, forKey: .redemptionStatus)
        redemptionText = try values.decodeIfPresent(String.self, forKey: .redemptionText)
        redemptionType = try values.decodeIfPresent(String.self, forKey: .redemptionType)
        redemptionTypeFlatPercent = try values.decodeIfPresent(String.self, forKey: .redemptionTypeFlatPercent)
        stageStatus = try values.decodeIfPresent(String.self, forKey: .stageStatus)
        stageTxnCount = try values.decodeIfPresent(QuantumString.self, forKey: .stageTxnCount)?.value
        surpriseStage = try values.decodeIfPresent(Bool.self, forKey: .surpriseStage)
    }
}

struct JRCOOfferUserCondition: Codable {
    
    let actualValue: Int?
    let condition: Bool?
    let operatorType: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case actualValue = "actualValue"
        case condition = "condition"
        case operatorType = "operator"
        case value = "value"
    }
}

struct JRCOCampaignInfo: Codable {
    
    let autoActivate: Bool?
    let backgroundImageUrl: String?
    let deeplinkUrl: String?
    let gameExpiry: String?
    let gameExpiryAmount: String?
    let importantTerms: String?
    let isDeeplink: Bool?
    let newOffersImageUrl: String?
    let offUsTransactionText: String?
    let offerExpiry: String?
    let offerExpiryAmount: String?
    let offerExpiryTimeUnit: String?
    let offerImageUrl: String?
    let offerKeyword: String?
    let offerTextOverride: String?
    let offerTypeId: String?
    let ppiType: String?
    let productListUrl: String?
    let progressScreenConstruct: String?
    let progressScreenCta: String?
    let supercashStages: JRCOSupercashStage?
    let surpriseText: String?
    let timeUnit: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case autoActivate = "auto_activate"
        case backgroundImageUrl = "background_image_url"
        case deeplinkUrl = "deeplink_url"
        case gameExpiry = "game_expiry"
        case gameExpiryAmount = "game_expiry_amount"
        case importantTerms = "important_terms"
        case isDeeplink = "isDeeplink"
        case newOffersImageUrl = "new_offers_image_url"
        case offUsTransactionText = "off_us_transaction_text"
        case offerExpiry = "offer_expiry"
        case offerExpiryAmount = "offer_expiry_amount"
        case offerExpiryTimeUnit = "offer_expiry_time_unit"
        case offerImageUrl = "offer_image_url"
        case offerKeyword = "offer_keyword"
        case offerTextOverride = "offer_text_override"
        case offerTypeId = "offer_type_id"
        case ppiType = "ppi_type"
        case productListUrl = "product_list_url"
        case progressScreenConstruct = "progress_screen_construct"
        case progressScreenCta = "progress_screen_cta"
        case supercashStages = "supercash_stages"
        case surpriseText = "surprise_text"
        case timeUnit = "time_unit"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        autoActivate = try values.decodeIfPresent(Bool.self, forKey: .autoActivate)
        backgroundImageUrl = try values.decodeIfPresent(String.self, forKey: .backgroundImageUrl)
        deeplinkUrl = try values.decodeIfPresent(String.self, forKey: .deeplinkUrl)
        gameExpiry = try values.decodeIfPresent(String.self, forKey: .gameExpiry)
        gameExpiryAmount = try values.decodeIfPresent(QuantumString.self, forKey: .gameExpiryAmount)?.value
        importantTerms = try values.decodeIfPresent(String.self, forKey: .importantTerms)
        isDeeplink = try values.decodeIfPresent(Bool.self, forKey: .isDeeplink)
        newOffersImageUrl = try values.decodeIfPresent(String.self, forKey: .newOffersImageUrl)
        offUsTransactionText = try values.decodeIfPresent(String.self, forKey: .offUsTransactionText)
        offerExpiry = try values.decodeIfPresent(String.self, forKey: .offerExpiry)
        offerExpiryAmount = try values.decodeIfPresent(QuantumString.self, forKey: .offerExpiryAmount)?.value
        offerExpiryTimeUnit = try values.decodeIfPresent(QuantumString.self, forKey: .offerExpiryTimeUnit)?.value
        offerImageUrl = try values.decodeIfPresent(String.self, forKey: .offerImageUrl)
        offerKeyword = try values.decodeIfPresent(String.self, forKey: .offerKeyword)
        offerTextOverride = try values.decodeIfPresent(String.self, forKey: .offerTextOverride)
        offerTypeId = try values.decodeIfPresent(QuantumString.self, forKey: .offerTypeId)?.value
        ppiType = try values.decodeIfPresent(String.self, forKey: .ppiType)
        productListUrl = try values.decodeIfPresent(String.self, forKey: .productListUrl)
        progressScreenConstruct = try values.decodeIfPresent(String.self, forKey: .progressScreenConstruct)
        progressScreenCta = try values.decodeIfPresent(String.self, forKey: .progressScreenCta)
        supercashStages = try values.decodeIfPresent(JRCOSupercashStage.self, forKey: .supercashStages)
        surpriseText = try values.decodeIfPresent(String.self, forKey: .surpriseText)
        timeUnit = try values.decodeIfPresent(QuantumString.self, forKey: .timeUnit)?.value
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
}

struct JRCOSupercashStage: Codable {
    
    var campaignStageList: [String: JRCOSupercashStageData]?
    
    private struct CustomKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomKey.self)
        
        self.campaignStageList = [String: JRCOSupercashStageData]()
        for key in container.allKeys {
            let value = try container.decodeIfPresent(JRCOSupercashStageData.self, forKey: CustomKey(stringValue: key.stringValue)!)
            self.campaignStageList?[key.stringValue] = value
        }
    }
}

struct JRCOSupercashStageData: Codable {
    
    let event: String?
    let surpriseStage: String?
    
    enum CodingKeys: String, CodingKey {
        case event = "event"
        case surpriseStage = "surprise_stage"
    }
}

struct JRCODealModelNew: Codable {
    
    let amount: Int?
    let dealBrand: String?
    let dealExpiry: String?
    let dealIcon: String?
    let dealRedemptionTerms: String?
    let dealTerms: String?
    let dealText: String?
    let dealUsageText: String?
    let dealValidFrom: String?
    let dealVoucherCode: String?
    let frontendRedemptionType: String?
    let hasOfferText: Int?
    let hasTnc: Int?
    let id: String?
    let merchantName: String?
    let tncText: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case dealBrand = "deal_brand"
        case dealExpiry = "deal_expiry"
        case dealIcon = "deal_icon"
        case dealRedemptionTerms = "deal_redemption_terms"
        case dealTerms = "deal_terms"
        case dealText = "deal_text"
        case dealUsageText = "deal_usage_text"
        case dealValidFrom = "deal_valid_from"
        case dealVoucherCode = "deal_voucher_code"
        case frontendRedemptionType = "frontend_redemption_type"
        case hasOfferText = "hasOfferText"
        case hasTnc = "hasTnc"
        case id = "id"
        case merchantName = "merchant_name"
        case tncText = "tnc_text"
        case type = "type"
    }
}

struct JRCOCrossPromoModelNew: Codable {
    
    let crossPromoCode: String?
    let applicableOn: String?
    let campaignId: String?
    let campaignName: String?
    let cap: String?
    let crossPromoText: String?
    let crossPromoUsageText: String?
    let crossPromocodeIcon: String?
    let cta: String?
    let ctaDeeplink: String?
    let frontendRedemptionType: String?
    let redemptionType: String?
    let siteId: String?
    let termsConditions: String?
    let type: String?
    let val: String?
    let validFrom: String?
    let validUpto: String?
    
    enum CodingKeys: String, CodingKey {
        case crossPromoCode = "code"
        case applicableOn = "applicable_on"
        case campaignId = "campaign_id"
        case campaignName = "campaign_name"
        case cap = "cap"
        case crossPromoText = "cross_promo_text"
        case crossPromoUsageText = "cross_promo_usage_text"
        case crossPromocodeIcon = "cross_promocode_icon"
        case cta = "cta"
        case ctaDeeplink = "cta_deeplink"
        case frontendRedemptionType = "frontend_redemption_type"
        case redemptionType = "redemption_type"
        case siteId = "site_id"
        case termsConditions = "terms_conditions"
        case type = "type"
        case val = "val"
        case validFrom = "valid_from"
        case validUpto = "valid_upto"
    }
}

