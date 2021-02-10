//
//  JRCOProgressColltnCellVM.swift
//  Cashback
//
//  Created by Nikita Maheshwari on 13/05/19.
//  Copyright © 2019 Nikita Maheshwari. All rights reserved.
//

import Foundation

class JRCOProgressColltnCellVM {
    private(set) var totalTransaction : Int = 0
    private(set) var transactionDone  : Int = 0
    private(set) var numberOfItems    : Int = 0
       
    init(total: Int, isDone: Int, numItems: Int) {
        self.totalTransaction = total
        self.transactionDone = isDone
        self.numberOfItems = numItems
    }
}
