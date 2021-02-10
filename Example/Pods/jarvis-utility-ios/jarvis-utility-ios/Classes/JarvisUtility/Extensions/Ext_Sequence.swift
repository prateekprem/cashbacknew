//
//  Ext_Sequence.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Sequence {
    
    public typealias ClosureCompare = (Iterator.Element, Iterator.Element) -> ComparisonResult
    
    public func sorted(by comparisons: ClosureCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1, e2)
                guard comparisonResult == .orderedSame
                    else { return comparisonResult == .orderedAscending }
            }
            return false
        }
    }
}
