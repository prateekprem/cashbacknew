//
//  JRPaytmLoaderAnimationView.swift
//  Jarvis
//
//  Created by Mohit Jain on 12/01/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import Lottie

@objc public class JRPaytmLoaderAnimationView: NSObject {

    @objc public func infinitePlay(viewAnimate : LOTAnimationView) {
        viewAnimate.play{ (finished) in
            self.infinitePlay(viewAnimate: viewAnimate)
        }
    }

}
