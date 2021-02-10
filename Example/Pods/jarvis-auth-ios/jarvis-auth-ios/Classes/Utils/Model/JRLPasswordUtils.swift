//
//  JRLPasswordUtils.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 23/06/19.
//

import Foundation

public enum JRLPasswordStrength: String {
    case weak = "weak"
    case average = "average"
    case strong = "strong"
}

public struct JRLPasswordCharacterChecks {
    public var isMoreThan5Characters = false
    public var containsSpecialCharacter = false
    public var containsAlphabet = false
    public var containsNumber = false
    
    func bgcolor(_ b:Bool) -> UIColor{
        return b ? LOGINCOLOR.lightGreen : LOGINCOLOR.lightGray2
    }
    
    func img(_ b:Bool) -> UIImage?{
        let greyImage = UIImage(named: "icGreyTick", in: nil, compatibleWith: nil)
        let greenImage = UIImage(named: "icGreenTick", in: nil, compatibleWith: nil)
        return b ? greenImage : greyImage
    }
}

public class JRLPasswordUtils:NSObject{
    public class func strengthForPassword(password: String) -> (JRLPasswordStrength, JRLPasswordCharacterChecks){
        
        var pwdChecks = JRLPasswordCharacterChecks()
        // check if password contains at leaset five characters
        if password.count >= 5{
            pwdChecks.isMoreThan5Characters = true
        }
        
        // check if password conatins atleast 1 special character
        let specialCharacterRegx = ".*[^A-Za-z0-9].*"
        let specialCharacterPredicate = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegx)
        let containsSpecialCharacter =  specialCharacterPredicate.evaluate(with: password)
        pwdChecks.containsSpecialCharacter = containsSpecialCharacter
        
        // check if password conatins atleast 1 capital character
        let capitalLetterRegEx  = ".*[a-zA-Z]+.*"
        let capitalLetterPredicate = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let containsAlphabet =  capitalLetterPredicate.evaluate(with: password)
        pwdChecks.containsAlphabet = containsAlphabet
        
        // check if password conatins atleast 1 capital character
        let containsNumberRegEx  = ".*[0-9]+.*"
        let containsNumberPredicate = NSPredicate(format:"SELF MATCHES %@", containsNumberRegEx)
        let containsNumber =  containsNumberPredicate.evaluate(with: password)
        pwdChecks.containsNumber = containsNumber
        
        if password.count < 5{
            return (.weak, pwdChecks)
        }
        
        // analyzing password for weak strength
         /*Only number |
           only alpha |
           only special characters |
           At least 1 number At least 1 alpha (only smaller or upper case) No special character |
           No number |
           No alphabet
         */
        let weakPwdRegX = "[0-9]{5,99}|[a-zA-Z]{5,99}|[!@#$%^&*()\\-_=+{}|?>.<,:;\\[\\]~`’]{5,99}|[a-z0-9]{5,99}|[A-Z0-9]{5,99}|[a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;\\[\\]~`’]{5,99}|[0-9!@#$%^&*()\\-_=+{}|?>.<,:;\\[\\]~`’]{5,99}"
        let weakPwdPredicate = NSPredicate(format: "SELF MATCHES %@", weakPwdRegX)
        if weakPwdPredicate.evaluate(with: password){
            return (.weak, pwdChecks)
        }
        
        // Contains {“password”, “qwerty”, “paytm”}
        let names = ["password", "qwerty", "paytm"]
        for name in names {
            if password.lowercased().contains(name)  {
                return (.weak, pwdChecks)
            }
        }
        
        // Single character (alphabet or number) used 4 or more times consecutively
        var lastRepeatedChrCount = 0
        var lastChar : Character?
        for char in password{
            if char == lastChar{
                lastRepeatedChrCount += 1
                if lastRepeatedChrCount >= 3{
                    return (.weak, pwdChecks)
                }
            }else{
                lastRepeatedChrCount = 0
            }
            lastChar = char
        }
        
        // 4 or more consecutive characters used
        let digits = CharacterSet.decimalDigits
        let lowercase = CharacterSet(charactersIn: "a"..."z")
        let uppercase = CharacterSet(charactersIn: "A"..."Z")
        let controlSet = digits.union(lowercase).union(uppercase)
        
        for k in 1...2{
            var pwdString = ""
            if k == 1{
                pwdString = password
            }else{
                pwdString = String(password.reversed())
            }
            
            let scalars = pwdString.unicodeScalars
            let unicodeArray = scalars.map({ $0 })
            
            var currentLength: Int = 1
            var i = 0
            for number in unicodeArray {
                if !controlSet.contains(number){
                    i += 1
                    continue
                }
                if i+1 >= unicodeArray.count {
                    break
                }
                let nextNumber = unicodeArray[i+1]
                
                if UnicodeScalar(number.value+1) == nextNumber {
                    currentLength += 1
                } else {
                    currentLength = 1
                }
                if currentLength >= 4 {
                    return (.weak, pwdChecks)
                }
                i += 1
            }
        }
        
        
        // analyzing password for average strength
        /*
         At least 1 number
         At least1 small case
         At least 1 upper case
         No special character
        */
        let averagePwdRegX = "[a-zA-Z0-9]{5,99}"
        let averagePwdPredicate = NSPredicate(format: "SELF MATCHES %@", averagePwdRegX)
        if averagePwdPredicate.evaluate(with: password){
            return (.average, pwdChecks)
        }
        // analyzing password for strong strength
        /*
         At least 1 special character
         At least 1 number
         At least 1 small case
         At least 1 upper case
         */
        let strongPwdRegX = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()\\-_=+{}|?>.<,:;\\[\\]~`’]).{5,99}"
        let strongPwdPredicate = NSPredicate(format: "SELF MATCHES %@", strongPwdRegX)
        if strongPwdPredicate.evaluate(with: password){
            return (.strong, pwdChecks)
        }
        return (.average, pwdChecks)
    }
}
