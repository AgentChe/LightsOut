//
//  StatisticsVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 27.05.2022.
//

import UIKit
import Charts

class StatisticsVC: LODataLoadingVC {
    
    @IBOutlet var containerViewForChart: UIView!
    @IBOutlet var chartView: LineChartView!
    
    var chartEntrites: [ChartDataEntry]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        containerViewForChart.backgroundColor = .secondarySystemBackground
        containerViewForChart.layer.cornerRadius = 10
        chartView.backgroundColor = .clear
        chartView.isUserInteractionEnabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.gridLineDashLengths = [1,2]
        chartView.leftAxis.gridLineDashLengths = [1,2]
        chartView.xAxis.valueFormatter = LOChartAxisValueFormatter()
        chartView.leftAxis.labelCount = 3
        chartView.extraRightOffset = 20
        chartView.extraBottomOffset = 10
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .light)
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10, weight: .light)

        setChartValueWithLocalRecords()
    }


    func setChartValueWithLocalRecords(){
        
        DatabaseManager.shared.getLastFiveDaysRecordsFromSqliteDb { result in
            switch result {
                
            case .success(let avarages):
                let chartValuesForDates = [ChartDataEntry(x: 0, y: avarages[0].isNaN ? 0.0 : avarages[0]),
                                           ChartDataEntry(x: 1, y: avarages[1].isNaN ? 0.0 : avarages[1]),
                                           ChartDataEntry(x: 2, y: avarages[2].isNaN ? 0.0 : avarages[2]),
                                           ChartDataEntry(x: 3, y: avarages[3].isNaN ? 0.0 : avarages[3]),
                                           ChartDataEntry(x: 4, y: avarages[4].isNaN ? 0.0 : avarages[4]),
                                           ChartDataEntry(x: 5, y: avarages[5].isNaN ? 0.0 : avarages[5]),
                                           ChartDataEntry(x: 6, y: avarages[6].isNaN ? 0.0 : avarages[6])]

                print(avarages)
                let set1 = LineChartDataSet(entries: chartValuesForDates, label: "Your progression by last week (seconds)")
                set1.setColor(.systemRed)
                set1.drawCircleHoleEnabled = false
                set1.circleRadius = 2.5
                set1.circleColors = [.systemRed]
                set1.valueFont = UIFont.systemFont(ofSize: 10, weight: .bold)
                set1.lineDashLengths = [2,3]
                let data = LineChartData(dataSet: set1)
                self.chartView.data = data
            case .failure(let error):
                print("DEBUG: error \(error)")
            }
        }
        
    }
    
}
