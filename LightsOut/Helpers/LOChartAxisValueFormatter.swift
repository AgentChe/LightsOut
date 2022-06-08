//
//  LOChartAxisValueFormatter.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation
import Charts

class LOChartAxisValueFormatter: IndexAxisValueFormatter {
    
    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        var lastWeekDays = [Date]()
        
        for i in 0...6 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            lastWeekDays.append(date)
        }

        let newStringArray = lastWeekDays.map { date in
            date.convertToDayAndMount()
        }
        
        return newStringArray[Int(value)]
    }

}
