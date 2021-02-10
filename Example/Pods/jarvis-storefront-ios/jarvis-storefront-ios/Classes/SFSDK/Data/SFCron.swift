

//
//  Created by Abhishek Tripathi on 18/04/19.
//  Copyright © 2019 Abhishek Tripathi. All rights reserved.
//

import Foundation



class SFCron {
    
    private enum CronState {
        case suspended
        case resumed
    }
    
    private var state: CronState = .suspended
    private let timeInterval: TimeInterval!
    private var eventHandler: (() ->Void)? = { }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            
            DispatchQueue.main.async {
                self?.eventHandler?()
            }
        })
        return t
    }()
    
    
    
    init(timeInterval: TimeInterval, handler: (() ->Void)?) {
        self.eventHandler = handler
        self.timeInterval = timeInterval
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }

    func resumeWithTimeReset() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        timer.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
}
