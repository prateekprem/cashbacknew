//
//  LoginAuth.swift
//  LoginAuth
//
//  Created by Parmod on 30/10/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation
import jarvis_utility_ios

public protocol LoginAuthDelegate: class {
    func getDefaultParams() -> [String: Any]?
    func setKeyChainObject(object: Any, forKey: String)
    func keyChainObject(forKey: String) -> Any?
    func ssoTokenUpdatedSuccessfully()
    func getClientSecret() -> String
    func getClientAuthorizationCode() -> String
    func defaultParamsWithSiteIDs(forUrl url: String?) -> [AnyHashable:Any]?
    func setServerTimeInJRDigitalProductManager(dateString : String)
    func getSignUpBanners(forUrl url: String?, completionHandler:@escaping((_ bannerList: Any?,_ success: Bool?, _ error: Error?) -> Void))
    func getUpdatedStorefrontURL(forUrl url : URL?, frame : CGRect, andImageView imageView:UIImageView) -> URL?
    func openDeeplinkUrl(url: URL?, awaitProcessing: Bool)
    func updateLanguage(navigationController: UINavigationController?)
    func applockFlowDidComplete()
    func encryptDataWithRSAKey(_ data: String, _ publicKey: String) -> String?
}
public extension LoginAuthDelegate {
    func getSignUpBanners(forUrl url: String?, completionHandler:@escaping((_ bannerList: Any?,_ success: Bool?, _ error: Error?) -> Void)) { }
    func getUpdatedStorefrontURL(forUrl url : URL?, frame : CGRect, andImageView imageView:UIImageView) -> URL? { return nil }
    func openDeeplinkUrl(url: URL?, awaitProcessing: Bool) { }
    func updateLanguage(navigationController: UINavigationController?) { }
    func applockFlowDidComplete() { }
}

public enum JRLPaytmEnvironment : NSInteger {
    case none, production, staging
}

public enum JRAuthLoginProcedureType: String{
    case none = "none"
    case deviceBinded = "deviceBinded"
    case nonDeviceBindedWithPassword = "loggedInWithPassword"
    case nonDeviceBindedWithOTP = "loggedInWithOTP"
}

struct LoginAuthConfig {
    var clientID: String
    var authorizationCode: String
    var clientSecret: String
    var environment: JRLPaytmEnvironment
    
    init(_ clientID: String = "", _ authorizationCode: String = "", _ clientSecret: String = "") {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.authorizationCode = authorizationCode
        self.environment = .none
    }
}

let kUserDetails = "kUserDetails"
let kSignUpPromptIntervalListIndex = "signUpPromptIntervalListIndex"
let kSignUpPromptSavedDate = "signUpPromptSavedDate"
let kPreviousUserIDKey = "kPreviousUserIDKey"
let kLastLoggedOutReasonKey = "kLastLoggedOutReasonKey"
let kPasswordStrength = "kPasswordStrength"


public enum LastLogoutReason: Int {
    case unknown = 0, manual, sessionExpiry
}

fileprivate class UserDetails: NSObject, Codable {
    //Imp Point: If there is any change in variable name then please make the coding keys with the current variable name and conform the EnCodable, DeCodable protoicols.
    fileprivate var ssoToken: String?
    fileprivate var walletToken: String?
    fileprivate var encSsoToken: String? //will be used for 3rd party authentication
    fileprivate var userID: String?
    fileprivate var displayName: String?
    fileprivate var mobileNumber: String?
    fileprivate var emailVerified: Bool?
    fileprivate var mobileVerified: Bool?
    fileprivate var passwordCreated: Bool?
    fileprivate var emailNotificationEnabled: Bool?
    fileprivate var firstName: String?
    fileprivate var email: String?
    fileprivate var lastName: String?
    fileprivate var gender: String?
    fileprivate var createdOn: String?
    fileprivate var birthDate: String?
    fileprivate var username: String?
    fileprivate var customerStatus: String?
    fileprivate var userPicture: String?
    fileprivate var isKyc: Bool?
    fileprivate var isMinKyc: Bool?
    fileprivate var kycState: String?
    fileprivate var hasCreditCard: Bool?
    fileprivate var hasDigitalGold: Bool?
    fileprivate var isPrimeUser: Bool?
    fileprivate var isUserTypePostpaid: Bool?
    fileprivate var isSDMerchant : Bool?
    fileprivate var isMerchant : Bool?
    fileprivate var isBankCustomer : Bool?
    fileprivate var isP2PMerchant : Bool?
    fileprivate var isPPBCustomer : Bool?
    fileprivate var isReseller: Bool?
    fileprivate var postpaidStatus : String?
    fileprivate var paytmTokenDict: [String: String]?
    fileprivate var walletTokenDict: [String: String]?
    fileprivate var isPasswordVoilated: Bool = false

    fileprivate static func getUserDetails() -> UserDetails? {
        guard let userData = UserDefaults.standard.object(forKey: kUserDetails) as? Data else {
            return nil
        }
        do {
            let userDetails = try JSONDecoder().decode(self, from: userData)
            return userDetails
        } catch {
            print(error)
        }
        
        return nil
    }
    
    fileprivate func archieveData() {
        let encodedData = try? JSONEncoder().encode(self)
        if let data = encodedData, !data.isEmpty{
            UserDefaults.standard.set(data, forKey: kUserDetails)
            UserDefaults.standard.synchronize()
        }
    }
}

public class LoginAuth: NSObject {
    
    private static let instance = LoginAuth()
    private var loginAuthConfiguration: LoginAuthConfig
    private var userDetails: UserDetails?
    weak public var delegate: LoginAuthDelegate?
    internal var isSkipHiddenOnLoginScreen: Bool = false
    internal var isForgotPwdHiddenOnLoginScreen: Bool = false
    internal var isPwdScreenSubMsg: (isRequired:Bool, message:String) = (false,"")
    internal var isUserV2InfoDisabled: Bool = false
    public var isNewUserLoggedIn: Bool = false //Variable to mark signUp user for onboading orchestration before device binding
    internal var isLoginViaOtp: Bool = false
    internal var isFromFP: (Bool, String) = (false, "")
    internal var isPasswordUpgradeEnabled: Bool = false
    internal var isPasswordVoilated: Bool = false
    internal func applockFlowCompleted() {
        self.delegate?.applockFlowDidComplete()
    }
    
    override init() {
        loginAuthConfiguration = LoginAuthConfig()
        userDetails = UserDetails.getUserDetails()
    }
        
    @objc public class func sharedInstance() -> LoginAuth {
        return instance
    }
    
    deinit {
        self.userDetails?.archieveData()
    }
    
    @objc public func isLoggedIn() -> Bool {
        guard let ssoToken =  self.userDetails?.ssoToken, !ssoToken.isEmpty else {
            return false
        }
        return true
    }
}

//MARK:- KeyChain access
extension LoginAuth{
    func setKeyChainObject(object: Any, forKey: String) {
        FXKeychain.default().setObject(object, forKey: forKey)
    }
    
    func keyChainObject(forKey: String) -> Any? {
        return FXKeychain.default().object(forKey: forKey)
    }
}

//MARK:- Getter Setter Methods
extension LoginAuth {
    
    public func getLoginProcedureType() -> JRAuthLoginProcedureType{
        
        //TODO: Need to change the logic post device binding.
        guard let luserDetail = userDetails else{
            return JRAuthLoginProcedureType.none
        }
        
        if LoginAuth.validBool(luserDetail.passwordCreated){
            return JRAuthLoginProcedureType.nonDeviceBindedWithPassword
        }
        else{
            return JRAuthLoginProcedureType.nonDeviceBindedWithOTP
        }
        
    }
    
    public func skipBtnOnLoginScreen(isHidden: Bool){
        isSkipHiddenOnLoginScreen = isHidden
    }
    
    public func passwordUpgrade(isEnabled: Bool){
        isPasswordUpgradeEnabled = isEnabled
    }
    
    internal func isPasswordUpgradationRequired() -> Bool{
        guard isPasswordUpgradeEnabled else { return false }
        return isUserPasswordVoilated()
    }
    
    public func userV2Info(isDisabled: Bool){
        isUserV2InfoDisabled = isDisabled
    }
    
    public func forgotPwdOnLoginScreen(isHidden: Bool){
        isForgotPwdHiddenOnLoginScreen = isHidden
    }
    
    public func addMessageOnPwdScreen(isRequired:Bool, message: String){
        isPwdScreenSubMsg = (isRequired, message)
    }

    public func getMinPasswordLength() -> Int {
        return 5
    }
    
    public func getMaxPasswordLength() -> Int {
        return 15
    }
    
    public func setClientID(_ clientID: String) {
        self.loginAuthConfiguration.clientID = clientID
    }
    
    public func setClientSecret(_ clientSecret: String) {
        self.loginAuthConfiguration.clientSecret = clientSecret
    }
    
    public func setAuthorizationCode(_ authorizationCode: String) {
        self.loginAuthConfiguration.authorizationCode = authorizationCode
    }
    
    public func setEnvironment(_ environment: JRLPaytmEnvironment) {
        self.loginAuthConfiguration.environment = environment
    }
    
    public func setInitialEnviromentConfigs(){
      LoginAuth.sharedInstance().setClientID(GlobalConstants.JRClientID)
      LoginAuth.sharedInstance().setClientSecret(GlobalConstants.JRClientSecret)
      LoginAuth.sharedInstance().setAuthorizationCode(GlobalConstants.JRAuthorizationCode)
    }
    
    @objc public func refreshSsoToken() {
        if let ssoToken = LoginAuth.sharedInstance().delegate?.keyChainObject(forKey: JRSSOToken) as? String {
            self.setSsoToken(ssoToken)
        }
    }
    
    @objc public func getUserID() -> String? {
        return self.userDetails?.userID
    }
    
    @objc public func refreshUserId() {
        if let userId = LoginAuth.sharedInstance().delegate?.keyChainObject(forKey: JRUserID) as? String {
            self.setuserID(userId)
        }
    }
    
    @objc public func getMobileNumber() -> String? {
        return userDetails?.mobileNumber
    }
    
    @objc public func getDisplayName() -> String? {
        return userDetails?.displayName
    }
    
    @objc public func isEmailVerified() -> Bool {
        return LoginAuth.validBool(userDetails?.emailVerified)
    }
    
    @objc public func isMobileVerified() -> Bool {
        return LoginAuth.validBool(userDetails?.mobileVerified)
    }
    
    @objc public func isPasswordCreated() -> Bool {
        return LoginAuth.validBool(userDetails?.passwordCreated)
    }
    
    @objc internal func setPasswordCreated(_ isPasswordCreated:Bool) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.passwordCreated = isPasswordCreated
        userDetails?.archieveData()
    }
    
    @objc public func isKyc() -> Bool {
        return LoginAuth.validBool(userDetails?.isKyc)
    }
    
    @objc public func isMinKyc() -> Bool {
        return LoginAuth.validBool(userDetails?.isMinKyc)
    }
    
    @objc public func hasCreditCard() -> Bool {
        return LoginAuth.validBool(userDetails?.hasCreditCard)
    }
    
    @objc public func setCreditCard(_ hasCreditCard: Bool) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.hasCreditCard = hasCreditCard
        userDetails?.archieveData()

    }

    @objc public func setDigitalGold(_ hasDigitalGold: Bool) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.hasDigitalGold = hasDigitalGold
        userDetails?.archieveData()
        
    }

    @objc public func hasDigitalGold() -> Bool {
        return LoginAuth.validBool(userDetails?.hasDigitalGold)
    }
    
    @objc public func isPrimeUser() -> Bool {
        return LoginAuth.validBool(userDetails?.isPrimeUser)
    }
    
    @objc public func isUserTypePostpaid() -> Bool {
        return LoginAuth.validBool(userDetails?.isUserTypePostpaid)
    }
    
    @objc public func isReseller() -> Bool {
        return LoginAuth.validBool(userDetails?.isReseller)
    }
    
    @objc public func setPrimeUser(_ isPrimeUser: Bool) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.isPrimeUser = isPrimeUser
        userDetails?.archieveData()
    }

    @objc public func isEmailNotificationEnabled() -> Bool {
        return LoginAuth.validBool(userDetails?.emailNotificationEnabled)
    }
    
    @objc public func getFirstName() -> String? {
        return userDetails?.firstName
    }
    
    @objc public func getKycState() -> String? {
        return userDetails?.kycState
    }
    
    @objc public func setKycState(_ kycState: String) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.kycState = kycState
        userDetails?.archieveData()
    }
    
    @objc public func getEmail() -> String? {
        return userDetails?.email
    }
    
    @objc internal func setEmail(_ email: String) {
        if !email.isEmpty {
            userDetails?.email = email
        }
    }
    
    @objc public func getLastName() -> String? {
        return userDetails?.lastName
    }
    
    @objc public func getGender() -> String? {
        return userDetails?.gender
    }
    
    @objc public func getBirthDate() -> String? {
        return userDetails?.birthDate
    }
    
    @objc public func getUserName() -> String? {
        return userDetails?.username
    }
    
    @objc public func getUserStatus() -> String? {
        return userDetails?.customerStatus
    }
    
    @objc public func getUserPicture() -> String? {
        return userDetails?.userPicture
    }
    
    @objc public func setUserPicture(_ userPicture: String?) {
        userDetails?.userPicture = userPicture
    }
    
    @objc public func isSDMerchant() -> Bool{
        return userDetails?.isSDMerchant ?? false
    }
    
    @objc public func setSDMerchant(_ sdMerchant : Bool){
        userDetails?.isSDMerchant = sdMerchant
    }
    
    @objc public func isMerchant() -> Bool{
        return userDetails?.isMerchant ?? false
    }
    
    @objc public func setMerchant(_ merchant : Bool){
        userDetails?.isMerchant = merchant
    }
    
    @objc public func isBankCustomer() -> Bool{
        return userDetails?.isBankCustomer ?? false
    }
    
    @objc public func setBankCustomer(_ bankCustomer : Bool){
        userDetails?.isBankCustomer = bankCustomer
    }
    
    @objc public func isP2PMerchant() -> Bool{
        return userDetails?.isP2PMerchant ?? false
    }
    
    @objc public func setP2PMerchant(_ p2pMerchant : Bool){
        userDetails?.isP2PMerchant = p2pMerchant
    }
    
    @objc public func isPPBCustomer() -> Bool{
        return userDetails?.isPPBCustomer ?? false
    }
    
    @objc public func setPPBCustomer(_ ppbCustomer : Bool){
        userDetails?.isPPBCustomer = ppbCustomer
    }
    
    @objc public func getPostpaidStatus () -> String? {
        return userDetails?.postpaidStatus
    }
    
    @objc public func getPreviousUserId() -> String? {
        return UserDefaults.standard.string(forKey:kPreviousUserIDKey)
    }
    
    public func getLastLogoutReason() -> LastLogoutReason? {
        return LastLogoutReason(rawValue: UserDefaults.standard.integer(forKey: kLastLoggedOutReasonKey))
    }
    
    @objc public func setPreviousUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: kPreviousUserIDKey)
        UserDefaults.standard.synchronize()
    }
    
    public func setLastLogoutReason(_ lastLogoutReason: LastLogoutReason) {
        UserDefaults.standard.set(lastLogoutReason.rawValue, forKey: kLastLoggedOutReasonKey)
        UserDefaults.standard.synchronize()
    }
    
    @objc public func getPasswordStrength() -> String? {
        if LoginAuth.sharedInstance().isPasswordCreated() {
            return UserDefaults.standard.value(forKey:kPasswordStrength) as? String ?? nil
        }
        return nil
    }
    
    @objc public func setPasswordStrength(strength: String) {
        UserDefaults.standard.set(strength, forKey: kPasswordStrength)
        UserDefaults.standard.synchronize()
    }
    
    @objc public static func setAccessToken(code:String, completionHandler:@escaping ((_ success:Bool, _ error:Error?) -> Void)) {
        JRLServiceManager.setAccessToken(code: code) { (isSuccess, error) in
            if let isSuccess = isSuccess, isSuccess {
                completionHandler(true, error)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    @objc public static func checkMobilePassword() {
        if  let ssoToken = LoginAuth.sharedInstance().getSsoToken(), !ssoToken.isEmpty{
            if let mobileNumber = LoginAuth.sharedInstance().getMobileNumber(), !mobileNumber.isEmpty {
                if false == LoginAuth.sharedInstance().isPasswordCreated() {
                    if let setPasswordGTMKey:Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("isSetPasswordMandatory"), setPasswordGTMKey {
                        JRLoginUI.sharedInstance().setPassword()
                    } else if LoginAuth.sharedInstance().isMinKyc() {
                        JRLoginUI.sharedInstance().setPassword()
                    }
                }
            } else {
                JRLoginUI.sharedInstance().addMobile()
            }
        }
    }
    
    public func resetRSAKeys(){
        AuthRSAGenerator.shared.removeAllSavedKeyPair()
    }
    
    //TODO: Remove the this method in future iteration
    @objc public func resetSSOToken(){
        FXKeychain.default().removeObject(forKey:JRSSOToken)
        FXKeychain.default().removeObject(forKey:JRWalletToken)
    }
}

//MARK:- Internal methods
extension LoginAuth{
    
    internal func getClientID() -> String {
        return self.loginAuthConfiguration.clientID
    }

    internal func getClientSecret() -> String {
        return self.loginAuthConfiguration.clientSecret
    }
    
    internal func getAuthorizationCode() -> String {
        return self.loginAuthConfiguration.authorizationCode
    }

    internal func getEnvironment() -> JRLPaytmEnvironment {
        return self.loginAuthConfiguration.environment
    }
    
    internal func setuserID(_ userID: String) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        userDetails?.userID = userID
        userDetails?.archieveData()
        LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: userID, forKey: JRUserID)
    }
    
    internal static func validBool(_ boolValue: Bool?) -> Bool {
        if let boolValue = boolValue, boolValue {
            return true
        }
        return false
    }
    
    internal func updateUserDetails(_ userDict: [String: Any]) {
        
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        if let isPasswordCreated = userDict["isPasswordExistent"] as? Bool {
            userDetails?.passwordCreated = isPasswordCreated
        }
        
        if JRLoginUI.sharedInstance().isCryptoEnabled(),
            let userId = userDict["userId"] as? Int{
            let userIdString = String(userId)
            if !userIdString.isEmpty{
                userDetails?.userID = userIdString
                LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: userIdString, forKey: JRUserID)
            }
        }
        
        if let defaultuserInfo = userDict["defaultInfo"] as? [String: Any] {
            userDetails?.mobileVerified = defaultuserInfo["phoneVerificationStatus"] as? Bool
            userDetails?.emailVerified = defaultuserInfo["emailVerificationStatus"] as? Bool
            userDetails?.isKyc = defaultuserInfo["isKyc"] as? Bool
            userDetails?.emailNotificationEnabled = defaultuserInfo["emailNotificationEnabled"] as? Bool
            userDetails?.email = defaultuserInfo["email"] as? String
            userDetails?.mobileNumber = defaultuserInfo["phone"] as? String
            UserDefaults.standard.set(userDetails?.mobileNumber, forKey: "prefilledLoginId")
            userDetails?.displayName = defaultuserInfo["displayName"] as? String
            userDetails?.firstName = defaultuserInfo["firstName"] as? String
            userDetails?.lastName = defaultuserInfo["lastName"] as? String
            userDetails?.birthDate = defaultuserInfo["dob"] as? String
            userDetails?.gender = defaultuserInfo["gender"] as? String
            userDetails?.createdOn = defaultuserInfo["customerCreationDate"] as? String
            userDetails?.customerStatus = defaultuserInfo["customerStatus"] as? String
            userDetails?.username = defaultuserInfo["username"] as? String
            userDetails?.userPicture = defaultuserInfo["userPicture"] as? String
        }
        
        if let minKycDetails = userDict["minKycDetails"] as? [String: Any] {
            userDetails?.isMinKyc = minKycDetails["isMinKyc"] as? Bool
            userDetails?.kycState = minKycDetails["kycState"] as? String
        }
        
        if let userAttribute = userDict["userAttributeInfo"] as? [String: Any] {
            if let hasCreditCard = userAttribute["CREDIT_CARD"] as? Bool {
                userDetails?.hasCreditCard = hasCreditCard
            } else if let hasCreditCard = userAttribute["CREDIT_CARD"] as? String {
                userDetails?.hasCreditCard = JRUtility.validBool(input: hasCreditCard)
            } else {
                userDetails?.hasCreditCard = false
            }
            
            if let hasDigitalGold = userAttribute["GOLD_ACCOUNT"] as? Bool {
                userDetails?.hasDigitalGold = hasDigitalGold
            } else if let hasDigitalGold = userAttribute["GOLD_ACCOUNT"] as? String {
                userDetails?.hasDigitalGold = JRUtility.validBool(input: hasDigitalGold)
            } else {
                userDetails?.hasDigitalGold = false
            }
            
            userDetails?.postpaidStatus = userAttribute["POSTPAID_STATUS"] as? String
        }
        
        if let userTypes = userDict["userTypes"] as? [String] {
            userDetails?.isPrimeUser = userTypes.contains("PRIME_USER")
            userDetails?.isUserTypePostpaid =  userTypes.contains("POSTPAID_USER")
            userDetails?.isMerchant = userTypes.contains("MERCHANT")
            userDetails?.isSDMerchant = userTypes.contains("SD_MERCHANT")
            userDetails?.isBankCustomer = userTypes.contains("BANK_CUSTOMER")
            userDetails?.isP2PMerchant = userTypes.contains("P2P_MERCHANT")
            userDetails?.isPPBCustomer = userTypes.contains("PPB_CUSTOMER")
            userDetails?.isReseller =   userTypes.contains("IND_RESELLER")

        }
        
        userDetails?.archieveData()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: JRLoginConstants.kPrimeStatusUpdate), object: nil)
    }
    
    internal func resetUserDetails() {
        userDetails = nil
        UserDefaults.standard.removeObject(forKey: kUserDetails)
        UserDefaults.standard.removeObject(forKey: kPasswordStrength)
        UserDefaults.standard.synchronize()
    }
}

//MARK:- Tokens
extension LoginAuth {
    
    internal func setWalletToken(_ walletToken: String) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        userDetails?.walletToken = walletToken
        userDetails?.archieveData()
        LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: walletToken, forKey: JRWalletToken)
    }
    
    @objc public func getWalletToken() -> String? {
        return userDetails?.walletToken
    }
    
    internal func setSsoToken(_ ssoToken: String) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        userDetails?.ssoToken = ssoToken
        userDetails?.archieveData()
        LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: ssoToken, forKey: JRSSOToken)
        LoginAuth.sharedInstance().delegate?.ssoTokenUpdatedSuccessfully()
    }
    
    @objc public func getSsoToken() -> String? {
        return userDetails?.ssoToken
    }
    
    @objc public func getEncSsoToken() -> String? {
        return userDetails?.encSsoToken
    }
    
    @objc public func setEncSsoToken(_ encSsoToken: String) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        userDetails?.encSsoToken = encSsoToken
        userDetails?.archieveData()
        LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: encSsoToken, forKey: JREncSSOToken)
    }
    
    @objc public func refreshEncSsoToken() {
        if let encSsoToken = LoginAuth.sharedInstance().delegate?.keyChainObject(forKey: JREncSSOToken) as? String {
            self.setEncSsoToken(encSsoToken)
        }
    }
    
    internal func getPaytmTokenDict() -> [String: String]? {
        return self.userDetails?.paytmTokenDict
    }
    
    internal func isUserPasswordVoilated() -> Bool{
        return isPasswordVoilated
    }
    
    internal func setPasswordVoilation(_ isVoilated: Bool){
        isPasswordVoilated = isVoilated
    }
    
    public func getWalletTokenDict() -> [String: String]? {
        return self.userDetails?.walletTokenDict
    }
    
    internal func setPaytmTokenDict(_ dict: [String: String]) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        if let ssoToken = dict["accessToken"] {
            self.setSsoToken(ssoToken)
        } else if let ssoToken = dict["access_token"] {
            self.setSsoToken(ssoToken)
        }
        
        if userDetails?.paytmTokenDict == nil{
            userDetails?.paytmTokenDict = [:]
        }
        
        if let refreshToken = dict["refreshToken"]{
            userDetails?.paytmTokenDict?["refreshToken"] = refreshToken
        }
        
        if let accessToken = dict["accessToken"]{
            userDetails?.paytmTokenDict?["accessToken"] = accessToken
        }
        
        if let expiresIn = dict["expiresIn"]{
            userDetails?.paytmTokenDict?["expiresIn"] = expiresIn
        }
        
        if let scope = dict["scope"]{
            userDetails?.paytmTokenDict?["scope"] = scope
        }
        
        if let tokenType = dict["tokenType"]{
            userDetails?.paytmTokenDict?["tokenType"] = tokenType
        }
        
        userDetails?.archieveData()
        LoginAuth.sharedInstance().setKeyChainObject(object: dict, forKey: JRPaytmTokenDict)
        LoginAuth.sharedInstance().delegate?.ssoTokenUpdatedSuccessfully()
    }
    
    internal func setWalletTokenDict(_ dict: [String: String]) {
        if self.userDetails == nil {
            userDetails = UserDetails()
        }
        
        if JRLoginUI.sharedInstance().isCryptoEnabled(){
            if let walletToken = dict["accessToken"] {
                self.setWalletToken(walletToken)
            } else if let walletToken = dict["access_token"] {
                self.setWalletToken(walletToken)
            }
            
            if userDetails?.walletTokenDict == nil{
                userDetails?.walletTokenDict = [:]
            }
            
            if let refreshToken = dict["refreshToken"]{
                userDetails?.walletTokenDict?["refreshToken"] = refreshToken
            }
            
            if let accessToken = dict["accessToken"]{
                userDetails?.walletTokenDict?["accessToken"] = accessToken
                userDetails?.walletTokenDict?["access_token"] = nil
            }
            
            if let accessToken = dict["access_token"]{
                userDetails?.walletTokenDict?["access_token"] = accessToken
                userDetails?.walletTokenDict?["accessToken"] = nil
            }
            
            if let expiresIn = dict["expiresIn"]{
                userDetails?.walletTokenDict?["expiresIn"] = expiresIn
            }
            
            if let scope = dict["scope"]{
                userDetails?.walletTokenDict?["scope"] = scope
            }
            
            if let tokenType = dict["tokenType"]{
                userDetails?.walletTokenDict?["tokenType"] = tokenType
            }
            
            userDetails?.archieveData()
            LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: dict, forKey: JRWalletTokenDict)
        }
        else{
            if let scope = dict["scope"], scope == "wallet", let token = dict["access_token"], !token.isEmpty {
                self.setWalletToken(token)
            }
            
            userDetails?.walletTokenDict = dict
            userDetails?.archieveData()
            LoginAuth.sharedInstance().delegate?.setKeyChainObject(object: dict, forKey: JRWalletTokenDict)
        }
    }
    
    @objc public static func getWalletTokenWith(completionHandler:@escaping (_: Bool, _: String?, _ : [String:Any]?) -> Void){
         
        if !JRLoginUI.sharedInstance().isCryptoEnabled(){

            //Rollback flow without crypto
            JRLServiceManager.getAllActiveTokens { (data, response, error) in
                if let response : HTTPURLResponse = response as? HTTPURLResponse, let dateString : String = response.allHeaderFields["Date"] as? String, dateString.count > 0{
                    LoginAuth.sharedInstance().delegate?.setServerTimeInJRDigitalProductManager(dateString: dateString)
                }
                if let tokensDictionary : [String : Any] = data as? [String : Any], let array = tokensDictionary["tokens"] as? [[String : Any]]{
                    for dic in array{
                        if let scope = dic["scope"] as? String, scope == "wallet", let accessToken = dic["access_token"] as? String{
                            if let ldic = dic as? [String: String]{
                                LoginAuth.sharedInstance().setWalletTokenDict(ldic)
                            }
                            else{
                                var ldic: [String:String] = [:]
                                for (key,value) in dic{
                                    let valueString = String(describing: value)
                                    ldic[key] = valueString
                                }
                                LoginAuth.sharedInstance().setWalletTokenDict(ldic)
                            }
                            completionHandler(true, accessToken, dic)
                            return
                        }
                    }
                }
                completionHandler(false, nil, nil)
                return
            }
        }
        else{
            //check the existing wallet token with expiry
            if let lwalletToken = LoginAuth.sharedInstance().getWalletToken(){
                
                LoginAuth.sharedInstance().isLoggedOut(nil,extractedToken: lwalletToken, nil) { (data, response, error) in
                    if let data = data as? [String: Any], let responseCode = data["responseCode"] as? String , responseCode == "02"{//Token Is Valid
                        completionHandler(true, lwalletToken, LoginAuth.sharedInstance().getWalletTokenDict())
                    }
                    else if let lwalletTokenDict = LoginAuth.sharedInstance().getWalletTokenDict(), let lrefreshToken = lwalletTokenDict["refreshToken"]{//get Token from API with refreshToken
                        
                        JRLServiceManager.setAccessToken(code: lrefreshToken, grantType: .refreshToken) { (isSuccess, error) in
                            if let lsuccess = isSuccess, lsuccess {
                                completionHandler(true, LoginAuth.sharedInstance().getWalletToken(), LoginAuth.sharedInstance().getWalletTokenDict())
                            } else{
                                JRLoginUI.sharedInstance().initiateSessionExpiryFlowForWalletToken(extractedSSOToken: LoginAuth.sharedInstance().getSsoToken(), extractedWalletToken: LoginAuth.sharedInstance().getWalletToken(), nil, completionHandler: completionHandler)
                            }
                        }
                    } else {
                        JRLoginUI.sharedInstance().initiateSessionExpiryFlowForWalletToken(extractedSSOToken: LoginAuth.sharedInstance().getSsoToken(), extractedWalletToken: LoginAuth.sharedInstance().getWalletToken(), nil, completionHandler: completionHandler)
                    }
                }
            }
            else{
                JRLoginUI.sharedInstance().initiateSessionExpiryFlowForWalletToken(extractedSSOToken: LoginAuth.sharedInstance().getSsoToken(), extractedWalletToken: LoginAuth.sharedInstance().getWalletToken(), nil, completionHandler: completionHandler)
            }
        }
    }
    
    @objc public static func getSSOTokenWith(completionHandler: @escaping (_: Bool, _: String?, _ : [String:Any]?) -> Void) {
         
        if !JRLoginUI.sharedInstance().isCryptoEnabled() {

            //Rollback flow without crypto
            JRLServiceManager.getAllActiveTokens { (data, response, error) in
                if let response = response as? HTTPURLResponse,
                    let dateString = response.allHeaderFields["Date"] as? String,
                    dateString.count > 0 {
                    LoginAuth.sharedInstance().delegate?.setServerTimeInJRDigitalProductManager(dateString: dateString)
                }
                if let tokensDictionary = data as? [String : Any],
                    let array = tokensDictionary["tokens"] as? [[String : Any]] {
                    for dic in array {
                        if let scope = dic["scope"] as? String, scope == "paytm", let accessToken = dic["access_token"] as? String {
                            //LoginAuth.sharedInstance().delegate?.setWalletToken(token: accessToken, andObject: dic)
                            if let ldic = dic as? [String: String] {
                                LoginAuth.sharedInstance().setPaytmTokenDict(ldic)
                            }
                            else{
                                var ldic: [String: String] = [:]
                                for (key, value) in dic {
                                    let valueString = String(describing: value)
                                    ldic[key] = valueString
                                }
                                LoginAuth.sharedInstance().setPaytmTokenDict(ldic)
                            }
                            completionHandler(true, accessToken, dic)
                            return
                        }
                    }
                }
                completionHandler(false, nil, nil)
                return
            }
        } else {
            //1. check the existing wallet token with expiry
            if let lssoToken = LoginAuth.sharedInstance().getSsoToken(),
                let lssoTokenDict = LoginAuth.sharedInstance().getPaytmTokenDict(),
                let lexpiry = lssoTokenDict["expiresIn"] {
                
                //2. system time is less than the expiry and valid then return the token and dict
                let updatedExpiry = lexpiry.replacingOccurrences(of: "'", with: "")
                if let expiryIn = Int(updatedExpiry), expiryIn > Date().timeIntervalSince1970.roundToInt() {
                    completionHandler(true, lssoToken, lssoTokenDict)
                    return
                }
                else if let lrefreshToken = lssoTokenDict["refreshToken"] {
                    //3. if not then hit the API with refresh token and fetch the token
                    JRLServiceManager.setAccessToken(code: lrefreshToken, grantType: .refreshToken) { (isSuccess, error) in
                        
                        //4. Update the token and dict. Return the completion with updated value
                        if (error == nil),
                            let tokenDict = LoginAuth.sharedInstance().getPaytmTokenDict(),
                            let token = LoginAuth.sharedInstance().getSsoToken() {
                            completionHandler(true, token, tokenDict)
                            return
                        }
                        completionHandler(false, nil, nil)
                    }
                }
            }
        }
    }
    
    internal func resetTokens(){
        userDetails?.walletToken = nil
        userDetails?.ssoToken = nil
        userDetails?.encSsoToken = nil
        userDetails?.paytmTokenDict = nil
        userDetails?.walletTokenDict = nil
        userDetails?.isPasswordVoilated = false
        userDetails?.archieveData()
    }
}

//MARK:- API Methods
extension LoginAuth {
    
    @objc public func updateV2userInfo(_ urlParams: [String : String], completion:@escaping ((_ dataDict: [String: Any]?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.getV2UserInfo(urlParams) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, nil, error)
                    return
                }
                if let userDetails = data as? [String: Any] {
                    LoginAuth.sharedInstance().updateUserDetails(userDetails)
                    completion(userDetails, response, nil)
                } else {
                    completion(nil, nil, error)
                }
            }
        }
    }
    
    @objc public func updateV2userInfo(_ urlParams: [String : String], completionHandler:@escaping ((_ isSuccess: Bool, _ error: Error?) -> Void)) {
        JRLServiceManager.getV2UserInfo(urlParams) { (data, response, error) in
            if error != nil {
                completionHandler(false, error)
                return
            }
            
            if let userDetails = data as? [String: Any] {
                LoginAuth.sharedInstance().updateUserDetails(userDetails)
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    public func getV2UserInfo(_ urlParams: [String:String], completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.getV2UserInfo(urlParams) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    public func getV2UserPhone(_ phone: String, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.getV2UserPhone(phone) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    public func setUserPassword(_ password: String, _ confirmPassword: String, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.setUserPassword(password, confirmPassword) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    
    public func isLoggedOut(_ urlStr: String?, extractedToken : String? = nil, _ preResponse: HTTPURLResponse?, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.isLoggedOut(urlStr, extractedToken: extractedToken, preResponse) { (data, repsonse, error) in
            completionHandler(data, repsonse, error)
        }
    }
    
    public func logoutSessionToken(completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        JRLServiceManager.logoutSessionToken { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
        }
    }
    
    @objc public static func getAllActiveTokens(withCompletionHandler handler : @escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)){
        JRLServiceManager.getAllActiveTokens { (data, response, error) in
            if let response : HTTPURLResponse = response as? HTTPURLResponse, let dateString : String = response.allHeaderFields["Date"] as? String, dateString.count > 0{
                LoginAuth.sharedInstance().delegate?.setServerTimeInJRDigitalProductManager(dateString: dateString)
            }
            if let tokensDictionary : [String : Any] = data as? [String : Any], let array = tokensDictionary["tokens"] as? [[String : Any]]{
                for dic in array{
                    if let scope = dic["scope"] as? String, scope == "wallet", let accessToken = dic["access_token"] as? String{
                        break
                    }
                }
            }
            DispatchQueue.main.async {
                handler(data,response,error)
            }
        }
    }
    
    private func getWalletTokenForDeviceUpgrade(completionHandler: @escaping (_: Bool, _: String?, _: [String: Any]?) -> Void) {
        JRLServiceManager.getAllActiveTokens { (data, response, error) in
            if let response : HTTPURLResponse = response as? HTTPURLResponse, let dateString : String = response.allHeaderFields["Date"] as? String, dateString.count > 0 {
                LoginAuth.sharedInstance().delegate?.setServerTimeInJRDigitalProductManager(dateString: dateString)
            }
            if let tokensDictionary : [String : Any] = data as? [String : Any],
                let array = tokensDictionary["tokens"] as? [[String : Any]] {
                
                for dic in array {
                    
                    if let scope = dic["scope"] as? String, scope == "wallet",
                        let accessToken = dic["access_token"] as? String {
                        
                        if let ldic = dic as? [String: String] {
                            LoginAuth.sharedInstance().setWalletTokenDict(ldic)
                        } else {
                            var ldic: [String: String] = [:]
                            for (key,value) in dic{
                                let valueString = String(describing: value)
                                ldic[key] = valueString
                            }
                            LoginAuth.sharedInstance().setWalletTokenDict(ldic)
                        }
                        completionHandler(true, accessToken, dic)
                        return
                    }
                }
            } else {
                completionHandler(false, nil, nil)
            }
        }
    }
    
    public func upgradeDeviceIfNeeded() {
                
        guard isLoggedIn(),
            JRLoginUI.sharedInstance().isCryptoEnabled(),
            let number = getMobileNumber() else {
                return
        }
        
        if let walletToken = LoginAuth.sharedInstance().getWalletToken() {
            upgradeDevice(for: number, walletToken)
            
        } else {
            
            getWalletTokenForDeviceUpgrade { (success, token, tokenDict) in
                if let walletToken = token, success {
                    self.upgradeDevice(for: number, walletToken)
                }
            }
        }
    }
    
    private func upgradeDevice(for number: String, _ token:String, retryCount: Int = 0) {
        
        let sharedAuthGenerator = AuthRSAGenerator.shared
        
        if sharedAuthGenerator.shouldRetryOAuthUpgrade(for: number) {
            upgradeAuthToken(for: number, token)
            
        } else if !sharedAuthGenerator.hasKeyPairStored(for: number) ||
            sharedAuthGenerator.shouldRetryDeviceUpgrade(for: number) {
            
            do {
                
                try AuthRSAGenerator.shared.createKeyPair(for: number)
                
                JRLServiceManager.upgradeDevice(token) { (response, error) in
                    
                    if let resp = response,
                        let responseCode = resp[LOGINWSKeys.kResponseCode] as? String {
                        switch responseCode {
                        case LOGINRCkeys.BESuccess, LOGINRCkeys.success200: // Success
                            sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: true)
                            self.upgradeAuthToken(for: number, token)
                            
                        case LOGINRCkeys.deviceAlreadyUpgraded: // Device Already Upgraded
                            sharedAuthGenerator.markDeviceUpgrade(for: number, retryUpgrade: false)
                            
                        case LOGINRCkeys.scopeNotRefreshable, LOGINRCkeys.invalidToken: //Invalid Token
                            sharedAuthGenerator.markDeviceUpgrade(for: number, retryUpgrade: false)
                            
                        default:
                            sharedAuthGenerator.markDeviceUpgrade(for: number, retryUpgrade: true)
                            if retryCount < 1 {
                                let updatedRetryCount = (retryCount + 1)
                                self.upgradeDevice(for: number, token, retryCount: updatedRetryCount)
                            }
                            //JRLoginUI.sharedInstance().signOut()
                        }
                        
                    } else {
                        sharedAuthGenerator.markDeviceUpgrade(for: number, retryUpgrade: true)
                        if retryCount < 1 {
                            let updatedRetryCount = (retryCount + 1)
                            self.upgradeDevice(for: number, token, retryCount: updatedRetryCount)
                        }
                    }
                }
            } catch {
            }
            
        }
    }
    
    private func upgradeAuthToken(for number: String, _ token: String, retryCount: Int = 0) {
        
        let sharedAuthGenerator = AuthRSAGenerator.shared
        
        if sharedAuthGenerator.shouldRetryOAuthUpgrade(for: number),
            let walletToken = LoginAuth.sharedInstance().getWalletToken(),
            walletToken.count > 40 {
            sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: false)
            return
        }
        
        if sharedAuthGenerator.shouldRetryOAuthUpgrade(for: number) {
            if token.count > 40 {
                sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: false)
                return
            }
        }
        
        
        JRLServiceManager.upgradeAuthToken(token) { (response, error) in
                        
            if let resp = response {
                if let ltokens = resp["tokens"] as? [[String: String]], ltokens.count > 0 {
                    for ltoken in ltokens {
                        if let scope = ltoken["scope"] {
                            if scope == "paytm" {
                                let paytmTokenDict: [String: String] = ltoken
                                LoginAuth.sharedInstance().setPaytmTokenDict(paytmTokenDict)
                            }
                            if scope == "wallet" {
                                let walletTokenDict: [String: String] = ltoken
                                LoginAuth.sharedInstance().setWalletTokenDict(walletTokenDict)
                            }
                        }
                    }
                    sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: false)
                    
                } else if let responseCode = resp[LOGINWSKeys.kError] as? String {
                    
                    switch responseCode {
                    case LOGINRCkeys.scopeNotRefreshable, LOGINRCkeys.invalidToken:
                        sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: false)
                        
                    default:
                        sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: true)
                        if retryCount < 1 {
                            let updatedRetryCount = (retryCount + 1)
                            self.upgradeAuthToken(for: number, token, retryCount: updatedRetryCount)
                        }
                    }
                }
            } else {
                
                sharedAuthGenerator.markOAuthUpgrade(for: number, retryUpgrade: true)
                if retryCount < 1 {
                    let updatedRetryCount = (retryCount + 1)
                    self.upgradeAuthToken(for: number, token, retryCount: updatedRetryCount)
                }
            }
        }
    }
}

extension LoginAuth {
    internal func getDefaultParameters() -> [String:Any]? {
        if let delegate = LoginAuth.sharedInstance().delegate {
            return delegate.getDefaultParams()
        }
        return nil
    }
}
