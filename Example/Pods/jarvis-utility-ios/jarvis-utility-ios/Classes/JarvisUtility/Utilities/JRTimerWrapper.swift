//
//  JRTimerWrapper.swift
//  Jarvis
//
//  Created by pooja soni on 26/12/17.
//  Copyright © 2017 One97. All rights reserved.
//

import Foundation

public class JRTimerWrapper: NSObject {
    fileprivate var timer: Timer!
    fileprivate var block: ((JRTimerWrapper)->Void)!
    
    public init(interval: TimeInterval, block: @escaping ((JRTimerWrapper)->Void)) {
        super.init()
        setup(interval: interval, repeats: true, block: block)
    }
    
    public init(interval: TimeInterval, repeats: Bool, block: @escaping ((JRTimerWrapper)->Void)) {
        super.init()
        setup(interval: interval, repeats: repeats, block: block)
    }
    
    private func setup(interval: TimeInterval, repeats: Bool, block: @escaping ((JRTimerWrapper)->Void)) {
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(tick), userInfo: nil, repeats: repeats)
        self.block = block
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    
    deinit {
        invalidate()
        block = nil
    }
    
    public func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func tick() {
        block(self)
    }
}
