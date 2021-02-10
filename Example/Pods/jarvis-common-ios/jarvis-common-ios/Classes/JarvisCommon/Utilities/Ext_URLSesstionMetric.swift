//
//  Ext_URLSesstionMetric.swift
//  jarvis-common-ios
//
//  Created by Bhabani Shankar Prusty on 14/06/19.
//
import Foundation

@available(iOS 10.0, *)
extension URLSessionTaskMetrics {
    private var totalTime: Double {
        return taskInterval.duration * 1000
    }
    
    private var requestTime: Double {
        var totalTime: Double = 0
        transactionMetrics.forEach { totalTime += millisecond(start: $0.requestStartDate,
                                                              end: $0.requestEndDate) }
        return totalTime
    }
    
    private var responseTime: Double {
        var totalTime: Double = 0
        transactionMetrics.forEach { totalTime += millisecond(start: $0.responseStartDate,
                                                              end: $0.responseEndDate) }
        return totalTime
    }
    
    private var connectionTime: Double {
        var totalTime: Double = 0
        transactionMetrics.forEach { totalTime += millisecond(start: $0.connectStartDate,
                                                              end: $0.connectEndDate) }
        return totalTime
    }
    
    private var domainlookupTime: Double {
        var totalTime: Double = 0
        transactionMetrics.forEach { totalTime += millisecond(start: $0.domainLookupStartDate,
                                                              end: $0.domainLookupEndDate) }
        return totalTime
    }
    
    private var secureConnectionTime: Double {
        var totalTime: Double = 0
        transactionMetrics.forEach { totalTime += millisecond(start: $0.secureConnectionStartDate,
                                                              end: $0.secureConnectionEndDate) }
        return totalTime
    }
    
    private func millisecond(start: Date?, end: Date?) -> Double {
        guard let startTime = start, let endTime = end else { return 0 }
        return endTime.timeIntervalSince(startTime) * 1000
    }
    
    var metrics: JRNetworkMetrics {
        return JRNetworkMetrics(totalTime: totalTime,
                                requestTime: requestTime,
                                responseTime: responseTime,
                                connectionTime: connectionTime,
                                domainlookupTime: domainlookupTime,
                                secureConnectionTime: secureConnectionTime)
    }
}

public struct JRNetworkMetrics {
    var totalTime: Double
    var requestTime: Double
    var responseTime: Double
    var connectionTime: Double
    var domainlookupTime: Double
    var secureConnectionTime: Double
}
