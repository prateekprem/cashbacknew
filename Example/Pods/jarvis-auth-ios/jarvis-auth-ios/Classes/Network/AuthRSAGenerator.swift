//
//  AuthSecKeys.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 07/05/20.
//

import Foundation
import Security
import jarvis_utility_ios

// Singleton instance
public let _singletonInstance = AuthRSAGenerator()

public enum CryptoException: Error {
    case keyPairNotGenerated
    case invalidKeyForDecryption
    case invalidKeyForEncryption
}

public class AuthRSAGenerator: NSObject {
    
    private enum JRAuthRSAKeychainKeys : String {
        case rsaKeyPair = "JRAUTH_RSA_KEY_PAIR"
        case privateKey = "JRAUTH_PRIVATE_KEY"
        case publicKey = "JRAUTH_PUBLIC_KEY"
        case retryDeviceUpgrade = "JRAUTH_RETRY_DEVICE_UPGRADE"
        case retryOAuthUpgrade = "JRAUTH_RETRY_OAUTH_UPGRADE"
    }
    
    /** Shared instance */
    public class var shared: AuthRSAGenerator {
        return _singletonInstance
    }
    
    private var publicKey: PublicKey?
    internal var privateKey: PrivateKey?
    private var loginIdArrForRecentGeneratedKeyPair: [String] = []
    
    internal func hasKeyPairStored(for mobileNumber: String) -> Bool {
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any] {
            return (keyPairs[mobileNumber] != nil)
        } else {
            return false
        }
    }
    
    internal func createKeyPair(for mobileNumber: String) throws {
        
        do {
            
            let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
            if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
                let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any],
                let correspondingKeyPair = keyPairs[mobileNumber] as? [String: Any],
                let privateKeyBase64 = correspondingKeyPair[JRAuthRSAKeychainKeys.privateKey.rawValue] as? String,
                let publicKeyBase64 = correspondingKeyPair[JRAuthRSAKeychainKeys.publicKey.rawValue] as? String {
                
                privateKey = try PrivateKey(base64Encoded: privateKeyBase64)
                publicKey = try PublicKey(base64Encoded: publicKeyBase64)
                
            } else {
                guard let keyPair = try? SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048) else {
                    throw CryptoException.keyPairNotGenerated
                }
                let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256
                
                guard SecKeyIsAlgorithmSupported(keyPair.privateKey.reference, .decrypt, algorithm) else {
                    throw CryptoException.invalidKeyForDecryption
                }
                
                guard SecKeyIsAlgorithmSupported(keyPair.publicKey.reference, .encrypt, algorithm) else {
                    throw CryptoException.invalidKeyForEncryption
                }
                
                publicKey = keyPair.publicKey
                privateKey = keyPair.privateKey
                
                storeKeyPairs(for: mobileNumber)
                
                loginIdArrForRecentGeneratedKeyPair.append(mobileNumber)
            }
        } catch {
            print("Unexpected error while creating Auth RSA Key Pair : \(error).")
        }
    }
    
    internal func isKeyPairRecentlyGenerated(for loginId: String) -> Bool{
        let isExist = loginIdArrForRecentGeneratedKeyPair.contains(loginId)
        return isExist
    }
    
    internal func refreshRecentlyGeneratedPublicKey(for loginId: String){
        let isExist = loginIdArrForRecentGeneratedKeyPair.contains(loginId)
        if isExist{
            loginIdArrForRecentGeneratedKeyPair.removeObject(loginId)
        }
    }
    
    private func storeKeyPairs(for mobileNumber: String) {
        guard let privateKey = privateKey, let publicKey = publicKey else {
            return
        }
        do {
            let base64PrivateKey = try privateKey.base64String()
            let base64PublicKey = try publicKey.base64String()
            let keyPairDictionary = [JRAuthRSAKeychainKeys.privateKey.rawValue: base64PrivateKey, JRAuthRSAKeychainKeys.publicKey.rawValue: base64PublicKey]
            let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
            
            if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
                let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any] {
                var updatedKeyPairs = keyPairs
                updatedKeyPairs[mobileNumber] = keyPairDictionary
                let keyPairObject = NSKeyedArchiver.archivedData(withRootObject: updatedKeyPairs)
                LoginAuth.sharedInstance().setKeyChainObject(object: keyPairObject, forKey: keychainKey)
                
            } else {
                let keyPairs = [mobileNumber: keyPairDictionary]
                let keyPairObject = NSKeyedArchiver.archivedData(withRootObject: keyPairs)
                LoginAuth.sharedInstance().setKeyChainObject(object: keyPairObject, forKey: keychainKey)
            }
        } catch {
            print("Unexpected error while storing Auth RSA Key Pair: \(error).")
        }
    }
    
    internal func shouldRetryDeviceUpgrade(for loginId: String) -> Bool {
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any],
            let keyPair = keyPairs[loginId] as? [String: Any],
            let shouldRetryDeviceUpgrade = keyPair[JRAuthRSAKeychainKeys.retryDeviceUpgrade.rawValue] as? Bool {
            return shouldRetryDeviceUpgrade
        } else {
            return false
        }
    }
    
    internal func markDeviceUpgrade(for loginId: String, retryUpgrade: Bool) {
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any] {
            
            if let keyPair = keyPairs[loginId] as? [String: Any] {
                var updatedKeyPair = keyPair
                updatedKeyPair[JRAuthRSAKeychainKeys.retryDeviceUpgrade.rawValue] = retryUpgrade
                var updatedKeyPairs = keyPairs
                updatedKeyPairs[loginId] = updatedKeyPair
                let keyPairObject = NSKeyedArchiver.archivedData(withRootObject: updatedKeyPairs)
                LoginAuth.sharedInstance().setKeyChainObject(object: keyPairObject, forKey: keychainKey)
            }
        }
    }
    
    internal func shouldRetryOAuthUpgrade(for loginId: String) -> Bool {
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any],
            let keyPair = keyPairs[loginId] as? [String: Any],
            let shouldRetryDeviceUpgrade = keyPair[JRAuthRSAKeychainKeys.retryOAuthUpgrade.rawValue] as? Bool {
            return shouldRetryDeviceUpgrade
        } else {
            return false
        }
    }
    
    internal func markOAuthUpgrade(for loginId: String, retryUpgrade: Bool) {
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any] {
            
            if let keyPair = keyPairs[loginId] as? [String: Any] {
                var updatedKeyPair = keyPair
                updatedKeyPair[JRAuthRSAKeychainKeys.retryDeviceUpgrade.rawValue] = false
                updatedKeyPair[JRAuthRSAKeychainKeys.retryOAuthUpgrade.rawValue] = retryUpgrade
                var updatedKeyPairs = keyPairs
                updatedKeyPairs[loginId] = updatedKeyPair
                let keyPairObject = NSKeyedArchiver.archivedData(withRootObject: updatedKeyPairs)
                LoginAuth.sharedInstance().setKeyChainObject(object: keyPairObject, forKey: keychainKey)
            }
        }
    }
    
    internal func removeSavedKeyPair(for mobileNumber: String) {
        publicKey = nil
        privateKey = nil
        loginIdArrForRecentGeneratedKeyPair.removeObject(mobileNumber)
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        if let serializedKeyPairs = LoginAuth.sharedInstance().keyChainObject(forKey: keychainKey) as? Data,
            let keyPairs = NSKeyedUnarchiver.unarchiveObject(with: serializedKeyPairs) as? [String: Any] {
            var updatedKeyPairs = keyPairs
            updatedKeyPairs[mobileNumber] = nil
            let keyPairObject = NSKeyedArchiver.archivedData(withRootObject: updatedKeyPairs)
            LoginAuth.sharedInstance().setKeyChainObject(object: keyPairObject, forKey: keychainKey)
        }
    }
    
    public func removeAllSavedKeyPair() {
        publicKey = nil
        privateKey = nil
        loginIdArrForRecentGeneratedKeyPair.removeAll()
        let keychainKey = JRAuthRSAKeychainKeys.rsaKeyPair.rawValue
        LoginAuth.sharedInstance().resetTokens()
        FXKeychain.default().removeObject(forKey: keychainKey)
    }
    
    internal func getPublicKeyBase64String() -> String {
        guard let lpublicKey = publicKey else {
            return ""
        }
        do {
            let data = try lpublicKey.data()
            let pkcs8Key = addPKCS8Header(data)
            return pkcs8Key.base64EncodedString()
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    private func addPKCS8Header(_ derKey: Data) -> Data {
        var result = Data()

        let encodingLength: Int = encodedOctets(derKey.count + 1).count
        let OID: [UInt8] = [0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
                            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]

        var builder: [UInt8] = []

        // ASN.1 SEQUENCE
        builder.append(0x30)

        // Overall size, made of OID + bitstring encoding + actual key
        let size = OID.count + 2 + encodingLength + derKey.count
        let encodedSize = encodedOctets(size)
        builder.append(contentsOf: encodedSize)
        result.append(builder, count: builder.count)
        result.append(OID, count: OID.count)
        builder.removeAll(keepingCapacity: false)

        builder.append(0x03)
        builder.append(contentsOf: encodedOctets(derKey.count + 1))
        builder.append(0x00)
        result.append(builder, count: builder.count)

        // Actual key bytes
        result.append(derKey)

        return result
    }

    private func encodedOctets(_ int: Int) -> [UInt8] {
        // Short form
        if int < 128 {
            return [UInt8(int)]
        }

        // Long form
        let i = (int / 256) + 1
        var len = int
        var result: [UInt8] = [UInt8(i + 0x80)]

        for _ in 0..<i {
            result.insert(UInt8(len & 0xFF), at: 1)
            len = len >> 8
        }

        return result
    }
    
    internal func signWithPrivateKey(seedString: String) -> String{
        
        guard let clearMessage = try? ClearMessage(string: seedString, using: .utf8) else {
            return ""
        }
        
        guard let lprivateKey = privateKey else{
            return ""
        }
        
        guard let signature = try? clearMessage.signed(with: lprivateKey, digestType: .sha256) else{
            return ""
        }
        return signature.base64String
    }
}
