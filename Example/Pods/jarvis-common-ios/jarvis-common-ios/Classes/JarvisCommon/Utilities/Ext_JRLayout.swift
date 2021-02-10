//
//  Ext_JRLayout.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 03/06/19.
//

import UIKit

public extension JRLayout
{
    func itemCount() -> Int
    {
        if self.items == nil
        {
            return 0
        }
        return self.items.count
    }
}
