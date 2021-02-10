//
//  SSLPinningManager.swift
//  jarvis-network-ios
//
//  Created by Shivam Jaiswal on 12/10/20.
//

import Foundation

protocol SSLPinningManagerProtocol {
    func handleUrlSession(_ session: URLSession,
                          didReceive challenge: URLAuthenticationChallenge,
                          completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
}

public protocol SSLPinningManagerDelegate: AnyObject {
    func getPinningConfig() -> String?
}

public class SSLPinningManager: SSLPinningManagerProtocol {
    public static let shared = SSLPinningManager()
    public weak var delegate: SSLPinningManagerDelegate?
    
    func handleUrlSession(_ session: URLSession,
                          didReceive challenge: URLAuthenticationChallenge,
                          completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let domainHost = challenge.protectionSpace.host
        
        log("begin for \(domainHost)")
        guard (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            log("authenticationMethod failed")
            return
        }

        guard let delegate = self.delegate, let pinnigConfig = delegate.getPinningConfig(), !pinnigConfig.isEmpty else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
            log("pinningConfig is either empty or nil")
            return
        }
        
        log("pinnigConfig: \(pinnigConfig)")
        let configHandler = ConfigHandler(configString: pinnigConfig)
        guard let config = configHandler.enabledConfigForHost(domainHost) else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
            log("pinnigConfig not enabled for: \(domainHost)")
            return
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            log("serverTrust is nil")
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
            return
        }
        
        var secresult = SecTrustResultType.invalid
        guard errSecSuccess == SecTrustEvaluate(serverTrust, &secresult) else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, URLCredential(trust:serverTrust))
            log("serverTrust evaluatation failed")
            return
        }
                
        log("generating server public key of root")
        let certificateCount = SecTrustGetCertificateCount(serverTrust)
        guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, certificateCount - 1),
            let certPublicKey = publicKey(for: serverCertificate),
            let serverPublicKeyData = SecKeyCopyExternalRepresentation(certPublicKey, nil ) as Data?
            else {
                completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, URLCredential(trust:serverTrust))
                log("server public key of root failed")
                return
        }
        
        //Check Public key value
        let serverPublicKey = JRSHA256Crypto.sha256(data: serverPublicKeyData)
        let localPublicKey = config.value
        log("matchig serverPublicKey: \(serverPublicKey) with localPublicKey: \(localPublicKey)")

        guard serverPublicKey == localPublicKey else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, URLCredential(trust:serverTrust))
            log("matchig failed")
            return
        }
        
        log("matched")
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
    }
}

extension SSLPinningManager {
    private func publicKey(for certificate: SecCertificate) -> SecKey? {
        if #available(iOS 12.0, *) {
            return SecCertificateCopyKey(certificate)
        } else if #available(iOS 10.3, *) {
            return SecCertificateCopyPublicKey(certificate)
        } else {
            var possibleTrust: SecTrust?
            SecTrustCreateWithCertificates(certificate, SecPolicyCreateBasicX509(), &possibleTrust)
            guard let trust = possibleTrust else { return nil }
            var result: SecTrustResultType = .unspecified
            SecTrustEvaluate(trust, &result)
            return SecTrustCopyPublicKey(trust)
        }
    }
    
    private func log(_ text: String ) {
        #if DEBUG
        debugPrint("SSL Pinning: \(text)")
        #endif
    }
}

extension SSLPinningManager {
    final class ConfigHandler {
        private let allConfigs: [Config]
        init(configString: String) {
            self.allConfigs = ConfigHandler.array(from: configString).compactMap({Config(dict: $0)})
        }
        
        func enabledConfigForHost(_ domainHost: String) -> Config? {
            return allConfigs.first(where: { $0.isEnabled && domainHost.contains($0.domain) })
        }
        
        private static func array(from text: String) -> [[String: Any]] {
            guard let data = text.data(using: .utf8) else { return [] }
            let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            return result ?? []
        }
    }
    
    struct Config {
        let domain: String
        let value: String
        let isEnabled: Bool
        
        init?(dict: [String: Any]) {
            guard let domain = dict["domain"] as? String, let value = dict["value"] as? String, let isEnabled = dict["isEnabled"] as? Bool else { return nil }
            self.value = value
            self.domain = domain.replacingOccurrences(of: "*", with: "")
            self.isEnabled = isEnabled
        }
    }
}
