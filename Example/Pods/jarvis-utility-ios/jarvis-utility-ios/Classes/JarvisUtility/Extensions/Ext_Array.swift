//
//  Ext_Array.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    public mutating func removeObject(_ object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    public mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

extension Array {
    public mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

extension NSArray {
    @objc
    func arrayByReplacingNullsWithBlanks() -> NSArray? {
        guard let mutableArray = self.mutableCopy() as? NSMutableArray else { return nil }
        for (index, item) in mutableArray.enumerated() {
            switch item {
            case is NSNull:
                mutableArray[index] = ""
            case let arrayItem as NSArray:
                mutableArray[index] = arrayItem.arrayByReplacingNullsWithBlanks() ?? ""
            case let dictItem as NSDictionary:
                mutableArray[index] = dictItem.dictionaryByReplacingNullsWithBlanks() ?? ""
            default:
                continue
            }
        }
        return mutableArray.copy() as? NSArray
    }
    
    @objc
    func getFullMutableCopy() -> NSMutableArray? {
        guard let mutableArray = self.mutableCopy() as? NSMutableArray else { return nil }
        for (index, item) in mutableArray.enumerated() {
            switch item {
            case let arrayItem as NSArray:
                guard let mutablArrayItem = arrayItem.getFullMutableCopy() else { continue }
                mutableArray[index] = mutablArrayItem
            case let dictItem as NSDictionary:
                guard let mutabldictItem = dictItem.getFullMutableCopy() else { continue }
                mutableArray[index] = mutabldictItem
            default:
                continue
            }
        }
        return mutableArray.mutableCopy() as? NSMutableArray
    }
}
