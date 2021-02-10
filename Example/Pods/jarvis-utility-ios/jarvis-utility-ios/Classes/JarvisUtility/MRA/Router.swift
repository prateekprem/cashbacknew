//
//  Router.swift
//  Core
//
//  Created by Abhinav Kumar Roy on 19/07/19.
//  Copyright © 2019 Abhinav Roy. All rights reserved.
//

import UIKit

public enum Module : CaseIterable{
    case jarvis
    case common
    case utility
    case network
    case auth
    case locale
    case cashback
    case paytmFirst
    case paytmAnalytics
    case notification
    case wallet
    case channel
    case insurance
    case creditCard
    case inbox
    case bank
    case ru
}

public var ModuleRouter : Router{
    return Router.shared
}

public class Router: NSObject {
    fileprivate static var shared : Router = Router()
    private var moduleMap : [Module : CoreManager] = [Module : CoreManager]()
  
    public func register(manager : CoreManager, forModule module: Module, withConfig config : ModuleConfig){
        manager.moduleConfig = config
        moduleMap[module] = manager
    }
    
    public func getManager(forModule module : Module) -> CoreManager?{
        return moduleMap[module]
    }

}
