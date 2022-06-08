//
//  OnlineRecordModel.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import Foundation

struct OnlineRecordModel: Codable {
    let userUid: String
    let timeStamp: Double
    let recordTime: String
    var name: String?
    var recordUid: String
}
