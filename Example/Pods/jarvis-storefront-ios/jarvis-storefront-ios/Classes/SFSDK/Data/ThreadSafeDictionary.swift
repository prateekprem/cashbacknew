//
//  ThreadSafeDictionary.swift
//  jarvis-storefront-ios
//
//  Created by Pankaj Singh on 26/11/20.
//

import Foundation

public class SFThreadedDictionary<Key: Hashable, Value> : SFThreadedObject<Dictionary<Key, Value>> {
    
    typealias InternalCollectionType = Dictionary<Key, Value>
    typealias Element = InternalCollectionType.Element
    
    override init(_ dictionary: [Key : Value]) {
        super.init(dictionary)
    }
    
    convenience init() {
        self.init([Key : Value]())
    }
    
    subscript(key: Key) -> Value? {
        get {
            return getData { collection in
                return collection[key]
            }
        }
        set {
            setData { collection in
                collection[key] = newValue
            }
        }
    }
}

public class SFThreadedObject<Element> {
    
    var threadedValue: Element
    private var queue: DispatchQueue
    
    init(_ value: Element) {
        self.threadedValue = value
        self.queue = DispatchQueue(
            label: SFLabelDispatch.get(),
            attributes: .concurrent
        )
    }
    
    func setData(_ callback: @escaping (inout Element) -> Void) {
        queue.sync(flags: .barrier) { callback(&self.threadedValue) }
    }
    
    func getData<SFReturnType>(_ callback: @escaping (Element) -> SFReturnType) -> SFReturnType {
        return queue.sync { return callback(self.threadedValue) }
    }
}


enum SFThreadingType {
    case concurrent
    case serial
}


class SFLabelDispatch {
    
    private static var nextId = 0
    
    static func get() -> String {
        let id = nextId
        nextId += 1
        return "com.threading.sfdispatchqueue_\(id)"
    }
}
