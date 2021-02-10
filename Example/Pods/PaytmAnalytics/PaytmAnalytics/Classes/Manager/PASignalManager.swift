//
//  PASignalManager.swift
//  PaytmAnalytics
//
//  Created by Paytm Labs on 2020-10-15.
//  
//


import Foundation

public class PASignalManager {
    
    public static let shared = PASignalManager()
    
    /// Initializes Signal session with given configuration parameters.
    ///
    /// - Parameters:
    ///     - clientId: **[Mandatory]** Designated client id for the hosting app
    ///     - secretKey: **[Mandatory]** Designated secret key for the hosting app
    ///     - signalEndpointDomain: **[Mandatory]** The domain url string used to perform events uploading
    ///     - loggingEnabled: A boolean variable indicating whether logging is turned on or not, the default value is `false`
    ///     - dispatchStrategy: The dispatch strategy used to periodically upload signal events, the default value is `.intervalBased(10.0)`
    ///     - maxBatchSizeToUpload: The maximum number of events allowed for each upload, if the value being set is greater than 10,
    ///                             then events to be uploaded will be grouped into batches of at most 10 events each.
    ///     - maxBatchSizeToCapture: The maximum number of events allowed to be temporarily stored in the local database before geting
    ///                              uploaded. This value MUST be greater than or equal to `maxBatchSizeToUpload`.
    ///     - buildType: The runtime environment of the SDK, the default value is `.release`
    ///
    /// Please note that logging will be turned off when `buildType` is assigned with `.release`, regardless of the value
    /// being assigned to `loggingEnabled`.
    public func initializeSignalSession(clientId: String,
                                        secretKey: String,
                                        signalEndpointDomain: String,
                                        loggingEnabled: Bool = false,
                                        dispatchStrategy: DispatchStrategy = .intervalBased(interval: 10.0),
                                        maxBatchSizeToUpload: Int = 10,
                                        maxBatchSizeToCapture: Int = 2000,
                                        buildType: PABuildType = .release) {
        // Make sure secret key and client id being passed in correctly
        assert(!clientId.isEmpty && !secretKey.isEmpty, "[Signal Configuration] secret key and/or client id is missing", file: "PAConfiguration.swift")
        
        // Initialize Signal session
        let signalSession = PASignalSession.shared
        
        //make sure debug is disabled in release mode
        signalSession.isLoggingEnabled = loggingEnabled && buildType == .debug
        
        signalSession.dispatchStrategy = dispatchStrategy
        signalSession.maxBatchSizeToUpload = maxBatchSizeToUpload
        
        // Using max(a, b) here just to make sure `maxBatchSizeToUpload` won't be accidentally set
        // to a value greater than `maxBatchSizeToCapture`
        signalSession.maxBatchSizeToCapture = max(maxBatchSizeToCapture, maxBatchSizeToUpload)

        signalSession.clientID = clientId
        signalSession.secretKey = secretKey
        
        var endpointDomain = signalEndpointDomain
        if !signalEndpointDomain.hasPrefix("https://") {
            endpointDomain = "https://\(endpointDomain)"
        }
        if endpointDomain.hasSuffix("/") {
            endpointDomain.removeLast()
        }
        signalSession.requestUrlString = "\(endpointDomain)\(PAConstant.Signal.V2_ENDPOINT)"
        
        // Only get app launch time once
        if signalSession.appLaunchTime.isEmpty {
            signalSession.appLaunchTime = String(UInt64((Date().timeIntervalSince1970 * 1000).rounded(.down)))
        }
        
        PALogger.log(message: "[Signal Configuration] Initializing Signal SDK Session & Dispatcher...")
        
        signalSession.setSignalSessionId()
        
        // Initialzie dispatcher
        PASignalDispatcher.shared.startDispatching()
    }
    
    /// Initializes Hawkeye session with given configuration parameters
    ///
    /// - Parameters:
    ///     - appId: **[Mandatory]** Designated api key for the hosting app
    ///     - origin: **[Mandatory]** Designated name for the hosting app
    ///     - clientId: **[Mandatory]** Designated client id for the hosting app
    ///     - secretKey: **[Mandatory]** Designated secret key for the hosting app
    ///     - requestUrl: **[Mandatory]** The request url string used to perform events uploading
    ///     - loggingEnabled: A boolean variable indicating whether logging is turned on or not, the default value is `false`
    ///     - dispatchStrategy: The dispatch strategy used to periodically upload signal events, the default value is `.manual`
    ///     - maxBatchSizeToUpload: The maximum number of events allowed for each upload
    ///     - maxBatchSizeToCapture: The maximum number of events allowed to be temporarily stored in the local database before geting
    ///                              uploaded. This value MUST be greater than or equal to `maxBatchSizeToUpload`.
    ///     - buildType: The runtime environment of the SDK, the default value is `.release`
    ///
    /// Please note that logging will be turned off when `buildType` is assigned with `.release`, regardless of the value
    /// being assigned to `loggingEnabled`.
    public func initializeNetworkSession(appId: String,
                                         origin: String,
                                         clientId: String,
                                         secretKey: String,
                                         requestUrl: String,
                                         loggingEnabled: Bool = false,
                                         dispatchStrategy: DispatchStrategy = .manual,
                                         maxBatchSizeToUpload: Int = 50,
                                         maxBatchSizeToCapture: Int = 2000,
                                         buildType: PABuildType = .release) {
        // Initialize Hawkeye session
        let networkSession = PANetworkSession.shared
        networkSession.origin = origin
        networkSession.appId = appId
        networkSession.clientId = clientId
        networkSession.appSecret = secretKey
        networkSession.requestUrlString = requestUrl
        networkSession.isLoggingEnabled = loggingEnabled && buildType == .debug
        networkSession.dispatchStrategy = dispatchStrategy
        networkSession.maxBatchSizeToUpload = maxBatchSizeToUpload
        networkSession.maxBatchSizeToCapture = maxBatchSizeToCapture
        networkSession.buildType = buildType
        
        networkSession.setNetworkSessionId()
        
        PALogger.log(message: "[Hawkeye Configuration] Initializing Network SDK Session & Dispatcher...")
        
        // Initialize dispatcher
        PANetworkDispatcher.shared.startDispatching()
    }
    
    // MARK: - Public methods
    
    /// Pushes a signal event and store it in local database
    ///
    /// - Parameter signalLog: The signal event to be inserted to local database
    public func push(withPASignalLog signalLog: PASignalLog) {
        PASignalSession.shared.push(withPASignalLog: signalLog)
    }

    /// Sends an array of critical events to server directly using specific completion handler without push them into database.
    /// Please note that the events will be divided into batches of at most 10 events if the total number of events is greater than 10.
    ///
    /// - Parameters:
    ///     - signalLogs: An array of critical events to be sent to server
    ///     - completion: A completion block to be executed when sending critical events to server finishes, this
    ///                   block takes two parameters of which the first indicates whether there are errors occurred
    ///                   when sending given events to server, the second is an array contains the events that failed
    ///                   to be sent to server, which have been pushed into database
    public func sendCriticalEvents(_ signalLogs: [PASignalLog], completion: ((Bool, [PASignalLog]?) -> Void)?) {
        PASignalSession.shared.sendCriticalEvents(signalLogs, completion: completion)
    }
    
    /// Pushes a network event and store it in local database
    ///
    /// - Parameter networkEvent: The network event to be inserted to local database
    public func push(withPANCEvent networkEvent: PANCEvent) {
        PANetworkSession.shared.push(withPANCEvent: networkEvent)
    }
    
    /// Delete all network events currently stored in local database
    public func flushNetworkEventData() {
        PANetworkSession.shared.deleteAllData()
    }
    
}
