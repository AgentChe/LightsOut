//
//  Double+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

extension Double {
    func convertThreePointString() -> String {
        return String(format: "%.3f", (self))
    }
}
