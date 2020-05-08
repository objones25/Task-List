//
//  ConversionFuncs.swift
//  Task List
//
//  Created by Owen Jones on 5/7/20.
//  Copyright © 2020 Owen Jones. All rights reserved.
//

import Foundation

struct ConversionFuncs{
    
    func urgencyScore(urgency: Int)-> String{
        
        switch urgency {
        case 0..<20:
            let string = "Is this a joke"
            return string
        case 21..<40:
            let string = "this seems easy"
            return string
        case 41..<70:
            let string = "ok this is enough"
            return string
        case 71..<100:
            let string = "we can stop now"
            return string
        case 101..<140:
            let string = "I don't like where this is going"
            return string
        case 141...:
            let string = "I think I might need an extension"
            return string
        default:
            let string = "You didn't tell me nothing"
            return string
        }
    }
// converts points to a string. Mainly is a placeholder until I get algorithm working
    
    func dateFormatter(date: Date )-> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date)
        return dateString
    }
    
}
// convert items of type date to type string
