//
//  RoomsDataSource.swift
//  PricePredicter
//
//  Created by Matthew Mathias on 6/6/17.
//  Copyright © 2017 BigNerdRanch. All rights reserved.
//

import Foundation

struct RoomsDataSource {
    private let items = Array(0...10)
    
    var count: Int {
        return items.count
    }
    
    func title(for index: Int) -> String? {
        guard index < items.count else { return nil }
        return String(items[index])
    }
    
    func value(for index: Int) -> Double? {
        guard index < items.count else { return nil }
        return Double(items[index])
    }
}
