//
//  ConversionFuncs.swift
//  Task List
//
//  Created by Owen Jones on 5/7/20.
//  Copyright © 2020 Owen Jones. All rights reserved.
//

import Foundation

struct ConversionFuncs{
    
    func dateFormatter(date: Date )-> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date)
        return dateString
    }
    
    
    
}
// convert items of type date to type string
