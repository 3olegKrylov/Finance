//
//  StructOfMoment.swift
//  OlegFinance
//
//  Created by 3oleg_krylov on 02.02.2020.
//  Copyright © 2020 3oleg_krylov. All rights reserved.
//

import UIKit

struct momentOfDate {
    
    var key: NSDate
    var open: String
    var high: String
    var low: String
    var close: String
    var volume: String
    
    init( key: NSDate, open: String, high: String, low: String, close: String, volume: String) {
        self.key = key
         self.open = open
         self.high = high
         self.low = low
         self.close = close
         self.volume = volume
    }
}


struct momentDoubleOfDate {
    
    var key: NSDate
    var open: Double
    var high:Double
    var low: Double
    var close: Double
    var volume: Int
    
    init( key: NSDate, open: Double, high: Double, low: Double, close: Double, volume: Int) {
        self.key = key
         self.open = open
         self.high = high
         self.low = low
         self.close = close
         self.volume = volume
    }
}
