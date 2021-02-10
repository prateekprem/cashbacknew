//
//  JRThreadedDictionary.swift
//  jarvis-common-ios
//
//  Created by Nasib Ali on 13/02/20.
//

import Foundation

public class JRThreadedDictionary<Key: Hashable, Value> : JRThreadedObject<Dictionary<Key, Value>> {
    
    public typealias InternalCollectionType = Dictionary<Key, Value>
    public typealias Index = InternalCollectionType.Index
    public typealias Element = InternalCollectionType.Element
    public typealias Keys = InternalCollectionType.Keys
    public typealias Values = InternalCollectionType.Values
    
    /// Constructs from an existing dictionary and a threading type.
    ///
    /// - parameters:
    ///     - dictionary: A dictionary who's elements will be copied to the
    ///                   threaded dictionary.
    ///
    ///     - type: The threading type which defines how this object should act.
    public override init(_ dictionary: [Key : Value], type: JRThreadingType) {
        super.init(dictionary, type: type)
    }
    
    /// Initializes with a blank dictionary and concurrent type.
    public convenience init() {
        self.init([Key : Value](), type: .concurrent)
    }
    
    /// Constructs from an existing dictionary.
    ///
    /// - parameters:
    ///     - dictionary: A dictionary who's elements will be copied to the
    ///                   threaded dictionary.
    ///
    /// Threading type is set to concurrent.
    public convenience init(_ dictionary: [Key : Value]) {
        self.init(dictionary, type: .concurrent)
    }
    
    /// Key style access for the dictionary.
    ///
    /// - parameters:
    ///     - key: Access key for the desired value.
    ///
    /// If no key-value pair exists in the dictionary with the given key, then
    /// the subscript returns nil.
    ///
    /// Setting a value to nil will remove that key-value pair from the
    /// dictionary.
    public subscript(key: Key) -> Value? {
        get {
            return sync { collection in
                return collection[key]
            }
        }
        set {
            async { collection in
                collection[key] = newValue
            }
        }
    }
}

// MARK: - Computed Properties

public extension JRThreadedDictionary {
    
    /// A collection containing just the keys of the dictionary.
    var keys: Keys {
        return sync { collection in
            return collection.keys
        }
    }
    
    /// A collection containing just the values of the dictionary.
    var values: Values {
        return sync { collection in
            return collection.values
        }
    }
}

// MARK: - Non-mutating Methods

public extension JRThreadedDictionary {
    
    func mapValues<T> (_ transform: @escaping (Value) -> T) -> [Key : T] {
        var result = [Key : T]()
        sync { collection in
            result = collection.mapValues(transform)
        }
        return result
    }
}


// MARK: - Threaded Collection Conformance

extension JRThreadedDictionary : JRThreadedCollection {
    
    /// Returns an unmanaged version of the underlying object.
    public var unthreaded: Dictionary<Key, Value> {
        return sync { collection in
            return collection
        }
    }
    
}

// MARK: - Swift Collection Conformance

extension JRThreadedDictionary : Collection {
    
    /// Positional based subscript for the dictionary.
    ///
    /// - parameters:
    ///     - position: The zero-indexed location of the element to access.
    ///                 `position` must be witin the range
    ///                 `startIndex..<endIndex`, otherwise a fatal, uncatchable
    ///                  exception will be thrown.
    public subscript(position: Index) -> Element {
        return sync { collection in
            return collection[position]
        }
    }
    
    /// Returns the position immediately after a given index.
    ///
    /// - parameters:
    ///     - i: A valid position in the collection,
    ///          i must be less than `endIndex`,
    public func index(after i: Index) -> Index {
        return sync { collection in
            return collection.index(after: i)
        }
    }
    
    /// The position of the first element in a non-empty dictionary.
    public var startIndex: Index {
        return sync { collection in
            return collection.startIndex
        }
    }
    
    /// The collection's "past the end" position – that is the position one
    /// past the last valid subscript argument.
    public var endIndex: Index {
        return sync { collection in
            return collection.endIndex
        }
    }
}

extension JRThreadedDictionary {
    func getOptionalString(_ key: Key) -> String? {
        if let y = self[key] as? String, !y.isEmpty {
            return y
        }
        if let y = self[key] as? Int {
            return String(y)
        }
        if let y = self[key] as? Double {
            return floor(y) == y ? String(format: "%.0f", y) : String(y)
        }
        if let y = self[key] as? Bool {
            return String(y)
        }
        return nil
    }
}
