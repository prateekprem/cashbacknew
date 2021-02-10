//
//  JRThreadType.swift
//  jarvis-common-ios
//
//  Created by Nasib Ali on 13/02/20.
//

import Foundation

public enum JRThreadingType {
    
    /// Allows concurrent reads on threaded objects.
    /// When writting, concurrency is disabled.
    case concurrent
    
    /// All operations, reads and writes, are executed sequentially.
    case serial
    
}


public protocol JRThreadedCollection {
    
    associatedtype InternalCollectionType
    
    /// Returns an unmanaged version of the underlying object.
    var unthreaded: InternalCollectionType { get }
}



internal class JRLabelDispatch {
    
    private static var nextId = 0
    
    internal static func get() -> String {
        let id = nextId
        nextId += 1
        return "com.threading.dispatchqueue_\(id)"
    }
}
