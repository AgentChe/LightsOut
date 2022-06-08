//
//  Double+Ext.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 25.05.2022.
//

import Foundation

extension Double {
    func convertThreePointString() -> String {
        return String(format: "%.3f", (self))
    }
}
