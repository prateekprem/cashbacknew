//
//  TokenRetryHandler.swift
//  Pods
//
//  Created by Abhinav Kumar Roy on 27/11/19.
//

import UIKit
import jarvis_network_ios
import jarvis_utility_ios
import jarvis_auth_ios

public enum TokenRetryResult{
    // Either the token was already present or successfuly udpated the token
    case success(_ token : String)
    
    // Failed to fetch token, need relogin
    case failureWithLogin
    
    // Other failure cases, doesn't need relogin
    case failure
    
}

public typealias TokenRetryCompletion = ((_ result : TokenRetryResult) -> ())

public class TokenRetryHandler: NSObject {
    
    
    /// Method to fetch wallet token with retry mechansism
    /// @Description - Fetch wallet token with following logic
    ///                     1. Check if present in Keychain - return completion
    ///                     2. Hit Api for token with following results
    ///                          a) If api is success - Store in keychain and return completion
    ///                          b) If api is failed - show relogin screen
    ///
    /// @Return - Return completion with a result enum:
    ///             a) If success return token as associated type
    ///             b) If failed shows relogin
    ///
    public class func fetchWalletTokenWithRetry(forVertical vertical : JRVertical,
                                                andController controller : JRBaseVC,
                                                withCompletion completion : TokenRetryCompletion?){
        
        //Check if wallet token is already present in keychain
        if let walletToken = ModuleRouter.getManager(forModule: .jarvis)?.getWalletToken(){
            completion?(.success(walletToken))
        }else{
            //Check if the user is logged in
            if LoginAuth.sharedInstance().isLoggedIn(){
                //Hit API and fetch wallet Token
                LoginAuth.getWalletTokenWith { (_, _, _) in
                    //Check if wallet token is present now
                    if let walletToken = ModuleRouter.getManager(forModule: .jarvis)?.getWalletToken(){
                        completion?(.success(walletToken))
                    }else{
                        //Wallet token is still not present: Show Relogin
                        completion?(.failureWithLogin)
                        controller.launchLoginViewDue(toAuthenticationError: false, withError: nil, withTitle: "Login", bySkippingStep2: false)
                        
                        //User Token api failed again
                        //TODO: Log this failure to HawkEye later (No structure for new event is available right now)
                    }
                }
            }else{
                //User is not logged in return error
                completion?(.failure)
            }
        }
    }

}
