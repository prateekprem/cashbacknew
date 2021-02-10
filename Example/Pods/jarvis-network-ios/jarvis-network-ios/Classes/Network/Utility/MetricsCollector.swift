//
//  JRNetworkUtility.swift
//  jarvis-network-ios
//
//  Created by Bhabani Shankar Prusty on 14/06/19.
//

import Foundation

final class MetricsCollector {
    private var responseMetrics: [UUID : IDMetrics] = [UUID : IDMetrics]()
    private let queue = DispatchQueue(label: "com.jarvis.metricCollector")
    final class IDMetrics {
        private(set) var id: Int
        var metrics: URLSessionTaskMetrics?
        init(id: Int) {
            self.id = id
        }
    }
    
    func set(listner task: URLSessionTask, for id: UUID){
        queue.sync {
            responseMetrics[id] = IDMetrics(id: task.taskIdentifier)
        }
    }
    
    func push(metrics taskMetrics: URLSessionTaskMetrics, for task: URLSessionTask) {
        queue.sync {
            let metrics = responseMetrics.values.first { $0.id == task.taskIdentifier }
            metrics?.metrics = taskMetrics
        }
    }
    
    func pop(id: UUID) -> URLSessionTaskMetrics? {
        var metrics: URLSessionTaskMetrics?
        queue.sync {
            metrics = responseMetrics[id]?.metrics
            responseMetrics[id] = nil
        }
        return metrics
    }
}
