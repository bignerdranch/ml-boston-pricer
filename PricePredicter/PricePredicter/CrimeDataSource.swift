//
//  CrimeDataSource.swift
//  PricePredicter
//
//  Created by Matthew Mathias on 6/6/17.
//  Copyright © 2017 BigNerdRanch. All rights reserved.
//

import Foundation

struct CrimeDataSource {
    let rates = Array(stride(from: 0.0, through: 0.2, by: 0.01))
    
    var count: Int {
        return rates.count
    }
    
    func title(for index: Int) -> String? {
        guard index < rates.count else { return nil }
        return String(rates[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < rates.count else { return nil }
        return rates[index]
    }
}
