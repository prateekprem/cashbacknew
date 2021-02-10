//
//  RequestReference.swift
//  jarvis-network-ios
//
//  Created by Bhabani Shankar Prusty on 27/09/19.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public protocol Corelatable {
    var corelationId: String { get }
}

public protocol RequestReferenceable: Cancellable, Corelatable {

}

struct RequestReference {
    var task: Cancellable
    var corelationRefId: String
}

extension RequestReference: RequestReferenceable {

    func cancel() {
        task.cancel()
    }

    public var corelationId: String {
        return corelationRefId
    }

}

extension URLSessionTask: Cancellable {

}

extension URLRequest: Corelatable {

    public var corelationId: String {
        let id = value(forHTTPHeaderField: CorrelationIDGenerator.correlationHeaderKey)
        return id ?? ""
    }

}
