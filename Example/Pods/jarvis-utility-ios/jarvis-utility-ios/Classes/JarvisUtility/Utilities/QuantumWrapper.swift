//
//  QuantumWrapper.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 07/05/19.
//  Copyright © 2019 Nikita Maheshwari. All rights reserved.
//

import Foundation

enum QuantumError: Error {

    case missingValue
    case invalidValue
}

public struct QuantumString: Decodable {
    
    public private(set) var value: String
    
    public init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        if let val = try? container.decode(String.self) {
            self.value = val
            return
        }
        
        if let string = try? container.decode(Int.self) {
            self.value = String(string)
            return
        }
        
        if let string = try? container.decode(Float.self) {
            self.value = String(string)
            return
        }
        
        throw QuantumError.missingValue
    }
}

public struct QuantumBool: Decodable {
    
    public private(set) var value: Bool
    
    public init(from decoder: Decoder) throws {
        
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if let val = try? container.decode(Bool.self) {
            try self.init(with: val)
            return
        }
        if let string = try? container.decode(String.self) {
            try self.init(with: string)
            return
        }
        throw QuantumError.missingValue
    }
    
    private init(with stringLiteral: String) throws {
        
        switch stringLiteral.uppercased() {
            
        case "TRUE", "YES", "1", "SUCCESS":
            self.value = true
        case "FALSE", "NO", "0", "FAIL":
            self.value = false
        default:
            throw QuantumError.invalidValue
        }
    }
    
    private init(with value: Bool) throws {
        self.value = value
    }
}
