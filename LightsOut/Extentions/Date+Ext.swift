//
//  Date+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

extension Date {
    func convertToStringWithFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func convertToDayAndMount() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: self)
    }
}
