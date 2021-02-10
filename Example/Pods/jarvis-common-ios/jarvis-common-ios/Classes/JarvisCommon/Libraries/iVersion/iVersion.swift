//
//  iVersion.swift
//  jarvis-common-ios
//
//  Created by Lokesh kumar on 01/12/20.
//

import Foundation

enum iVersionErrorCode : Int {
    case bundleIdDoesNotMatch = 1
    case applicationNotFound
    case osVersionNotSupported
    case unexpectedDataFormat
    case invalidURL
    case noData
    case invalidJson
}

enum iVersionUpdatePriority : Int {
    case `default` = 0
    case low = 1
    case medium = 2
    case high = 3
}

struct iVersionLocaleKeys {
    static let currentVersionTitle: String = "iVersionInThisVersionTitle"
    static let updateAvailableTitle: String = "iVersionUpdateAvailableTitle"
    static let labelFormat: String = "iVersionVersionLabelFormat"
    static let okButton: String = "iVersionOKButton"
    static let ignoreButton: String = "iVersionIgnoreButton"
    static let remindButton: String = "iVersionRemindButton"
    static let downloadButton: String = "iVersionDownloadButton"
}

struct iVersionPreferenceKeys {
    static let appStoreID = "iVersionAppStoreID"
    static let lastVersion = "iVersionLastVersionChecked"
    static let ignoreVersion = "iVersionIgnoreVersion"
    static let lastChecked = "iVersionLastChecked"
    static let lastReminded = "iVersionLastReminded"
}

struct iVersionErrorMessage {
    static let invalidAppURL: String = "Invalid app url."
    static let bundleIdDoesNotMatch: String = "Application bundle ID does not match expected value of"
    static let osVersionNotSupported: String = "Current OS version is not supported."
    static let unexpectedDataFormat: String = "Unexpected data format."
    static let applicationNotFound: String = "The application could not be found on the App Store."
    static let noData: String = "No data returned from Server."
    static let invalidJson: String = "Unable to serialize json returned from Server."
}

protocol iVersionDelegate: class {
    func iVersionShouldCheckForNewVersion() -> Bool
    func iVersionDidNotDetectNewVersion()
    func iVersionVersionCheckDidFailWithError(_ error: Error!)
    func iVersionDidDetectNewVersion(_ version: String!, details versionDetails: String!)
    func iVersionShouldDisplayNewVersion(_ version: String?, details versionDetails: String?) -> Bool?
    func iVersionShouldDisplayCurrentVersionDetails(_ versionDetails: String?) -> Bool?
    func iVersionUserDidAttempt(toDownloadUpdate version: String?)
    func iVersionUserDidRequestReminder(forUpdate version: String?)
    func iVersionUserDidIgnoreUpdate(_ version: String?)
    func iVersionShouldOpenAppStore() -> Bool?
    func iVersionDidPresentStoreKitModal()
    func iVersionDidDismissStoreKitModal()
}
extension iVersionDelegate {
    func iVersionShouldCheckForNewVersion() -> Bool {
        return true
    }
    func iVersionDidNotDetectNewVersion() {
        print("iVersionDidNotDetectNewVersion")
    }
    func iVersionVersionCheckDidFailWithError(_ error: Error!) {
        print("iVersionVersionCheckDidFailWithError")
    }
    func iVersionDidDetectNewVersion(_ version: String!, details versionDetails: String!) {
        print("iVersionDidDetectNewVersion")
    }
    func iVersionShouldDisplayNewVersion(_ version: String?, details versionDetails: String?) -> Bool? {
        print("iVersionShouldDisplayNewVersion")
        return nil
    }
    func iVersionShouldDisplayCurrentVersionDetails(_ versionDetails: String?) -> Bool? {
        print("iVersionShouldDisplayCurrentVersionDetails")
        return nil
    }
    func iVersionUserDidAttempt(toDownloadUpdate version: String?) {
        print("iVersionUserDidAttempt")
    }
    func iVersionUserDidRequestReminder(forUpdate version: String?) {
        print("iVersionUserDidRequestReminder")
    }
    func iVersionUserDidIgnoreUpdate(_ version: String?) {
        print("iVersionUserDidIgnoreUpdate")
    }
    func iVersionShouldOpenAppStore() -> Bool? {
        print("iVersionShouldOpenAppStore")
        return nil
    }
    func iVersionDidPresentStoreKitModal() {
        print("iVersionDidPresentStoreKitModal")
    }
    func iVersionDidDismissStoreKitModal() {
        print("iVersionDidDismissStoreKitModal")
    }
}
public final class iVersion {
    public private(set) static var shared : iVersion = iVersion()

    private let iVersionErrorDomain = "iVersionErrorDomain"
    
    //application details - these are set automatically
    private var applicationVersion: String
    private var applicationBundleID: String
    private var appStoreCountry: String
    //usage settings - these have sensible defaults
    private var showOnFirstLaunch = false
    private var groupNotesByVersion = false
    private var checkPeriod: Float
    private var remindPeriod: Float

    private let SECONDS_IN_A_DAY = 86400.0
    let REQUEST_TIMEOUT = 60.0
    
    var appStoreID : String {
        get {
            return UserDefaults.standard.object(forKey: iVersionPreferenceKeys.appStoreID) as? String ?? ""
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: iVersionPreferenceKeys.appStoreID)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var lastChecked : Date? {
        get {
            return UserDefaults.standard.object(forKey: iVersionPreferenceKeys.lastChecked) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: iVersionPreferenceKeys.lastChecked)
            UserDefaults.standard.synchronize()
        }
    }
    private var lastReminded : Date? {
        get {
            return UserDefaults.standard.object(forKey: iVersionPreferenceKeys.lastReminded) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: iVersionPreferenceKeys.lastReminded)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var ignoredVersion : String? {
        get {
            return UserDefaults.standard.object(forKey: iVersionPreferenceKeys.ignoreVersion) as? String
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: iVersionPreferenceKeys.ignoreVersion)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var viewedVersionDetails : Bool {
        get {
            return (UserDefaults.standard.object(forKey: iVersionPreferenceKeys.lastVersion) as? String == self.applicationVersion)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue , forKey: iVersionPreferenceKeys.lastVersion)
            UserDefaults.standard.synchronize()
        }
    }
    
    private var lastVersion : String? {
        get {
            return UserDefaults.standard.object(forKey: iVersionPreferenceKeys.lastVersion) as? String
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: iVersionPreferenceKeys.lastVersion)
            UserDefaults.standard.synchronize()
        }
    }
    
    private lazy var inThisVersionTitle : String = {
        self.localizedString(forKey: iVersionLocaleKeys.currentVersionTitle, withDefault: "New in this version")
    }()
    private lazy var updateAvailableTitle : String = {
        self.localizedString(forKey: iVersionLocaleKeys.updateAvailableTitle, withDefault: "New version available")
    }()
    private lazy var versionLabelFormat : String = {
        self.localizedString(forKey: iVersionLocaleKeys.labelFormat, withDefault: "Version %@")
    }()
    private lazy var okButtonLabel : String = {
        self.localizedString(forKey: iVersionLocaleKeys.okButton, withDefault: NSLocalizedString("OK", comment: ""))
    }()
    private lazy var ignoreButtonLabel : String = {
        self.localizedString(forKey: iVersionLocaleKeys.ignoreButton, withDefault: "Ignore")
    }()
    private lazy var downloadButtonLabel : String = {
        self.localizedString(forKey: iVersionLocaleKeys.downloadButton, withDefault: "Download")
    }()
    private lazy var remindButtonLabel : String = {
        self.localizedString(forKey: iVersionLocaleKeys.remindButton, withDefault: "Remind Me Later")
    }()

    //debugging and prompt overrides
    private var updatePriority: iVersionUpdatePriority
    private var useUIAlertControllerIfAvailable = false
    private var useAllAvailableLanguages : Bool
    private var onlyPromptIfMainWindowIsAvailable : Bool
    private var useAppStoreDetailsIfNoPlistEntryFound = false
    private var checkAtLaunch : Bool
    private var verboseLogging = false
    private var previewMode = false

    //advanced properties for implementing custom behaviour
    private var localVersionsPlistPath: String?
    var updateURL: URL?
    weak var delegate: iVersionDelegate?

    private var remoteVersionsDict: [String : Any]?
    private var downloadError: Error?
    private var visibleLocalAlert: JRCustomAlertController?
    private var visibleRemoteAlert: JRCustomAlertController?
    private var checkingForNewVersion = false
    
    private static var localizedStringBundle: Bundle? = nil
    private static var versionsDict: [String : Any]? = nil

    private init() {
        appStoreCountry = ""
        if let apStrCountry = (NSLocale.current as NSLocale).object(forKey: .countryCode) as? String {
            if apStrCountry == "150" {
                appStoreCountry = "eu"
            } else if !(apStrCountry.replacingOccurrences(of: "[A-Za-z]{2}", with: "", options: .regularExpression, range:  Range(NSMakeRange(0, 2), in: apStrCountry)).isEmpty) {
                appStoreCountry = "us"
            }
            else{
                appStoreCountry = apStrCountry
            }
        }
        //application version (use short version preferentially)
        if let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            applicationVersion = shortVersion
        }
        else {
            applicationVersion = ""
        }
        if applicationVersion.isEmpty {
            if let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
                applicationVersion = version
            }
        }
        //application bundle id
        if let bundleID = Bundle.main.bundleIdentifier {
            applicationBundleID = bundleID
        }
        else {
            applicationBundleID = ""
        }
        //default settings
        updatePriority = .default
        useAllAvailableLanguages = true
        onlyPromptIfMainWindowIsAvailable = true
        checkAtLaunch = true
        checkPeriod = 0.0
        remindPeriod = 1.0

        #if DEBUG
        //enable verbose logging in debug mode
        verboseLogging = true
        #endif
        //app launched
        applicationLaunched()
    }
    
    public class func sharedInstance() -> iVersion {
        return iVersion.shared
    }

    private func localizedString(forKey key: String, withDefault defaultString: String) -> String {
        if iVersion.localizedStringBundle == nil {
            var bundlePath = Bundle(for: iVersion.self).path(forResource: "iVersion", ofType: "bundle")
            if useAllAvailableLanguages {
                iVersion.localizedStringBundle = Bundle(path: bundlePath ?? "")
                var language = NSLocale.preferredLanguages.count != 0 ? NSLocale.preferredLanguages[0] : "en"
                if !(iVersion.localizedStringBundle?.localizations.contains(language) ?? false) {
                    language = language.components(separatedBy: "-")[0]
                }
                if iVersion.localizedStringBundle?.localizations.contains(language) ?? false {
                    bundlePath = iVersion.localizedStringBundle?.path(forResource: language, ofType: "lproj")
                }
            }
            if let bndlPath = bundlePath , let bundle = Bundle(path: bndlPath) {
                iVersion.localizedStringBundle = bundle
            } else {
                iVersion.localizedStringBundle = Bundle.main
            }
        }
        let defaultStringVal = iVersion.localizedStringBundle?.localizedString(forKey: key, value: defaultString, table: nil)
        return Bundle.main.localizedString(forKey: key, value: defaultStringVal, table: nil)
    }
    private func localVersionsDict() -> [String : Any]? {
        if iVersion.versionsDict == nil {
            if let localVrsnsPlistPath = localVersionsPlistPath {
                var versionsFile: String = ""
                if let resourcePath = Bundle.main.resourcePath {
                    versionsFile = URL(fileURLWithPath: resourcePath).appendingPathComponent(localVrsnsPlistPath).path
                    iVersion.versionsDict = NSDictionary(contentsOfFile: versionsFile) as? [String: Any]
                }
                if iVersion.versionsDict == nil {
                    let pathComponents = localVrsnsPlistPath.components(separatedBy: ".")
                    if pathComponents.count == 2 , let path = Bundle.main.path(forResource: pathComponents[0], ofType: pathComponents[1]) {
                            versionsFile = path
                        }
                    iVersion.versionsDict = NSDictionary(contentsOfFile: versionsFile) as? [String: Any]
                }
            } else {
                iVersion.versionsDict = [String : Any]()
            }
        }
        return iVersion.versionsDict
    }
    private func mostRecentVersion(inDict dict: [String : Any]?) -> String? {
        if let versions = dict?.keys.sorted(by: { (s1, s2) -> Bool in
            return s1.compareVersion(s2) == .orderedAscending
        }) {
            return versions.last
        }
        return nil
    }
    private func versionDetails(_ version: String, inDict dict: [String : Any]?) -> String? {
        if let versonData = dict?[version] as? String {
            return versonData
        }
        if let versonData = dict?[version] as? [String] {
            return versonData.joined(separator: "\n")
        }
        return nil
    }
    private func versionDetails(since lastVersion: String?, inDict dict: [String : Any]?) -> String? {
        guard let versionDict = dict else {
            return nil;
        }
        var wrappedlastVersion = "0"
        if !previewMode {
            if let version = lastVersion {
                wrappedlastVersion = version
            }
        }
        var newVersionFound = false
        var details = ""
        let versions = versionDict.keys.sorted(by: { (s1, s2) -> Bool in
            return s1.compareVersion(s2) == .orderedDescending
        })
        for version in versions {
                if version.compareVersion(wrappedlastVersion) == .orderedDescending {
                    newVersionFound = true
                    if groupNotesByVersion {
                        details += versionLabelFormat.replacingOccurrences(of: "%@", with: version)
                        details += "\n\n"
                    }
                    if let vrsn = versionDetails(version, inDict: dict) {
                        details += vrsn
                    }
                    details += "\n"
                    if groupNotesByVersion {
                        details += "\n"
                    }
                }
        }
        return newVersionFound ? details.trimmingCharacters(in: CharacterSet.newlines) : nil
    }
    private lazy var versionDetails: String? = {
        if viewedVersionDetails {
            return self.versionDetails(self.applicationVersion, inDict: self.localVersionsDict())
        } else {
            return self.versionDetails(since: lastVersion, inDict: self.localVersionsDict())
        }
    }()
    private func downloadedVersionsData() {
        if checkingForNewVersion {
            if remoteVersionsDict == nil {
                //log the error
                if downloadError != nil {
                    print("iVersion update check failed because: \(String(describing: downloadError?.localizedDescription))")
                } else {
                    print("iVersion update check failed because an unknown error occured")
                }
                self.delegate?.iVersionVersionCheckDidFailWithError(self.downloadError)
                return
            }
            let details = versionDetails(since: applicationVersion, inDict: remoteVersionsDict)
            let mostRecentVersion = self.mostRecentVersion(inDict: remoteVersionsDict)
            if ((details) != nil)
            {
                self.delegate?.iVersionDidDetectNewVersion(mostRecentVersion, details: details)
                //check if ignored
                var showDetails = !(ignoredVersion == mostRecentVersion) || previewMode
                if showDetails {
                    if let showDtls = self.delegate?.iVersionShouldDisplayNewVersion(mostRecentVersion, details: details) {
                        showDetails = showDtls
                    }
                    if !showDetails && verboseLogging {
                        print("iVersion did not display the new version because the iVersionShouldDisplayNewVersion:details: delegate method returned NO")
                    }
                } else if verboseLogging {
                    print("iVersion did not display the new version because it was marked as ignored")
                }
                if showDetails && (visibleRemoteAlert == nil) {
                    var title = updateAvailableTitle
                    if !groupNotesByVersion {
                        title = title + " (\(mostRecentVersion ?? ""))"
                    }
                    visibleRemoteAlert = showAlert(withTitle: title, details: details, defaultButton: downloadButtonLabel, ignoreButton: showIgnoreButton() ? ignoreButtonLabel : nil, remindButton: showRemindButton() ? remindButtonLabel : nil)
                }
            }
            else {
                self.delegate?.iVersionDidNotDetectNewVersion()
            }
        }
    }
    public func shouldCheckForNewVersion() -> Bool {
            if !previewMode {
                //check if within the reminder period
                if let lastReminded = lastReminded {
                    //reminder takes priority over check period
                    if Date().timeIntervalSince(lastReminded) < Double(remindPeriod) * SECONDS_IN_A_DAY {
                        if verboseLogging {
                            print("iVersion did not check for a new version because the user last asked to be reminded less than \(remindPeriod) days ago")
                        }
                        return false
                    }
                } else if lastChecked != nil && Date().timeIntervalSince(lastChecked ?? Date()) < Double(checkPeriod) * SECONDS_IN_A_DAY {
                    if verboseLogging {
                        print("iVersion did not check for a new version because the last check was less than \(checkPeriod) days ago")
                    }
                    return false
                }
            }
            else if verboseLogging {
                print("iVersion debug mode is enabled - make sure you disable this for release")
            }
            //confirm with delegate
            let shouldCheck = self.delegate?.iVersionShouldCheckForNewVersion()
            if !(shouldCheck ?? true) && verboseLogging {
                print("iVersion did not check for a new version because the iVersionShouldCheckForNewVersion delegate method returned NO")
            }
            return shouldCheck ?? true
    }
    private func value(forKey key: String, inJSON json: Any?) -> String? {
        if let json = json as? [String : Any] {
            return json.getOptionalStringForKey(key)
        }
        return nil
    }
    private func callCheckForNewVersion() {
        guard let url = self.formattediTunesURL()  else {
            self.proceedAfterApiCall(with: nil, error: self.errorObject(errorCode: .invalidURL, message: iVersionErrorMessage.noData))
            return
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = REQUEST_TIMEOUT
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            var osVersionSupported = false
            var versions: [String : Any]? = nil
            var errorObj : Error? = nil
            if error != nil {
                self.proceedAfterApiCall(with: nil, error: error)
                return
            }
            guard let data = data else {
                self.proceedAfterApiCall(with: nil, error: self.errorObject(errorCode: .noData, message: iVersionErrorMessage.noData))
                return
            }
            guard let jsonDict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                self.proceedAfterApiCall(with: nil, error: self.errorObject(errorCode: .invalidJson, message: iVersionErrorMessage.invalidJson))
                return
            }
            guard let results = jsonDict["results"] as? [[String : Any]], let json = results.last else {
                self.proceedAfterApiCall(with: nil, error: self.errorObject(errorCode: .unexpectedDataFormat, message: iVersionErrorMessage.unexpectedDataFormat))
                return
            }
            if let bundleID = self.value(forKey: "bundleId", inJSON: json) {
                if bundleID == self.applicationBundleID {
                    let minimumSupportedOSVersion = self.value(forKey: "minimumOsVersion", inJSON: json)
                    let systemVersion = UIDevice.current.systemVersion
                    osVersionSupported = (systemVersion.compare(minimumSupportedOSVersion ?? "", options: .numeric, range: nil, locale: .current) != .orderedAscending)
                    if !osVersionSupported {
                        errorObj = self.errorObject(errorCode: .osVersionNotSupported, message: iVersionErrorMessage.osVersionNotSupported)
                    }
                    let releaseNotes = self.value(forKey: "releaseNotes", inJSON: json)
                    if let lstVersion = self.value(forKey: "version", inJSON: json) {
                        if osVersionSupported {
                            versions = [
                                lstVersion: releaseNotes ?? ""
                            ]
                        }
                    }
                    if (self.appStoreID.isBlank()) {
                        if let appStoreIDString = self.value(forKey: "trackId", inJSON: json) {
                            self.appStoreID = appStoreIDString
                        }
                    }
                }
                else {
                    errorObj = self.errorObject(errorCode: .bundleIdDoesNotMatch, message: iVersionErrorMessage.bundleIdDoesNotMatch)
                }
            }
            else if (!self.appStoreID.isEmpty) {
                errorObj = self.errorObject(errorCode: .applicationNotFound, message: iVersionErrorMessage.applicationNotFound)
            }
            self.proceedAfterApiCall(with: versions, error: errorObj)
        }
        task.resume()
    }
    private func formattediTunesURL() -> URL? {
        var iTunesServiceURL = "https://itunes.apple.com/\(appStoreCountry)/lookup"
        if (!appStoreID.isEmpty) {
            iTunesServiceURL = iTunesServiceURL + "?id=\(appStoreID)"
        } else {
            iTunesServiceURL = iTunesServiceURL + "?bundleId=\(applicationBundleID)"
        }
        return URL(string: iTunesServiceURL)
    }
    private func proceedAfterApiCall(with versionsData: [String : Any]?, error: Error?) {
        DispatchQueue.main.async {
            self.downloadError = error
            self.remoteVersionsDict = versionsData
            self.lastChecked = Date()
            self.downloadedVersionsData()
        }
    }
    public func checkForNewVersion() {
        if !checkingForNewVersion {
            checkingForNewVersion = true
            self.callCheckForNewVersion()
        }
    }
    private func checkIfNewVersion() {
        if lastVersion != nil || showOnFirstLaunch || previewMode {
            if applicationVersion.compareVersion(lastVersion ?? "0") == .orderedDescending || previewMode {
                //clear reminder
                lastReminded = nil
                //get version details
                var showDetails = (versionDetails != nil)
                if let status = self.delegate?.iVersionShouldDisplayCurrentVersionDetails(versionDetails) {
                    showDetails = status
                }
                //show details
                if showDetails && (visibleLocalAlert == nil) && (visibleRemoteAlert == nil) {
                    visibleLocalAlert = showAlert(withTitle: inThisVersionTitle, details: versionDetails, defaultButton: okButtonLabel, ignoreButton: nil, remindButton: nil)
                }
            }
        }
        else {
            viewedVersionDetails = true
        }
    }
    private func showIgnoreButton() -> Bool {
        return (!ignoreButtonLabel.isEmpty) && updatePriority.rawValue < iVersionUpdatePriority.medium.rawValue
    }
    private func showRemindButton() -> Bool {
        return (!remindButtonLabel.isEmpty) && updatePriority.rawValue < iVersionUpdatePriority.high.rawValue
    }
    private func showAlert(withTitle title: String?, details: String?, defaultButton: String?, ignoreButton: String?, remindButton: String?) -> JRCustomAlertController? {
        var topController = UIApplication.shared.delegate?.window??.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        if let topController = topController {
            let alert = JRCustomAlertController.controller(title: title, message: details)
            //download/ok action
            alert.addAction(AlertAction(title: downloadButtonLabel, style: .default, handler: { (action) in
                self.didDismissAlert(alert, withButtonAt: 0)
                topController.dismiss(animated: true)
            }))
            if showRemindButton() {
                alert.addAction(AlertAction(title: remindButtonLabel, style: .default, handler: { (action) in
                    self.didDismissAlert(alert, withButtonAt: self.showIgnoreButton() ? 2 : 1)
                    topController.dismiss(animated: true)
                }))
            }
            //ignore action
            if showIgnoreButton() {
                alert.addAction(AlertAction(title: ignoreButtonLabel, style: .cancel, handler: { (action) in
                    self.didDismissAlert(alert, withButtonAt: 1)
                    topController.dismiss(animated: true)
                }))
            }
            //get current view controller and present alert
            topController.present(alert, animated: true)

            return alert
        }
        return nil
    }
    private func didDismissAlert(_ alertView: JRCustomAlertController?, withButtonAt buttonIndex: Int) {
        let downloadButtonIndex = 0
        var ignoreButtonIndex = 0
        var remindButtonIndex = 0
        if showIgnoreButton() {
            ignoreButtonIndex = 1
        }
        if showRemindButton() {
            remindButtonIndex = ignoreButtonIndex + 1
        }
        //latest version
        let latestVersion = mostRecentVersion(inDict: remoteVersionsDict)

        if alertView == visibleLocalAlert {
            //record that details have been viewed
            viewedVersionDetails = true

            //release alert
            visibleLocalAlert = nil
            return
        }
        if buttonIndex == downloadButtonIndex {
            //clear reminder
            lastReminded = nil
            //log event
            self.delegate?.iVersionUserDidAttempt(toDownloadUpdate: latestVersion)
            let shouldOpen = self.delegate?.iVersionShouldOpenAppStore()
            if shouldOpen == nil || shouldOpen == true {
                openAppPageInAppStore()
            }
        } else if buttonIndex == ignoreButtonIndex {
            //ignore this version
            ignoredVersion = latestVersion
            lastReminded = nil
            self.delegate?.iVersionUserDidIgnoreUpdate(latestVersion)
        }
        else if buttonIndex == remindButtonIndex {
            //remind later
            lastReminded = Date()
            self.delegate?.iVersionUserDidRequestReminder(forUpdate: latestVersion)
        }
        //release alert
        visibleRemoteAlert = nil
    }
    private func openAppPageInAppStore() {
        if (updateURL == nil && !self.appStoreID.isEmpty)
        {
            if verboseLogging {
                print("iVersion was unable to open the App Store because the app store ID is not set.")
            }
        }
        if let url = self.updateURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func applicationLaunched() {
        if checkAtLaunch {
            checkIfNewVersion()
            if shouldCheckForNewVersion() {
                checkForNewVersion()
            }
        } else if verboseLogging {
            print("iVersion will not check for updates because the checkAtLaunch option is disabled")
        }
    }
    private func errorObject(errorCode: iVersionErrorCode, message: String) -> Error {
        return NSError(domain: self.iVersionErrorDomain, code: errorCode.rawValue, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
    }
}
public extension String {
    func compareVersion(_ version: String) -> ComparisonResult {
        return compare(version , options: .numeric, range: nil, locale: .current)
    }
}
