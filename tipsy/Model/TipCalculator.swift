//
//  TipCalculator.swift
//  tipsy
//
//  Created by Sebastian Malm on 2/18/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import Foundation

struct TipCalculator {
    let billTotal: Double
    let tipPercentage: Double
    let splitQuantity: Int
    
    var totalPerPerson: Double {
        return ((1 + tipPercentage) * billTotal) / Double(splitQuantity)
    }
}

extension TipCalculator: CustomStringConvertible {
    var description: String {
        return "bill: \(billTotal), tip: \(tipPercentage), split: \(splitQuantity), totalPerPerson: \(totalPerPerson)"
    }
    
    
}
