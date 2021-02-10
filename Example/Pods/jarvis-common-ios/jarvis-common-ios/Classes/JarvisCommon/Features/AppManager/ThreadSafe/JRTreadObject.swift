//
//  JRTreadObject.swift
//  jarvis-common-ios
//
//  Created by Nasib Ali on 13/02/20.
//

import Foundation

/// Base class for all threaded objects. Provides asyncronous and syncronous
/// views for writting and reading respectively.
public class JRThreadedObject<Element> {
    
    /// Underlying value to be accessed by the different views.
    internal var threadedValue: Element
    
    /// Dispatch queue to control interactions with this object.
    private var queue: DispatchQueue
    
    /// The type of dispatch queue used in this object; either concurrent or
    /// serial.
    public private(set) var JRThreadingType: JRThreadingType
    
    internal init(_ value: Element, type: JRThreadingType) {
        self.threadedValue = value
        self.JRThreadingType = type
        if type == .concurrent {
            self.queue = DispatchQueue(
                label: JRLabelDispatch.get(),
                attributes: .concurrent
            )
        } else {
            self.queue = DispatchQueue(label: JRLabelDispatch.get())
        }
    }
    
    /// Asyncronous interaction with this object; used for writting to
    /// the underlying value.
    public func async(_ callback: @escaping (inout Element) -> Void) {
        switch (JRThreadingType) {
        case .concurrent:
            queue.async(flags: .barrier) { callback(&self.threadedValue) }
            
        case .serial:
            queue.async { callback(&self.threadedValue) }
        }
    }
    
    /// Syncronous internaction with this object; used for reading from the
    /// underlying value.
    public func sync<JRReturnType>(_ callback: @escaping (Element) -> JRReturnType) -> JRReturnType {
        return queue.sync { return callback(self.threadedValue) }
    }
    
    /// Mutable syncronous interaction with this object; used when needing to
    /// both read and write to the underlying value.
    public func mutatingSync<JRReturnType> (_ callback: @escaping (inout Element) -> JRReturnType) -> JRReturnType {
        return queue.sync(flags: .barrier) {
            return callback(&self.threadedValue)
        }
    }
}
